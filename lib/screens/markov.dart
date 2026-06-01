import 'dart:convert';
import 'dart:io';

import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/screens/vocabulary_detail.dart';
import 'package:balderdash/views/project_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../model/project.dart';
import '../utils/token_utils.dart';
import '../views/vocabulary_view.dart';

class Markov extends StatefulWidget {
  const Markov({super.key});

  @override
  State<Markov> createState() => _MarkovState();
}

class _MarkovState extends State<Markov> {
  final _settingsFormKey = GlobalKey<FormState>();
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  late Future<List<ProjectView>> _projectViews;
  final ScrollController _scrollController = ScrollController();
  bool initComplete = false;
  int numItems = 0;
  late int showNoNonsense = 1;
  String searchTerm = '';
  bool initialised = false;
  late Project curProject;
  late Future<List<Project>> _projects;
  late String importedPath;
  late String fileName;
  late String fileContent;
  List<String> lines = [];
  late Token token;
  String markovType = '';
  bool fileLoaded = false;

  List<ProjectView> filteredVocabularies = [];

  @override
  void initState() {
    super.initState();
    loadPreferences();
    // _refreshProjectViewList();
  }

  Future<void> loadPreferences() async {
    showNoNonsense = await asyncPrefs.getInt(noNonsense) ?? 1;
    int projectId = await asyncPrefs.getInt(appProject) ?? 1;
    _projects = DatabaseHelper().getProjectsAbove(0, showNoNonsense == 1);
    await setCurrentProject(projectId);
    // _refreshProjectViewList();
    initComplete = true;
  }

  Future<void> setCurrentProject(int id) async {
    curProject = await DatabaseHelper().getProject(id);
    _prjDDKey.currentState?.changeSelectedItem(curProject);
  }

