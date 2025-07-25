// ignore_for_file: sort_child_properties_last

import 'package:auto_size_text/auto_size_text.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/model/category.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/screens/run_page.dart';
import 'package:balderdash/screens/vocabulary_detail.dart';
import 'package:balderdash/views/vocabulary_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectVocPage extends StatefulWidget {
  const SelectVocPage({super.key});

  @override
  State<SelectVocPage> createState() => _SelectVocPageState();
}

class _SelectVocPageState extends State<SelectVocPage> {
  static SharedPreferences? _preferences;

  final _advancedDrawerController = AdvancedDrawerController();
  final _catDDKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();

  final ScrollController _scrollController = ScrollController();

  late DatabaseHelper dbHelper;
  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  late List<VocabularyView> vvList;
  late Future<List<VocabularyView>> _vocabularyViews;
  List<VocabularyView> filteredVocabularies = [];

  String subTitle = BootstrapSubTitle;
  String searchTerm = '';
  int projectId = 1;
  int categoryId = 1;
  int numItems = 0;
  late Project curProject;
  late Category curCategory;
  bool initComplete = false;

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
          searchTerm, projectId, categoryId);
      subTitle = setSubTitle();
      _getVocabularyListLength().then((value) {
        setState(() {
          numItems = value;
        });
      });
    });
  }

  String setSubTitle() {
    // print("subtitles");
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

  onSearch(String value) {
    searchTerm = value;
    _refreshVocabularyViewList();
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
      // openScale: 1.0,
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
            color: redNotePaperColour,
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
                  onChanged: (value) => onSearch(value),
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
                Icons.settings,
                color: redNotePaperColour,
              ),
              onPressed: () {
                handleSettingsButtonPressed();
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
                      height: 36 * scaling,
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
                            flex: 6,
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
                              iconSize: 20,
                              icon: vocabularyView.useThis == 1
                                  ? const Icon(Icons.play_arrow_rounded)
                                  : const Icon(Icons.stop_rounded),
                              color: vocabularyView.useThis == 1
                                  ? redAppbarColour
                                  : lightBlueGrey,
                              onPressed: () {
                                if (vocabularyView.useThis == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RunPage(
                                          vocabularyView: vocabularyView),
                                    ),
                                  ).then((value) {
                                    setState(() {
                                      _refreshVocabularyViewList();
                                    });
                                  });
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
                    child: Text('Terms of Service | Privacy Policy'),
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
