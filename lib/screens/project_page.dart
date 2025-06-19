import 'package:flutter/material.dart';
import 'package:nonsense/screens/project_detail.dart';
import 'package:nonsense/views/project_view.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late DatabaseHelper dbHelper;
  late Future<List<ProjectView>> _projectViews;
  final ScrollController _scrollController = ScrollController();
  int numItems = 0;
  String searchTerm = '';
  Future<int> _getVocabularyListLength() async {
    return await _projectViews.then((value) {
      return value.length;
    });
  }

  List<ProjectView> filteredVocabularies = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshProjectViewList();
  }

  onSearch(String value) {
    searchTerm = value;
    _refreshProjectViewList();
  }

  void _refreshProjectViewList() {
    setState(() {
      if (searchTerm == '') {
        _projectViews = dbHelper.getProjectViews();
      } else {
        _projectViews = dbHelper.getFilteredProjectViews(searchTerm);
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
    var padding = MediaQuery.paddingOf(context);
    double displayHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double toScale = refHeight / displayHeight;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: notepaperWhite,
          ),
          backgroundColor: regularResultBGColour,
          title: SizedBox(
            height: 30,
            child: TextField(
              style: TextStyle(color: offWhite, fontSize: 16),
              onChanged: (value) => onSearch(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: inActiveLargeSetColour,
                hintText: "filter pojects",
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: offWhite),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                hintStyle: TextStyle(fontSize: 14, color: notepaperWhite),
              ),
            ),
          )),
      body: FutureBuilder<List<ProjectView>>(
        future: _projectViews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No projects found'));
          }
          return Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              itemCount: numItems,
              controller: _scrollController,
              itemBuilder: (context, index) {
                final projectView = snapshot.data![index];
                return Container(
                  padding: EdgeInsets.fromLTRB(5.0 * toScale, 2.0 * toScale,
                      5.0 * toScale, 5.0 * toScale),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: toScale, color: tanteRia),
                    ),
                    color: notepaperWhite,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(4, 0, 2, 0),
                          child: AutoSizeText(
                            projectView.type!,
                            style: TextStyle(
                              color: veryVeryDark
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              2, 0, 2 * toScale, 0),
                          child: AutoSizeText(
                            projectView.author!,
                              maxLines: 1,
                              style: TextStyle(
                                  color: veryVeryDark
                              ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(2, 0, 2, 0),
                          child: AutoSizeText(
                            projectView.title!,
                              maxLines: 1,
                              style: TextStyle(
                                  color: veryVeryDark
                              ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: veryVeryDark,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjectDetail(
                                      projectView: projectView),
                                ),
                              ).then((value) {
                                setState(() {
                                  _refreshProjectViewList();
                                });
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: veryVeryDark,
                            onPressed: () async {

                              final bool isDelete = await showConfirmationAlertDialog(
                                context,
                                title: 'Delete ${projectView.title!}?',
                                message: "Do you want to delete project '${projectView.title!}'? You cannot undo this!" ,
                                positiveText: 'Delete',
                                negativeText: 'Cancel',
                                highlightNegative: true,
                              );

                              if(isDelete){
                                await dbHelper.deleteProject(projectView);
                                _refreshProjectViewList();
                              }
                            },
                          ),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          ProjectView newProjectView = ProjectView.fromMap({
            // "id": newVocabulary.id,
            "typeId": null,
            "type": '',
            "authorId": null,
            "author": '',
            "title": newProjectTitle,
            "notes": 'notes'});
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetail(
                  projectView: newProjectView),
            ),
          ).then((value) {
            setState(() {
              _refreshProjectViewList();
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
  ) ?? false;
}