  Future<void> openFile() async {
    File importedFile;

    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result != null) {
      importedFile = File(result.files.first.path!);
      importedPath = importedFile.path;
      fileContent = "_${String.fromCharCodes(importedFile.readAsBytesSync())}";
      fileName = importedFile.path
          .split(Platform.pathSeparator)
          .last
          .split(".")
          .first
          .replaceAll(RegExp(r'[\s_-]+'), '')
          .toUpperCase();
    } else {
      return;
    }
    fileContent = fileContent.replaceAll(RegExp(r'\s+'), '_').toLowerCase();
    fileContent = fileContent.replaceAll(RegExp('[^A-Za-z_]'), '');
    setState(() {
      if (fileContent.isEmpty) {
        fileLoaded = false;
      } else {
        fileLoaded = true;
      }
    });
  }

  void makeDigrams() {
    Token.clearTokenMap();
    // Token.addToToken("-", fileContent.substring(0, 1));
    for (var i = 0; i <= fileContent.length - 2; i++) {
      Token.addToToken(
        fileContent.substring(i, i + 1),
        fileContent.substring(i + 1, i + 2),
      );
    }
    Map<String, Map<String, int>> tokenMap = Token.getTokenMap();
    markovType = 'N2';
    createMarkovVocabulary(tokenMap);
  }

  void makeTrigrams() {
    Token.clearTokenMap();
    // Token.addToToken("-", fileContent.substring(0, 1));
    for (var i = 0; i <= fileContent.length - 3; i++) {
      if (fileContent.substring(i, i + 1) == '_') {
        Token.addToToken(('_'), fileContent.substring(i + 1, i + 3));
      } else if (fileContent.substring(i + 1, i + 2) != '_') {
        Token.addToToken(
          fileContent.substring(i, i + 2),
          fileContent.substring(i + 2, i + 3),
        );
      }
    }
    Map<String, Map<String, int>> tokenMap = Token.getTokenMap();
    markovType = 'N3';
    createMarkovVocabulary(tokenMap);
    // print(tokenMap.toString());
  }

  void make4grams() {
    Token.clearTokenMap();
    // Token.addToToken("-", fileContent.substring(0, 1));
    for (var i = 0; i <= fileContent.length - 4; i++) {
      if (fileContent.substring(i, i + 1) == '_') {
        Token.addToToken(('_'), fileContent.substring(i + 1, i + 4));
      } else if (!fileContent.substring(i, i + 3).contains('_')) {
        Token.addToToken(
          fileContent.substring(i, i + 3),
          fileContent.substring(i + 3, i + 4),
        );
      }
    }
    Map<String, Map<String, int>> tokenMap = Token.getTokenMap();
    markovType = 'N4';
    createMarkovVocabulary(tokenMap);
    // print(tokenMap.toString());
  }

  void make5grams() {
    Token.clearTokenMap();
    // Token.addToToken("-", fileContent.substring(0, 1));
    for (var i = 0; i <= fileContent.length - 5; i++) {
      if (fileContent.substring(i, i + 1) == '_') {
        Token.addToToken(('_'), fileContent.substring(i + 1, i + 5));
      } else if (!fileContent.substring(i, i + 4).contains('_')) {
        Token.addToToken(
          fileContent.substring(i, i + 4),
          fileContent.substring(i + 4, i + 5),
        );
      }
    }
    Map<String, Map<String, int>> tokenMap = Token.getTokenMap();
    markovType = 'N5';
    createMarkovVocabulary(tokenMap);
    // print(tokenMap.toString());
  }

  void createMarkovVocabulary(Map<String, Map<String, int>> tokenMap) {
    StringBuffer sb = StringBuffer();
    var sortedKeys = tokenMap.keys.toList()..sort();
    for (String key in sortedKeys) {
      sb.write(key);
      sb.write("{");
      var sortedInnerKeys = tokenMap[key]?.keys.toList()?..sort();
      for (String innerKey in sortedInnerKeys!) {
        sb.write(innerKey);
        sb.write(':');
        sb.write(tokenMap[key]?[innerKey]);
        sb.write(',');
      }
      sb.write("}\n");
    }

    VocabularyView newVocabularyView = VocabularyView.fromMap({
      "categoryId": 19,
      "category": '',
      "projectId": curProject.id,
      "project": '',
      "title": '${fileName}_$markovType',
      "content": sb.toString(),
      "comment": '',
      "isCFG": 0,
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VocabularyDetail(vocabularyView: newVocabularyView),
      ),
    ).then((value) {
      setState(() {
        if (fileContent.isEmpty) {
          fileLoaded = false;
        } else {
          fileLoaded = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: greenNotePaperColour),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Markov chain text",
          style: TextStyle(color: notepaperWhite),
        ),
      ),
      backgroundColor: notepaperWhite,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [notepaperWhite, lightGreenGrey],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12 * scaling,
            horizontal: 8 * scaling,
          ),
          child: Form(
            key: _settingsFormKey,
            child: ListView(
              padding: EdgeInsets.all(4 * scaling),
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownSearch<Project>(
                        key: _prjDDKey,
                        itemAsString: (item) => item.title!,
                        items: (filter, t) => _projects,
                        onSelected: (Project? item) {
                          setState(() {
                            if (item != null) {
                              initialised = true;
                              curProject = item;
                            }
                          });
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: offWhite,
                            labelText: 'PROJECT',
                            // labelText: widget.vocabularyView.project,
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
                            ),
                          ),
                        ),
                        // selectedItem: currentCategory,
                        compareFn: (item, sItem) => item.title == sItem.title,
                        validator: (item) {
                          if (item == null) {
                            return 'please select a Project';
                          }
                          return null;
                        },
                        popupProps: PopupProps.modalBottomSheet(
                          showSelectedItems: true,
                          showSearchBox: false,
                          itemBuilder: projectModalItem,
                        ),
                      ),
                    ),
                    SizedBox(height: 16 * scaling, width: 8 * scaling),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconColor: cyanAppbarColour,
                          backgroundColor: blueGrey,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          openFile();
                        },
                        child: Text("Open file"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10 * scaling, width: 8 * scaling),
                Row(
                  children: [
                    SizedBox(height: 8 * scaling, width: 4 * scaling),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconColor: cyanAppbarColour,
                          backgroundColor: fileLoaded
                              ? Colors.red
                              : inActiveMinimalSetColour,
                          foregroundColor: fileLoaded
                              ? Colors.white
                              : Colors.grey,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          if (fileLoaded) {
                            makeDigrams();
                          }
                        },
                        child: Text("N=2"),
                      ),
                    ),
                    SizedBox(height: 8 * scaling, width: 4 * scaling),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconColor: cyanAppbarColour,
                          backgroundColor: fileLoaded
                              ? Colors.green
                              : inActiveMediumSetColour,
                          foregroundColor: fileLoaded
                              ? Colors.white
                              : Colors.grey,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          if (fileLoaded) {
                            makeTrigrams();
                          }
                        },
                        child: Text("N=3"),
                      ),
                    ),
                    SizedBox(height: 8 * scaling, width: 4 * scaling),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconColor: cyanAppbarColour,
                          backgroundColor: fileLoaded
                              ? Colors.indigo
                              : inActiveLargeSetColour,
                          foregroundColor: fileLoaded
                              ? Colors.white
                              : Colors.grey,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          if (fileLoaded) {
                            make4grams();
                          }
                        },
                        child: Text("N=4"),
                      ),
                    ),
                    SizedBox(height: 8 * scaling, width: 4 * scaling),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconColor: cyanAppbarColour,
                          backgroundColor: fileLoaded
                              ? Colors.purple
                              : inActiveCompleteSetColour,
                          foregroundColor: fileLoaded
                              ? Colors.white
                              : Colors.grey,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          if (fileLoaded) {
                            make5grams();
                          }
                        },
                        child: Text("N=5"),
                      ),
                    ),
                    SizedBox(height: 8 * scaling, width: 4 * scaling),
                  ],
                ),
              ],
            ),
          ),
        ),
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
