import 'package:auto_size_text/auto_size_text.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/screens/vocabulary_detail.dart';
import 'package:balderdash/views/vocabulary_view.dart';
import 'package:flutter/material.dart';

class VocabularyPageOld extends StatefulWidget {
  const VocabularyPageOld({super.key});

  @override
  State<VocabularyPageOld> createState() => _VocabularyPageOldState();
}

class _VocabularyPageOldState extends State<VocabularyPageOld> {
  late DatabaseHelper dbHelper;
  late Future<List<VocabularyView>> _vocabularyViews;
  final ScrollController _scrollController = ScrollController();
  int numItems = 0;
  String searchTerm = '';
  Future<int> _getVocabularyListLength() async {
    return await _vocabularyViews.then((value) {
      return value.length;
    });
  }

  List<VocabularyView> filteredVocabularies = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshVocabularyViewList();
  }

  onSearch(String value) {
    searchTerm = value;
    _refreshVocabularyViewList();
  }

  void _refreshVocabularyViewList() {
    setState(() {
      if (searchTerm == '') {
        _vocabularyViews = dbHelper.getVocabularyViews();
      } else {
        _vocabularyViews = dbHelper.getFilteredVocabularyViews(searchTerm);
      }
      _getVocabularyListLength().then((value) {
        setState(() {
          numItems = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: greenNotePaperColour,
          ),
          backgroundColor: regularResultBGColour,
          title: SizedBox(
            height: 30 * scaling,
            child: TextField(
              style: TextStyle(color: offWhite, fontSize: 16 * scaling),
              onChanged: (value) => onSearch(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: inActiveLargeSetColour,
                hintText: "filter vocabularies",
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: offWhite),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * scaling),
                    borderSide: BorderSide.none),
                hintStyle:
                    TextStyle(fontSize: 14 * scaling, color: notepaperWhite),
              ),
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightBlueGrey, blueGrey],
          ),
        ),
        child: FutureBuilder<List<VocabularyView>>(
          future: _vocabularyViews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No vocabularies found'));
            }
            return Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                itemCount: numItems,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final vocabularyView = snapshot.data![index];
                  return Container(
                    height: 40 * scaling,
                    padding: EdgeInsets.fromLTRB(
                        5.0 * scaling, 0.0, 5.0 * scaling, 0.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: scaling, color: tanteRia),
                      ),
                      color: notepaperWhite,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4 * scaling, 0, 2 * scaling, 0),
                            child: AutoSizeText(
                              vocabularyView.title!,
                              style: TextStyle(
                                  color: vocabularyView.useThis == 1
                                      ? veryVeryDark
                                      : lightBlueGrey),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2 * scaling, 0, 2 * scaling, 0),
                            child: AutoSizeText(
                              vocabularyView.category!,
                              maxLines: 1,
                              style: TextStyle(
                                  color: vocabularyView.useThis == 1
                                      ? inActiveLargeSetColour
                                      : lightBlueGrey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2 * scaling, 0, 2 * scaling, 0),
                            child: AutoSizeText(
                              vocabularyView.project!,
                              maxLines: 1,
                              style: TextStyle(
                                  color: vocabularyView.useThis == 1
                                      ? secondary
                                      : lightBlueGrey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: vocabularyView.useThis == 1
                                ? greenAppbarColour
                                : lightBlueGrey,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VocabularyDetail(
                                      vocabularyView: vocabularyView),
                                ),
                              ).then((value) {
                                setState(() {
                                  _refreshVocabularyViewList();
                                });
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: vocabularyView.useThis == 1
                                ? greenAppbarColour
                                : lightBlueGrey,
                            onPressed: () async {
                              final bool isDelete =
                                  await showConfirmationAlertDialog(
                                context,
                                title: 'Delete ${vocabularyView.title!}?',
                                message:
                                    "Do you want to delete ${vocabularyView.title!}? You cannot undo this!",
                                positiveText: 'Delete',
                                negativeText: 'Cancel',
                                highlightNegative: true,
                              );

                              if (isDelete) {
                                await dbHelper.deleteVocabulary(vocabularyView);
                                _refreshVocabularyViewList();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenNotePaperColour,
        child: const Icon(Icons.add),
        onPressed: () async {
          VocabularyView newVocabularyView = VocabularyView.fromMap({
            // "id": newVocabulary.id,
            "categoryId": null,
            "category": '',
            "projectId": null,
            "project": '',
            "title": newVocabularyTitle,
            "content": '',
            "comment": 'comment',
            "useThis": 1
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VocabularyDetail(vocabularyView: newVocabularyView),
            ),
          ).then((value) {
            setState(() {
              _refreshVocabularyViewList();
            });
          });
        },
      ),
    );
  }
}

Future<bool> showConfirmationAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String positiveText,
  required String negativeText,
  bool highlightPositive = false,
  bool highlightNegative = false,
}) async {
  return await showDialog<bool>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(
                  negativeText.toUpperCase(),
                  style: highlightNegative
                      ? const TextStyle(color: darkAnyMatchColour)
                      : null,
                ),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: Text(
                  positiveText.toUpperCase(),
                  style: highlightPositive
                      ? const TextStyle(color: Colors.red)
                      : null,
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          );
        },
      ) ??
      false;
}
