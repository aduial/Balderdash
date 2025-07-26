// ignore_for_file: sort_child_properties_last

import 'package:auto_size_text/auto_size_text.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/model/category.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/screens/vocabulary_detail.dart';
import 'package:balderdash/views/vocabulary_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  static SharedPreferences? _preferences;

  final _advancedDrawerController = AdvancedDrawerController();
  final _catDDKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController =
      TextEditingController(text: '');

  late DatabaseHelper dbHelper;
  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  late List<VocabularyView> vvList;
  late Future<List<VocabularyView>> _vocabularyViews;
  List<VocabularyView> filteredVocabularies = [];

  String subTitle = BootstrapSubTitle;
  String searchTitle = '';
  int projectId = 1;
  int categoryId = 1;
  int numItems = 0;
  late Project curProject;
  late Category curCategory;
  bool initComplete = false;
  bool usageSearchMode = false;

  Future<int> _getVocabularyListLength() async {
    return await _vocabularyViews.then((value) {
      return value.length;
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    loadPreferences();
    _refreshVocabularyViewList();
    setSubTitle();
  }

  Future loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    projectId = prefs.getInt(defaultProject) ?? 1;
    categoryId = prefs.getInt(defaultCategory) ?? 1;
    // print("pid = $projectId; cid = $categoryId");
    _projects = dbHelper.getProjects();
    _categories = dbHelper.getCategoriesAbove(0);
    curProject = await dbHelper.getProject(projectId);
    curCategory = await dbHelper.getCategory(categoryId);
    _prjDDKey.currentState?.changeSelectedItem(curProject);
    _catDDKey.currentState?.changeSelectedItem(curCategory);
    initComplete = true;
  }

  void _refreshVocabularyViewList() {
    setState(() {
      _vocabularyViews = dbHelper.getFilteredVocabulariesBPAC(
          usageSearchMode ? searchTitle : searchController.text,
          projectId,
          categoryId,
          usageSearchMode);
      subTitle = setSubTitle();
      _getVocabularyListLength().then((value) {
        setState(() {
          numItems = value;
        });
      });
    });
  }

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
      _refreshVocabularyViewList();
    });
  }

  setFilterProject(int value) {
    projectId = value;
    _refreshVocabularyViewList();
  }

  setFilterCategory(int value) {
    categoryId = value;
    _refreshVocabularyViewList();
  }

  Future<void> handleSettingsButtonPressed() async {
    _advancedDrawerController.showDrawer();
  }

  onUsageSearch(String value) {
    setState(() {
      usageSearchMode = true;
      searchTitle = value.toLowerCase();
      _refreshVocabularyViewList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          toolbarHeight: 60 * scaling,
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
                usageSearchMode ? Icons.cancel_rounded : Icons.settings,
                color: usageSearchMode ? neoFormColour : greenNotePaperColour,
              ),
              onPressed: () {
                if (usageSearchMode) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: greenAppbarColour,
                        behavior: SnackBarBehavior.floating,
                        // margin: EdgeInsets.only(bottom: 0.0),
                        content: Text(
                          "back to vocabulary list",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * scaling,
                          ),
                        ),
                        dismissDirection: DismissDirection.up),
                  );
                }
                usageSearchMode ? onSearch() : handleSettingsButtonPressed();
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
                                icon: const Icon(Icons.search_rounded),
                                color: vocabularyView.useThis == 1
                                    ? violetAppbarColour
                                    : lightBlueGrey,
                                // onPressed: () =>
                                //     onUsageSearch(vocabularyView.title ?? ''),
                                onPressed: () {
                                  onUsageSearch(vocabularyView.title ?? '');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: violetAppbarColour,
                                        behavior: SnackBarBehavior.floating,
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
                                  await dbHelper
                                      .deleteVocabulary(vocabularyView);
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
