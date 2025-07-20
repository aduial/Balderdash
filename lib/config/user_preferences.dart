import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../database_helper/database_helper.dart';
import '../screens/category_detail.dart';
import '../screens/template_detail.dart';
import '../model/category.dart';
import '../model/project.dart';
import 'colours.dart';
import 'config.dart';

class UserPreferences extends StatefulWidget {
  const UserPreferences({super.key});

  @override
  State<UserPreferences> createState() => _UserPreferencesState();
  static final navigatorKey = GlobalKey<NavigatorState>();
}

class _UserPreferencesState extends State<UserPreferences> {
  final _catDDKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  final _settingsFormKey = GlobalKey<FormState>();
  late DatabaseHelper dbHelper;
  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  late int categoryId = 1;
  late int projectId = 1;
  late Project curProject;
  late Category curCategory;
  bool initComplete = false;

  @override
  void initState() {
    initComplete = false;
    super.initState();
    loadPreferences();
    // _setSelected();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    projectId = prefs.getInt(defaultProject) ?? 1;
    categoryId = prefs.getInt(defaultCategory) ?? 1;
    dbHelper = DatabaseHelper.instance;
    _projects = dbHelper.getProjects();
    _categories = dbHelper.getCategoriesAbove(1);
    curProject = await dbHelper.getProject(projectId);
    curCategory = await dbHelper.getCategory(categoryId);
    _prjDDKey.currentState?.changeSelectedItem(curProject);
    _catDDKey.currentState?.changeSelectedItem(curCategory);
    initComplete = true;
  }

  void _getLists() {
    setState(() {});
  }

  Future<void> _setSelected() async {}

  storeDefaultCategory(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(defaultCategory, value);
    categoryId = value;
  }

  storeDefaultProject(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(defaultProject, value);
    projectId = value;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double deviceScaling = refHeight / displayHeight;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: greenNotePaperColour,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "User Preferences",
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
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Form(
            key: _settingsFormKey,
            child: ListView(padding: EdgeInsets.all(4), children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<Category>(
                      key: _catDDKey,
                      itemAsString: (item) => item.name!,
                      items: (filter, t) => _categories,
                      onSelected: (Category? item) {
                        if (initComplete) {
                          setState(() {
                            if (item == null) {
                              storeDefaultCategory(1);
                            } else {
                              storeDefaultCategory(item.id!);
                            }
                          });
                          buildSnackBar(context, 'Saving preference');
                        }
                      },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: offWhite,
                            labelText: 'CATEGORY',
                            // labelText: widget.vocabularyView.category,
                            labelStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      compareFn: (item, sItem) => item.id == sItem.id,
                      validator: (item) {
                        if (item == null) {
                          return 'please select a Category';
                        }
                        return null;
                      },
                      popupProps: PopupProps.modalBottomSheet(
                          showSelectedItems: true,
                          showSearchBox: false,
                          itemBuilder: categoryModalItem),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<Project>(
                      key: _prjDDKey,
                      itemAsString: (item) => item.title!,
                      items: (filter, t) => _projects,
                      onSelected: (Project? item) {
                        if (initComplete) {
                          setState(() {
                            if (item == null) {
                              storeDefaultProject(1);
                            } else {
                              storeDefaultProject(item.id!);
                            }
                          });
                          buildSnackBar(context, 'Saving preference');
                        }
                      },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: offWhite,
                            labelText: 'PROJECT',
                            // labelText: widget.vocabularyView.project,
                            labelStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
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
                          itemBuilder: projectModalItem),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(8)),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: cyanAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      buildSnackBar(context, 'Clear default Category');
                      setState(() {
                        _catDDKey.currentState?.clear();
                      });
                    },
                    child: Text("Clear Category"),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4)),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: cyanAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      buildSnackBar(context, 'Clear default project');
                      setState(() {
                        _prjDDKey.currentState?.clear();
                      });
                    },
                    child: Text("Clear Project"),
                    // const Icon(
                    //   Icons.clear,
                    // ),
                  ),
                ),
              ])
            ]),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackBar(
      BuildContext context, String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
          backgroundColor: regularResultBGColour,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
          // margin: EdgeInsets.only(bottom: 0.0),
          content: Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          dismissDirection: DismissDirection.up),
    );
  }
}
