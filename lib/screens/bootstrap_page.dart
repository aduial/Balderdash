// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:nonsense/screens/vocabulary_detail.dart';
import 'package:nonsense/views/vocabulary_view.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:nonsense/model/category.dart';
import 'package:nonsense/model/project.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class BootstrapPage extends StatefulWidget {
  const BootstrapPage({super.key});

  @override
  State<BootstrapPage> createState() => _BootstrapPageState();
}

class _BootstrapPageState extends State<BootstrapPage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final _catDDKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  late DatabaseHelper dbHelper;
  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  late List<VocabularyView> vvList;
  late Future<List<VocabularyView>> _vocabularyViews;
  final ScrollController _scrollController = ScrollController();
  int numItems = 0;
  String searchTerm = '';
  int projectId = 0;
  int categoryId = 0;
  String subTitle = BootstrapSubTitle;

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
    _getLists();
    _refreshVocabularyViewList();
  }

  void _getLists() {
    setState(() {
      _projects = dbHelper.getProjects();
      _categories = dbHelper.getCategories();
    });
  }

  void _refreshVocabularyViewList() {
    setState(() {
      _vocabularyViews = dbHelper.getFilteredVocabulariesBPAC(searchTerm, projectId, categoryId);
      subTitle = setSubTitle();
      // if (categoryId > 0) {
      //   dbHelper.getCategory(categoryId).then((cat) =>
      //       _catDDKey.currentState?.changeSelectedItem(cat));
      // }
      // if (projectId > 0) {
      //   dbHelper.getProject(projectId).then((prj) =>
      //       _prjDDKey.currentState?.changeSelectedItem(prj));
      // }
      _getVocabularyListLength().then((value) {
        setState(() {
          numItems = value;
        });
      });
    });
  }

  String setSubTitle(){
    final whereTitle = StringBuffer('Filtered by ');
    if (projectId == 0 && categoryId == 0) {
      return BootstrapSubTitle;
    } else {
      if (projectId > 0 && categoryId > 0) {
        whereTitle.write("project and category");
      }
      if (projectId == 0 && categoryId > 0) {
        whereTitle.write("category ");
      }
      if (projectId > 0 && categoryId == 0) {
        whereTitle.write("project ");
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

  void handleSettingsButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery
            .of(context)
            .size
            .height - padding.top - padding.bottom;
    double toScale = refHeight / displayHeight;
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tanteRia, blueGrey],
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
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          iconTheme: IconThemeData(
            color: notepaperWhite,
          ),
          backgroundColor: regularResultBGColour,

          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 30,
                child: TextField(
                  style: TextStyle(color: offWhite, fontSize: 16),
                  onChanged: (value) => onSearch(value),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: inActiveLargeSetColour,
                    hintText: "filter vocabularies",
                    contentPadding: EdgeInsets.all(0),
                    prefixIcon: Icon(Icons.search, color: offWhite),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none),
                    hintStyle: TextStyle(fontSize: 14, color: notepaperWhite),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(4)),
              Text(
                subTitle,
                style: TextStyle(
                    color: notepaperGrey, fontSize: 14.0
                ),
              ),
              Padding(padding: EdgeInsets.all(4)),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: notepaperWhite,
              ),
              onPressed: () {
                handleSettingsButtonPressed();
              },
            )
          ],
        ),
        body: FutureBuilder<List<VocabularyView>>(
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
                    height: 36,
                    padding: EdgeInsets.fromLTRB(5.0 * toScale, 0.0,
                        5.0 * toScale, 0.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: toScale, color: tanteRia),
                      ),
                      color: notepaperWhite,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4, 0, 2, 0),
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
                                2, 0, 2 * toScale, 0),
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 0, 2, 0),
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
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.play_arrow_rounded),
                              color: vocabularyView.useThis == 1
                                  ? veryVeryDark
                                  : lightBlueGrey,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VocabularyDetail(
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
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 24.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/plu.png',
                  ),
                ),
                ListTile(
                  onTap: () {
                    _chooseProject();},
                  leading: Icon(Icons.my_library_books_rounded),
                  title: Text('select Project'),
                ),
                ListTile(
                  onTap: () {
                    _chooseCategory();},
                  leading: Icon(Icons.category_rounded),
                  title: Text('select Category'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
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

  void _chooseProject() {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text("Choose Project"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownSearch<Project>(
                  key: _prjDDKey,
                  itemAsString: (item) => item.title!,
                  items: (filter, t) => _projects,
                  onSelected: (Project? item) {
                    setState(() {
                      setFilterProject(item!.id!);
                      _advancedDrawerController.hideDrawer();
                      Navigator.of(context).pop();
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
                        labelStyle:
                        TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                  // selectedItem: currentCategory,
                  compareFn: (item, sItem) => item.title == sItem.title,
                  popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      showSearchBox: false,
                      itemBuilder: projectModalItem),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setFilterProject(0);
                  _advancedDrawerController.hideDrawer();
                  Navigator.of(context).pop();
                },
                child: const Text('Clear Project'),
              ),
              TextButton(
                onPressed: () {
                  _advancedDrawerController.hideDrawer();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _chooseCategory() {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text("Choose Category"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownSearch<Category>(
                  key: _catDDKey,
                  itemAsString: (item) => item.name!,
                  items: (filter, t) => _categories,
                  onSelected: (Category? item) {
                    setState(() {
                      setFilterCategory(item!.id!);
                      _advancedDrawerController.hideDrawer();
                      Navigator.of(context).pop();
                    });
                  },
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        isDense: true,
                        filled: true,
                        fillColor: offWhite,
                        labelText: 'CATEGORY',
                        // labelText: widget.vocabularyView.project,
                        labelStyle:
                        TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                  // selectedItem: currentCategory,
                  compareFn: (item, sItem) => item.name == sItem.name,
                  popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      showSearchBox: false,
                      itemBuilder: categoryModalItem),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setFilterCategory(0);
                  _advancedDrawerController.hideDrawer();
                  Navigator.of(context).pop();
                },
                child: const Text('Clear Category'),
              ),
              TextButton(
                onPressed: () {
                  _advancedDrawerController.hideDrawer();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
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

