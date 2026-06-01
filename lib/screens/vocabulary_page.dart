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

import '../model/vocabulary.dart';
import '../utils/string_utils.dart';
import '../utils/vocab_utils.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  // Map<String, String> stateVariables = {};
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  final _advancedDrawerController = AdvancedDrawerController();
  final _catDDKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  final _prjDDMoveKey = GlobalKey<DropdownSearchState<Project>>();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController(
    text: '',
  );

  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  late Future<List<VocabularyView>> _vocabularyViews;
  late List<bool> _checkedVVs;
  final batchList = <int>[];
  Set<int> usingSet = {};

  String subTitle = bootstrapSubTitle;
  String searchTitle = '';
  String searchTerm = '';
  int projectId = 1;
  int searchInProjectId = 1;
  int usingProjectId = 1;
  int categoryId = 1;
  int markVVListOnSave = 1;
  int showNoNonsense = 1;
  int numItems = 0;
  late Project curProject;
  late Category curCategory;
  bool initComplete = false;
  bool usageSearchMode = false;
  bool usingSearchMode = false;
  bool wordSearchMode = false;
  bool batchMode = false;
  int moveToProject = 0;
  String vocLine = '';
  String previousLine = '';

  Map<int, bool> vvErrorState = {};

  Future<int> _getVocabularyListLength() async {
    return await _vocabularyViews.then((value) {
      // print("${value.length} vocs");
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
    categoryId = await asyncPrefs.getInt(appCategory) ?? 1;
    projectId = await asyncPrefs.getInt(appProject) ?? 1;
    markVVListOnSave = await asyncPrefs.getInt(markOnSave) ?? 1;
    showNoNonsense = await asyncPrefs.getInt(noNonsense) ?? 1;
    _projects = DatabaseHelper().getProjectsAbove(0, showNoNonsense == 1);
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
          usageSearchMode ? searchInProjectId : projectId,
          categoryId,
          usageSearchMode,
          showNoNonsense == 1,
        );
      }
      if (!wordSearchMode) {
        subTitle = setSubTitle();
      }
      _getVocabularyListLength().then((value) {
        setState(() {
          _checkedVVs = List<bool>.filled(value, false, growable: true);
          numItems = value;
        });
      });
    });
  }

  String setSubTitle() {
    final whereTitle = StringBuffer('');
    if (projectId == 1 && categoryId == 1) {
      return bootstrapSubTitle;
    } else {
      if (projectId > 1 && categoryId > 1) {
        whereTitle.write(
          "${_catDDKey.currentState?.getSelectedItem?.name} for ${_prjDDKey.currentState?.getSelectedItem?.title}",
        );
      }
      if (projectId == 1 && categoryId > 1) {
        whereTitle.write(
          "${_catDDKey.currentState?.getSelectedItem?.name} vocabularies",
        );
      }
      if (projectId > 1 && categoryId == 1) {
        whereTitle.write(
          "Vocabularies for ${_prjDDKey.currentState?.getSelectedItem?.title}",
        );
      }
      return whereTitle.toString();
    }
  }

  onSearch() {
    setState(() {
      if (wordSearchMode) {
        if (searchController.text.length > 2) {
          _vocabularyViews = DatabaseHelper().getVocabularyViewsContaining(
            searchController.text,
          );
          _refreshVocabularyViewList(false);
        }
      } else {
        usageSearchMode = false;
        usingSearchMode = false;
        _refreshVocabularyViewList(true);
      }
    });
  }

  onWordSearch() {
    wordSearchMode = !wordSearchMode;
    setState(() {
      if (wordSearchMode) {
        searchTerm = searchController.text;
        searchController.clear();
        subTitle = wordSearchSubTitle;
      } else {
        searchController.text = searchTerm;
        _refreshVocabularyViewList(true);
      }
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

  /*
    for this search we collect:
    - all directly referred vocabularies
    - vocabularies used to set state variables
  */
  onUsingSearch(VocabularyView vv) async {
    usingSet.clear();
    usageSearchMode = false;
    usingSearchMode = true;
    await parseVocabulary(Vocabulary.fromView(vv));
    _vocabularyViews = DatabaseHelper().getVocabularyViewList({...usingSet});
    setState(() {
      _refreshVocabularyViewList(false);
    });
  }

  /*
    add ID to usingSet, wrap in VocTrace and go ...
  */
  Future<void> parseVocabulary(Vocabulary voc) async {
    usingSet.add(voc.id ?? 0);
    // print(voc.title);
    List<String> lines = [];
    lines = VocabUtils.splitContent(voc.content!, true);
    for (vocLine in lines) {
      VocTrace vc = VocTrace(
        vocabulary: voc,
        line: vocLine.replaceAll(RegExp(r'^#\d+#'), ''), // remove weight tag
        variableName: StringUtils.capitalise(voc.title!.toLowerCase()),
      );
      previousLine = '';
      await parseVocabTrace(vc);
    }
  }

  Future<String> parseVocabTrace(VocTrace vc) async {
    if (vc.line.isNotEmpty && vc.line == previousLine) {
      return "$endlessLoopError in ${vc.line}";
    }
    if (vc.line.contains("{{") || vc.line.contains("}}")) {
      return "$doubleCurlyBracesError in ${vc.line}";
    }
    previousLine = vc.line;
    // remove literal text  up to the first {
    vc.line = vc.line.replaceFirst(RegExp(r'^.*?{'), '{');
    if (vc.line.startsWith('{[')) {
      // anonymous vocabulary, ignore, remove tag and proceed
      vc = removeTag(vc);
    } else if (vc.line.startsWith('{\\')) {
      // line break, { } or null, ignore, remove tag and proceed
      vc = removeTag(vc);
    } else if (vc.line.contains(RegExp(r'^\{@(%-?\w\w?\W*)*(\|\d+\|\d+)?\}'))) {
      // strftime, ignore, remove tag and proceed
      vc = removeTag(vc);
    } else if (vc.getNormaLine().contains(
      RegExp(r'^\{\w*=([\w\s\\@()<>%*_";:?!\-+,.])+\}'),
    )) {
      vc = removeTag(vc);
    } else if (vc.getNormaLine().contains(
      RegExp(r'^\{\w+:=[\x27\w\s\\^@|()<>%*_";:?!\-+,.]+\}'),
    )) {
      // state variable assignment via Vocabulary: treat as a regular
      // vocabulary variable, proces recursively + add to using list
      vc = await parseStateVariable(vc);
    } else if (vc.getNormaLine().contains(RegExp(r'^\{\^?\w+(#\d+-\d+)?\}'))) {
      // process vocabulary variable; proces recursively + add to using list
      vc = await parseVocabularyVariable(vc);
    } else if (vc.getNormaLine().contains(RegExp(r'^\{\$\^?\w*\}'))) {
      // state variable write
      vc = removeTag(vc);
    } else if (vc.getNormaLine().contains(RegExp(r'^\{\$\$\^?\w*\}'))) {
      // state pointer write
      vc = removeTag(vc);
    }
    if (vc.line.isNotEmpty) {
      // continue ...
      return await parseVocabTrace(vc);
    } else {
      // end of vc lifecycle
      return "done";
    }
  }

  Future<List<Vocabulary>> getVocabulary(int pId, String title) async {
    return await DatabaseHelper().getVocabularyByTitleAndProject(title, pId);
  }

  /*
    retrieve vocabulary {var:=vocab} <- and recurse
  */
  Future<VocTrace> parseStateVariable(VocTrace vc) async {
    int start = vc.line.indexOf('{');
    int equals = vc.line.indexOf(':=', start + 1);
    int end = vc.line.indexOf('}');
    String vocabTitle = vc.line.substring(equals + 2, end);
    List<Vocabulary> nexts = await getVocabulary(
      usingProjectId,
      vocabTitle.replaceFirst('^', '').toUpperCase(),
    );
    if (nexts.isNotEmpty && !usingSet.contains(nexts.first.id)) {
      await parseVocabulary(nexts.first);
    }
    return removeTag(vc);
  }

  /*
    retrieve vocabulary and recurse
  */
  Future<VocTrace> parseVocabularyVariable(VocTrace vc) async {
    String vocabTitle = '';
    RegExp varMatch = RegExp(r'^\{\^?(\w+?)(#\d+-\d+)?\}');
    if (vc.line.contains(varMatch)) {
      vocabTitle = varMatch.firstMatch(vc.line)?.group(1) ?? '';
      List<Vocabulary> nexts = await getVocabulary(
        usingProjectId,
        vocabTitle.replaceFirst('^', '').toUpperCase(),
      );
      if (nexts.isNotEmpty && !usingSet.contains(nexts.first.id)) {
        await parseVocabulary(nexts.first);
      }
    }
    return removeTag(vc);
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
          "${batchList.length} vocabular${batchList.length == 1 ? "y" : "ies"}",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "to:",
                  style: TextStyle(
                    color: darkerBlueGrey,
                    fontSize: 20 * scaling,
                  ),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * scaling),
                        ),
                      ),
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
                      itemBuilder: projectModalItem,
                    ),
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
                await DatabaseHelper().batchCopyVocabularies(
                  batchList,
                  moveToProject,
                );
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
                await DatabaseHelper().batchMoveVocabularies(
                  batchList,
                  moveToProject,
                );
                setBatchMode(false);
                handleRightActionModePressed();
                batchList.clear();
                _refreshVocabularyViewList(true);
                if (mounted) {
                  Navigator.of(context).pop();
                }
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
              style: TextStyle(fontSize: 18 * scaling),
            ),
            dismissDirection: DismissDirection.up,
          ),
        );
      }
      (usageSearchMode || usingSearchMode)
          ? onSearch()
          : handleSettingsButtonPressed();
    }
  }

  void showError(String title, String msg) => showDialog<String>(
    context: navigatorKey.currentContext!,
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
    ),
  );

  // launches the Vocabulary detail screen and awaits the result from Navigator.pop
  Future<void> _navigateToDetailscreen(BuildContext context, VocabularyView vv) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute<bool>(
            builder: (context) =>
                VocabularyDetail(
                  vocabularyView: vv,
                )
        )
    );
    if (!context.mounted) return;
    if (markVVListOnSave == 1 && result!) {
      _refreshVocabularyViewList(true);
      vvErrorState =
          VocabUtils.checkVocabularyViews(
            await _vocabularyViews,
          );
    } else {
      vvErrorState.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
        WidgetState.selected,
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
          BoxShadow(color: Colors.black12, blurRadius: 10.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16 * scaling)),
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
                  child: Image.asset(getDrawerImg()),
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
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              isDense: true,
                              filled: true,
                              fillColor: offWhite,
                              labelText: 'PROJECT',
                              // labelText: widget.vocabularyView.project,
                              floatingLabelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10 * scaling,
                                ),
                              ),
                            ),
                          ),
                          compareFn: (item, sItem) => item.title == sItem.title,
                          popupProps: PopupProps.modalBottomSheet(
                            showSelectedItems: true,
                            showSearchBox: false,
                            itemBuilder: projectModalItem,
                          ),
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
                        child: const Icon(Icons.clear),
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
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              isDense: true,
                              filled: true,
                              fillColor: offWhite,
                              labelText: 'CATEGORY',
                              floatingLabelStyle: TextStyle(
                                fontSize: 18 * scaling,
                                fontWeight: FontWeight.w500,
                              ),
                              labelStyle: TextStyle(fontSize: 14 * scaling),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10 * scaling,
                                ),
                              ),
                            ),
                          ),
                          // selectedItem: currentCategory,
                          compareFn: (item, sItem) => item.name == sItem.name,
                          popupProps: PopupProps.modalBottomSheet(
                            showSelectedItems: true,
                            showSearchBox: false,
                            itemBuilder: categoryModalItem,
                          ),
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
                        child: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0 * scaling),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black,
                        ),
                        onPressed: () async {
                          vvErrorState = VocabUtils.checkVocabularyViews(
                            await _vocabularyViews,
                          );
                          setState(() {
                            _advancedDrawerController.hideDrawer();
                          });
                        },
                        child: const Text('Check current vocabularies'),
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
                    margin: EdgeInsets.symmetric(vertical: 16.0 * scaling),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 46,
          titleSpacing: 6,
          toolbarHeight: 70 * scaling,
          iconTheme: IconThemeData(color: greenNotePaperColour),
          backgroundColor: inActiveLargeSetColour,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(4 * scaling)),
              SizedBox(
                height: 30 * scaling,
                child: TextField(
                  style: TextStyle(
                    color: darkerBlueGrey,
                    fontSize: 16 * scaling,
                  ),
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
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14 * scaling,
                      color: darkerBlueGrey,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(2 * scaling)),
              Text(
                subTitle,
                style: TextStyle(
                  color: notepaperWhite,
                  fontSize: 14.0 * scaling,
                ),
              ),
              Padding(padding: EdgeInsets.all(4 * scaling)),
            ],
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 25.0, // desired size
              padding: EdgeInsets.fromLTRB(6, 0, 6, 14),
              constraints:
                  const BoxConstraints(), // override default min size of 48px
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // the '2023' part
              ),
              icon: Icon(
                batchMode ? Icons.cancel_rounded : Icons.checklist_outlined,
                color: wordSearchMode
                    ? lightGreenGrey
                    : batchMode
                    ? orangeCheckColour
                    : greenNotePaperColour,
              ),
              onPressed: () {
                // if (!usageSearchMode && !usingSearchMode) {
                if (!wordSearchMode) {
                  if (batchMode) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: greenAppbarColour,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 1200),
                        content: Text(
                          "quit batch mode",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18 * scaling),
                        ),
                        dismissDirection: DismissDirection.up,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: orangeCheckColour,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 1200),
                        content: Text(
                          "enter batch mode",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18 * scaling),
                        ),
                        dismissDirection: DismissDirection.up,
                      ),
                    );
                  }
                  batchMode ? setBatchMode(false) : setBatchMode(true);
                }
              },
            ),
            IconButton(
              iconSize: 25.0, // desired size
              padding: EdgeInsets.fromLTRB(6, 0, 6, 14),
              constraints:
                  const BoxConstraints(), // override default min size of 48px
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // the '2023' part
              ),
              icon: Icon(
                (usageSearchMode || usingSearchMode)
                    ? Icons.cancel_rounded
                    : Icons.settings,
                color: wordSearchMode || batchMode
                    ? lightGreenGrey
                    : usageSearchMode
                    ? neoFormColour
                    : usingSearchMode
                    ? lightVerbatimMatchColour
                    : greenNotePaperColour,
              ),
              onPressed: () {
                if (!wordSearchMode) {
                  handleRightActionModePressed();
                }
              },
            ),
            IconButton(
              iconSize: 25.0, // desired size
              padding: EdgeInsets.fromLTRB(6, 0, 10, 14),
              constraints:
                  const BoxConstraints(), // override default min size of 48px
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // the '2023' part
              ),
              icon: Icon(
                wordSearchMode ? Icons.cancel_rounded : Icons.search,
                color: wordSearchMode
                    ? reformulatedFormColour
                    : batchMode
                    ? lightGreenGrey
                    : greenNotePaperColour,
              ),
              onPressed: () {
                if (!batchMode) {
                  onWordSearch();
                  if (wordSearchMode) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: yellowNotePaperColour,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 1200),
                        content: Text(
                          "enter word search mode",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * scaling,
                            color: darkerBlueGrey,
                          ),
                        ),
                        dismissDirection: DismissDirection.up,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: yellowNotePaperColour,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 1200),
                        content: Text(
                          "quit word search mode",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * scaling,
                            color: darkerBlueGrey,
                          ),
                        ),
                        dismissDirection: DismissDirection.up,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                wordSearchMode ? notepaperYellow : notepaperWhite,
                blueGrey,
              ],
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
                        0.0,
                        0.0,
                        4.0 * scaling,
                        0.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: scaling, color: tanteRia),
                        ),
                        color: wordSearchMode
                            ? notepaperYellow
                            : batchMode
                            ? notepaperOrange
                            : notepaperWhite,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (batchMode)
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                checkColor: Colors.white,
                                fillColor: WidgetStateProperty.resolveWith(
                                  getColor,
                                ),
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
                                color: violetAppbarColour,
                                onPressed: () {
                                  searchInProjectId = vocabularyView.projectId!;
                                  onUsageSearch(vocabularyView.title ?? '');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: violetAppbarColour,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(milliseconds: 1200),
                                      content: Text(
                                        "vocabularies using '${vocabularyView.title ?? ''}'",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18 * scaling,
                                        ),
                                      ),
                                      dismissDirection:
                                          DismissDirection.endToStart,
                                    ),
                                  );
                                },
                              ),
                            ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                4 * scaling,
                                0,
                                2 * scaling,
                                0,
                              ),
                              child: AutoSizeText(
                                vocabularyView.title!,
                                style: TextStyle(
                                  color: vocabularyView.isCFG == 1
                                      ? (vvErrorState.containsKey(
                                                  vocabularyView.id!,
                                                ) &&
                                                !vvErrorState[vocabularyView
                                                    .id]!
                                            ? darkAnyMatchColour
                                            : veryVeryDark)
                                      : blueTextColour,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                2 * scaling,
                                0,
                                2 * scaling,
                                0,
                              ),
                              child: AutoSizeText(
                                vocabularyView.category!,
                                maxLines: 1,
                                style: TextStyle(
                                  color: inActiveLargeSetColour,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                2 * scaling,
                                0,
                                0,
                                0,
                              ),
                              child: AutoSizeText(
                                vocabularyView.project!,
                                maxLines: 1,
                                style: TextStyle(
                                  color: secondary,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.star_border_rounded),
                              color: blueAppbarColour,
                              onPressed: () {
                                usingProjectId = vocabularyView.projectId!;
                                onUsingSearch(vocabularyView);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: blueAppbarColour,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(milliseconds: 1200),
                                    content: Text(
                                      "all vocabularies used by '${vocabularyView.title ?? ''}'",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18 * scaling),
                                    ),
                                    dismissDirection:
                                        DismissDirection.endToStart,
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              color: greenAppbarColour,
                              onPressed: () {
                                _navigateToDetailscreen(context, vocabularyView);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              color: greenAppbarColour,
                              onPressed: () async {
                                final bool
                                isDelete = await showConfirmationChoiceDialog(
                                  context,
                                  title: 'Delete ${vocabularyView.title!}?',
                                  message:
                                      "Do you want to delete ${vocabularyView.title!}? You cannot undo this!",
                                  positiveText: 'Delete',
                                  negativeText: 'Cancel',
                                  highlightNegative: true,
                                );

                                if (isDelete) {
                                  await DatabaseHelper().deleteVocabulary(
                                    vocabularyView,
                                  );
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
          backgroundColor: batchMode
              ? orangeNotePaperColour
              : greenNotePaperColour,
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
                "isCFG": 1,
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
    );
  }
}

Future<bool> showConfirmationChoiceDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String positiveText,
  required String negativeText,
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
                  style: !highlightNegative
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

Future<void> showConfirmationAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String text,
  bool highlight = false,
}) async {
  return await showDialog<void>(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(
              text.toUpperCase(),
              style: highlight
                  ? const TextStyle(color: Colors.red)
                  : const TextStyle(color: Colors.green),
            ),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ],
      );
    },
  );
}
