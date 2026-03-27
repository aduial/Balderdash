// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/model/category.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/screens/vocabulary_detail.dart';
import 'package:balderdash/views/vocabulary_view.dart';
import 'package:balderdash/widgets/voc_trace.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart' as UserPreferences;
import '../model/vocabulary.dart';
import '../utils/string_utils.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  final _advancedDrawerController = AdvancedDrawerController();
  final _catDDKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  final _prjDDMoveKey = GlobalKey<DropdownSearchState<Project>>();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController =
      TextEditingController(text: '');

  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  late Future<List<VocabularyView>> _vocabularyViews;
  late List<bool> _checkedVVs;
  final batchList = <int>[];
  Set<int> usingSet = {};

  String subTitle = BootstrapSubTitle;
  String searchTitle = '';
  int projectId = 1;
  int categoryId = 1;
  int numItems = 0;
  late Project curProject;
  late Category curCategory;
  bool initComplete = false;
  bool usageSearchMode = false;
  bool usingSearchMode = false;
  bool batchMode = false;
  int moveToProject = 0;
  String vocLine = '';
  String previousLine = '';

  Future<int> _getVocabularyListLength() async {
    return await _vocabularyViews.then((value) {
      return value.length;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
    _refreshVocabularyViewList(true);
  }

  Future loadPreferences() async {
    categoryId = await asyncPrefs.getInt(defaultCategory) ?? 1;
    projectId = await asyncPrefs.getInt(defaultProject) ?? 1;
    _projects = DatabaseHelper().getProjectsAbove(0);
    _categories = DatabaseHelper().getCategoriesAbove(0);
    await setCurrentCategory(categoryId);
    await setCurrentProject(projectId);
    setSubTitle();
    initComplete = true;
  }

  Future<void> setCurrentCategory(int id) async {
    categoryId = id;
    curCategory = await DatabaseHelper().getCategory(id);
    _catDDKey.currentState?.changeSelectedItem(curCategory);
  }

  Future<void> setCurrentProject(int id) async {
    projectId = id;
    curProject = await DatabaseHelper().getProject(id);
    _prjDDKey.currentState?.changeSelectedItem(curProject);
  }

  void _refreshVocabularyViewList(bool doFetch) {
    setState(() {
      if (doFetch) {
        _vocabularyViews = DatabaseHelper().getFilteredVocabulariesBPAC(
            usageSearchMode ? searchTitle : searchController.text,
            projectId,
            categoryId,
            usageSearchMode);
      }
      subTitle = setSubTitle();
      _getVocabularyListLength().then((value) {
        setState(() {
          _checkedVVs = List<bool>.filled(value, false, growable: true);
          numItems = value;
        });
      });
    });
  }

  // void _usingVocabularyViewList() {
  //   setState(() {
  //     _vocabularyViews =
  //     subTitle = setSubTitle();
  //     _getVocabularyListLength().then((value) {
  //       setState(() {
  //         _checkedVVs = List<bool>.filled(value, false, growable: true);
  //         numItems = value;
  //       });
  //     });
  //   });
  // }

  String setSubTitle() {
    final whereTitle = StringBuffer('');
    if (projectId == 1 && categoryId == 1) {
      return BootstrapSubTitle;
    } else {
      if (projectId > 1 && categoryId > 1) {
        whereTitle.write(
            "${_catDDKey.currentState?.getSelectedItem?.name} for ${_prjDDKey.currentState?.getSelectedItem?.title}");
      }
      if (projectId == 1 && categoryId > 1) {
        whereTitle.write(
            "${_catDDKey.currentState?.getSelectedItem?.name} vocabularies");
      }
      if (projectId > 1 && categoryId == 1) {
        whereTitle.write(
            "Vocabularies for ${_prjDDKey.currentState?.getSelectedItem?.title}");
      }
      return whereTitle.toString();
    }
  }

  onSearch() {
    setState(() {
      usageSearchMode = false;
      usingSearchMode = false;
      _refreshVocabularyViewList(true);
    });
  }

  setFilterProject(int value) {
    projectId = value;
    _refreshVocabularyViewList(true);
  }

  setFilterCategory(int value) {
    categoryId = value;
    _refreshVocabularyViewList(true);
  }

  Future<void> handleSettingsButtonPressed() async {
    _advancedDrawerController.showDrawer();
  }

  onUsageSearch(String value) {
    setState(() {
      usageSearchMode = true;
      usingSearchMode = false;
      searchTitle = value.toLowerCase();
      _refreshVocabularyViewList(true);
    });
  }

  onUsingSearch(int pId, String title) async {
    usageSearchMode = false;
    usingSearchMode = true;
    await doStuff(pId, title);
    setState(() {
      _refreshVocabularyViewList(false);
    });
  }

  Future<void> doStuff(int pId, String title) async {
    usingSet.clear();
    Vocabulary voc = await getVocabulary(pId, title);
    usingSet.add(voc.id ?? 0);
    await parseVocabulary(pId, voc);
    print("${usingSet.length} vocs found");
    _vocabularyViews = DatabaseHelper().getVocabularyViewList(usingSet);
  }

  Future<Vocabulary> getVocabulary(int pId, String title) async {
    return await DatabaseHelper().getVocabularyByTitleAndProject(title, pId);
  }

  Future<void> parseVocabulary(int pId, Vocabulary voc) async {
    List<String> lines = [];
    lines = splitVocabulary(voc.content!);
    for (vocLine in lines) {
      VocTrace vc = VocTrace(
          vocabulary: voc,
          line: vocLine.replaceAll(RegExp(r'^#\d+#'), ''), // remove weight tag
          variableName: StringUtils.capitalise(voc.title!.toLowerCase()));
      await parseVocabTrace(pId, vc);
    }
  }

  Future<String> parseVocabTrace(int pId, VocTrace vc) async {
    if (vc.line.isNotEmpty && vc.line == previousLine) {
      return "$endlessLoopError in ${vc.line}";
    }
    if (vc.line.contains("{{") || vc.line.contains("}}")) {
      return "$doubleCurlyBracesError in ${vc.line}";
    }
    previousLine = vc.line;
    if (!vc.line.contains("{")) {
      vc.line = '';
      return vc.line;
    }
    // remove everything up to the first {
    vc.line = vc.line.replaceFirst(RegExp(r'^.*?{'), '{');

    if (vc.line.startsWith('{[')) {
      vc = removeTag(vc);
    } else if (vc.line.startsWith('{\\')) {
      vc = removeTag(vc);
    } else if (vc
        .getNormaLine()
        .contains(RegExp(r'^\{\w+:=[\x27\w\s\\^@|()<>%*_";:?!\-+,.]+\}'))) {
      vc = removeTag(vc);
    } else if (vc
        .getNormaLine()
        .contains(RegExp(r'^\{\w*=([\w\s\\@()<>%*_";:?!\-+,.])+\}'))) {
      vc = removeTag(vc);
    } else if (vc.getNormaLine().contains(RegExp(r'^\{\^?\w+(#\d+-\d+)?\}'))) {
      // variable
      vc = await parseVariable(pId, vc);
    } else if (vc.getNormaLine().contains(RegExp(r'^\{\$\^?\w*\}'))) {
      vc = removeTag(vc);
    } else if (vc.line.contains(RegExp(r'^\{@(%-?\w\w?\W*)*(\|\d+\|\d+)?\}'))) {
      vc = removeTag(vc);
    }
    if (vc.line.isNotEmpty) {
      return await parseVocabTrace(pId, vc);
    } else {
      // end of vc lifecycle
      return "done";
    }
  }

  Future<VocTrace> parseVariable(int pId, VocTrace vc) async {
    String varTitle = '';
    RegExp varMatch = RegExp(r'^\{\^?(\w+?)(#\d+-\d+)?\}');
    if (vc.line.contains(varMatch)) {
      // retrieve title
      varTitle = varMatch.firstMatch(vc.line)?.group(1) ?? '';
    }
    Vocabulary next = await retrieveVocabularyVariable(pId, vc, varTitle);
    usingSet.add(next.id ?? 0);
    await parseVocabulary(pId, next);
    return removeTag(vc);
  }

  Future<Vocabulary> retrieveVocabularyVariable(
      int pId, VocTrace vc, String varTitle) async {
    Vocabulary next =
        await getVocabulary(pId, varTitle.replaceFirst('^', '').toUpperCase());
    if (next.content!.isEmpty) {
      showError(noEmptyVocabulary,
          "Vocabulary '${varTitle.replaceFirst('^', '').toUpperCase()}' called in '${vc.variableName}' has no content");
    }
    return next;
  }

  VocTrace removeTag(VocTrace vc) {
    // remove tag
    vc.line = vc.line.replaceFirst(RegExp(r'^\{.*?\}'), '');
    if (vc.line.isNotEmpty) {
      // remove fixed text until first {
      vc.line = vc.line.replaceFirst(RegExp(r'^.*?{'), '{');
    }
    return vc;
  }

  List<String> splitVocabulary(String content) {
    List<String> uniqueLines = [];
    List<String> activeLines = [];
    LineSplitter ls = LineSplitter();
    uniqueLines = ls.convert(content);
    if (uniqueLines[0].isEmpty) {
      return [emptyFirstLineError];
    }
    for (var line in uniqueLines) {
      if (line.isEmpty) {
        break;
      }
      activeLines.add(line);
    }
    return activeLines;
  }

  setBatchMode(bool batch) {
    setState(() {
      if (!batch) {
        batchList.clear();
      }
      batchMode = batch;
    });
  }

  void _showForm() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            "${batchList.length} vocabular${batchList.length == 1 ? "y" : "ies"}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "to:",
                  style:
                      TextStyle(color: darkerBlueGrey, fontSize: 20 * scaling),
                ),
                SizedBox(width: 10 * scaling),
                Flexible(
                  child: DropdownSearch<Project>(
                    key: _prjDDMoveKey,
                    itemAsString: (item) => item.title!,
                    items: (filter, t) => _projects,
                    onSelected: (Project? item) {
                      setState(() {
                        if (item != null && item.id != projectId) {
                          moveToProject = item.id!;
                        }
                      });
                    },
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          isDense: true,
                          filled: true,
                          fillColor: offWhite,
                          labelText: 'PROJECT',
                          // labelText: widget.vocabularyView.project,
                          floatingLabelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10 * scaling),
                          )),
                    ),
                    compareFn: (item, sItem) => item.title == sItem.title,
                    validator: (item) {
                      if (item == null) {
                        return 'please select a Project';
                      }
                      if (item.id == projectId) {
                        return "that's the current Project";
                      }
                      return null;
                    },
                    popupProps: PopupProps.modalBottomSheet(
                        showSelectedItems: true,
                        showSearchBox: false,
                        itemBuilder: projectModalItem),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (moveToProject > 0) {
                await DatabaseHelper()
                    .batchCopyVocabularies(batchList, moveToProject);
                setBatchMode(false);
                handleRightActionModePressed();
                batchList.clear();
                _refreshVocabularyViewList(true);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () async {
              if (moveToProject > 0) {
                await DatabaseHelper()
                    .batchMoveVocabularies(batchList, moveToProject);
                setBatchMode(false);
                handleRightActionModePressed();
                batchList.clear();
                _refreshVocabularyViewList(true);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Move'),
          ),
        ],
      ),
    );
  }

  void handleRightActionModePressed() {
    if (!batchMode) {
      if (usageSearchMode || usingSearchMode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: greenAppbarColour,
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 1200),
              content: Text(
                "back to Vocabulary list",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18 * scaling,
                ),
              ),
              dismissDirection: DismissDirection.up),
        );
      }
      (usageSearchMode || usingSearchMode)
          ? onSearch()
          : handleSettingsButtonPressed();
    }
  }

  void showError(String title, String msg) => showDialog<String>(
      context: UserPreferences.navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
                child: const Text('Go back'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
        WidgetState.selected
      };
      if (states.any(interactiveStates.contains)) {
        return orangeCheckColour;
      }
      return notepaperWhite;
    }

    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [brightBlue, tanteRia],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: true,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16 * scaling)),
      ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70 * scaling,
          iconTheme: IconThemeData(
            color: greenNotePaperColour,
          ),
          backgroundColor: inActiveLargeSetColour,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30 * scaling,
                child: TextField(
                  style:
                      TextStyle(color: darkerBlueGrey, fontSize: 16 * scaling),
                  onChanged: (value) => onSearch(),
                  controller: searchController,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: notepaperWhite,
                    hintText: "filter vocabularies",
                    contentPadding: EdgeInsets.all(0),
                    prefixIcon: Icon(Icons.search, color: darkerBlueGrey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50 * scaling),
                        borderSide: BorderSide.none),
                    hintStyle: TextStyle(
                        fontSize: 14 * scaling, color: darkerBlueGrey),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(4 * scaling)),
              Text(
                subTitle,
                style:
                    TextStyle(color: notepaperWhite, fontSize: 14.0 * scaling),
              ),
              Padding(padding: EdgeInsets.all(4 * scaling)),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                batchMode ? Icons.cancel_rounded : Icons.checklist_outlined,
                color: batchMode ? orangeCheckColour : greenNotePaperColour,
              ),
              onPressed: () {
                // if (!usageSearchMode && !usingSearchMode) {
                if (batchMode) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: greenAppbarColour,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 1200),
                        content: Text(
                          "quit Batch Mode",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * scaling,
                          ),
                        ),
                        dismissDirection: DismissDirection.up),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: orangeCheckColour,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 1200),
                        content: Text(
                          "enter Batch Mode",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * scaling,
                          ),
                        ),
                        dismissDirection: DismissDirection.up),
                  );
                }
                batchMode ? setBatchMode(false) : setBatchMode(true);
              },
            ),
            IconButton(
              icon: Icon(
                (usageSearchMode || usingSearchMode)
                    ? Icons.cancel_rounded
                    : Icons.settings,
                color: usageSearchMode
                    ? neoFormColour
                    : usingSearchMode
                        ? lightVerbatimMatchColour
                        : greenNotePaperColour,
              ),
              onPressed: () {
                handleRightActionModePressed();
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [notepaperWhite, blueGrey],
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
                      padding:
                          EdgeInsets.fromLTRB(0.0, 0.0, 4.0 * scaling, 0.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: scaling, color: tanteRia),
                        ),
                        color: notepaperWhite,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (batchMode)
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    WidgetStateProperty.resolveWith(getColor),
                                value: _checkedVVs[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    value!
                                        ? batchList.add(vocabularyView.id!)
                                        : batchList.remove(vocabularyView.id!);
                                    _checkedVVs[index] = value;
                                  });
                                },
                              ),
                            ),
                          if (!batchMode)
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: const Icon(Icons.search_rounded),
                                  color: vocabularyView.useThis == 1
                                      ? violetAppbarColour
                                      : lightBlueGrey,
                                  onPressed: () {
                                    onUsageSearch(vocabularyView.title ?? '');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: violetAppbarColour,
                                          behavior: SnackBarBehavior.floating,
                                          duration:
                                              Duration(milliseconds: 1200),
                                          content: Text(
                                            "vocabularies using '${vocabularyView.title ?? ''}'",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18 * scaling,
                                            ),
                                          ),
                                          dismissDirection:
                                              DismissDirection.endToStart),
                                    );
                                  }),
                            ),
                          Expanded(
                            flex: 5,
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
                                  2 * scaling, 0, 0, 0),
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
                                icon: const Icon(Icons.star_border_rounded),
                                color: vocabularyView.useThis == 1
                                    ? blueAppbarColour
                                    : lightBlueGrey,
                                onPressed: () {
                                  onUsingSearch(vocabularyView.projectId ?? 0,
                                      vocabularyView.title ?? '');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: blueAppbarColour,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(milliseconds: 1200),
                                        content: Text(
                                          "all vocabularies used by '${vocabularyView.title ?? ''}'",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18 * scaling,
                                          ),
                                        ),
                                        dismissDirection:
                                            DismissDirection.endToStart),
                                  );
                                }),
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
                                    _refreshVocabularyViewList(true);
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
                                  await DatabaseHelper()
                                      .deleteVocabulary(vocabularyView);
                                  _refreshVocabularyViewList(true);
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
          backgroundColor:
              batchMode ? orangeNotePaperColour : greenNotePaperColour,
          child: batchMode
              ? const Icon(Icons.my_library_books_rounded)
              : const Icon(Icons.add),
          onPressed: () async {
            if (batchMode) {
              _showForm();
            } else {
              VocabularyView newVocabularyView = VocabularyView.fromMap({
                // "id": newVocabulary.id,
                "categoryId": null,
                "category": '',
                "projectId": projectId,
                "project": '',
                "title": '',
                "content": '',
                "comment": '',
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
                  _refreshVocabularyViewList(true);
                });
              });
            }
          },
        ),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0 * scaling,
                  height: 128.0 * scaling,
                  margin: EdgeInsets.only(
                    top: 24.0 * scaling,
                    bottom: 24.0 * scaling,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    getDrawerImg(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0 * scaling),
                  child: Row(
                    children: [
                      Flexible(
                        child: DropdownSearch<Project>(
                          key: _prjDDKey,
                          itemAsString: (item) => item.title!,
                          items: (filter, t) => _projects,
                          onSelected: (Project? item) {
                            setState(() {
                              if (item == null) {
                                setFilterProject(1);
                              } else {
                                setFilterProject(item.id!);
                              }
                              _advancedDrawerController.hideDrawer();
                            });
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                isDense: true,
                                filled: true,
                                fillColor: offWhite,
                                labelText: 'PROJECT',
                                // labelText: widget.vocabularyView.project,
                                floatingLabelStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10 * scaling),
                                )),
                          ),
                          compareFn: (item, sItem) => item.title == sItem.title,
                          popupProps: PopupProps.modalBottomSheet(
                              showSelectedItems: true,
                              showSearchBox: false,
                              itemBuilder: projectModalItem),
                        ),
                      ),
                      SizedBox(height: 30 * scaling, width: 8 * scaling),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconColor: orangeAppbarColour,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          setFilterProject(1);
                          setState(() {
                            _prjDDKey.currentState?.clear();
                            _advancedDrawerController.hideDrawer();
                          });
                        },
                        child: const Icon(
                          Icons.clear,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0 * scaling),
                  child: Row(
                    children: [
                      Flexible(
                        child: DropdownSearch<Category>(
                          key: _catDDKey,
                          // selectedItem: _catDDKey.currentState?.getSelectedItem,
                          itemAsString: (item) => item.name!,
                          items: (filter, t) => _categories,
                          onSelected: (Category? item) {
                            setState(() {
                              if (item == null) {
                                setFilterCategory(1);
                              } else {
                                setFilterCategory(item.id!);
                              }
                              _advancedDrawerController.hideDrawer();
                            });
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                isDense: true,
                                filled: true,
                                fillColor: offWhite,
                                labelText: 'CATEGORY',
                                floatingLabelStyle: TextStyle(
                                    fontSize: 18 * scaling,
                                    fontWeight: FontWeight.w500),
                                labelStyle: TextStyle(fontSize: 14 * scaling),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10 * scaling),
                                )),
                          ),
                          // selectedItem: currentCategory,
                          compareFn: (item, sItem) => item.name == sItem.name,
                          popupProps: PopupProps.modalBottomSheet(
                              showSelectedItems: true,
                              showSearchBox: false,
                              itemBuilder: categoryModalItem),
                        ),
                      ),
                      SizedBox(height: 30 * scaling, width: 8 * scaling),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconColor: cyanAppbarColour,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          setFilterCategory(1);
                          setState(() {
                            _catDDKey.currentState?.clear();
                            _advancedDrawerController.hideDrawer();
                          });
                        },
                        child: const Icon(
                          Icons.clear,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12 * scaling,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 16.0 * scaling,
                    ),
                  ),
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
