import 'package:auto_size_text/auto_size_text.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/screens/template_detail.dart';
import 'package:balderdash/views/template_view.dart';
import 'package:flutter/material.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  late Future<List<TemplateView>> _templateViews;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController =
      TextEditingController(text: '');
  int numItems = 0;
  String searchTerm = '';
  Future<int> _getTemplateListLength() async {
    return await _templateViews.then((value) {
      return value.length;
    });
  }

  List<TemplateView> filteredTemplates = [];

  @override
  void initState() {
    super.initState();
    _refreshTemplateViewList();
  }

  onSearch() {
    _refreshTemplateViewList();
  }

  void _refreshTemplateViewList() {
    setState(() {
      if (searchController.text.isEmpty) {
        _templateViews = DatabaseHelper().getTemplateViews();
      } else {
        _templateViews =
            DatabaseHelper().getFilteredTemplateViews(searchController.text);
      }
      _getTemplateListLength().then((value) {
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
            color: violetNotePaperColour,
          ),
          backgroundColor: regularResultBGColour,
          title: SizedBox(
            height: 30 * scaling,
            child: TextField(
              style: TextStyle(color: offWhite, fontSize: 16 * scaling),
              controller: searchController,
              onChanged: (value) => onSearch(),
              decoration: InputDecoration(
                filled: true,
                fillColor: inActiveLargeSetColour,
                hintText: "filter templates",
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
        child: FutureBuilder<List<TemplateView>>(
          future: _templateViews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No templates found'));
            }
            return Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                itemCount: numItems,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final templateView = snapshot.data![index];
                  return Container(
                    height: 40 * scaling,
                    padding: EdgeInsets.fromLTRB(
                        5.0 * scaling, 0.0, 5.0 * scaling, 0.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: scaling, color: tanteRia),
                      ),
                      color: templateView.isHtml == 1
                          ? notepaperWhite
                          : notepaperLinked,
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
                              templateView.title ?? "",
                              style: TextStyle(
                                color: templateView.isHtml == 1
                                    ? greenAppbarColour
                                    : redAppbarColour,
                              ),
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
                              templateView.project!,
                              maxLines: 1,
                              style: TextStyle(
                                color: templateView.isHtml == 1
                                    ? greenAppbarColour
                                    : redAppbarColour,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: violetAppbarColour,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TemplateDetail(
                                      templateView: templateView),
                                ),
                              ).then((value) {
                                setState(() {
                                  _refreshTemplateViewList();
                                });
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: violetAppbarColour,
                            onPressed: () async {
                              final bool isDelete =
                                  await showConfirmationAlertDialog(
                                context,
                                title: 'Delete ${templateView.title!}?',
                                message:
                                    "Do you want to delete ${templateView.title!}? You cannot undo this!",
                                positiveText: 'Delete',
                                negativeText: 'Cancel',
                                highlightNegative: true,
                              );

                              if (isDelete) {
                                await DatabaseHelper()
                                    .deleteTemplate(templateView);
                                _refreshTemplateViewList();
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
        backgroundColor: violetNotePaperColour,
        child: const Icon(Icons.add),
        onPressed: () async {
          TemplateView newTemplateView = TemplateView.fromMap({
            // "id": newVocabulary.id,
            "projectId": null,
            "project": '',
            "title": newTemplateTitle,
            "content": '',
            "isHtml": 1,
            "notes": 'comment'
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TemplateDetail(templateView: newTemplateView),
            ),
          ).then((value) {
            setState(() {
              _refreshTemplateViewList();
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
