import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database_helper/database_helper.dart';
import '../model/category.dart';
import '../model/project.dart';
import '../screens/category_detail.dart';
import '../screens/template_detail.dart';
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
  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  int categoryId = 1;
  int projectId = 1;
  late int newMarkOnSave;
  late int newCheckOnSave;
  late int newNoNonsense;
  late Project curProject;
  late Category curCategory;
  bool initComplete = false;
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  // late SharedPreferences prefs;

  @override
  void initState() {
    initComplete = false;
    super.initState();
    loadPreferences();
    // loadProjects();
  }

  Future<void> loadPreferences() async {
    newNoNonsense = await asyncPrefs.getInt(noNonsense) ?? 1;
    newMarkOnSave = await asyncPrefs.getInt(markOnSave) ?? 1;
    newCheckOnSave = await asyncPrefs.getInt(checkOnSave) ?? 1;
    categoryId = await asyncPrefs.getInt(defaultCategory) ?? 1;
    projectId = await asyncPrefs.getInt(defaultProject) ?? 1;

    _projects = DatabaseHelper().getProjectsAbove(0, newNoNonsense == 1);
    _categories = DatabaseHelper().getCategoriesAbove(0);
    await setCurrentCategory(categoryId);
    await setCurrentProject(projectId);
    initComplete = true;
    setState(() {});
  }

  // is nog even een dingetje
  // Future<void> loadProjects() async {
  //   if (initComplete) {
  //     _projects = DatabaseHelper().getProjectsAbove(0, newNoNonsense == 1);
  //   }
  // }


  Future<void> storeMarkVocabListOnSave(int value) async {
    newMarkOnSave = value;
    await asyncPrefs.setInt(markOnSave, value);
  }

  Future<void> storeCheckVocabOnSave(int value) async {
    newCheckOnSave = value;
    await asyncPrefs.setInt(checkOnSave, value);
  }

  Future<void> storeNoNonsense(int value) async {
    newNoNonsense = value;
    await asyncPrefs.setInt(noNonsense, value);
  }

  // Future<void> setCheckVocabOnSave(bool value) async {
  //   checkOnSave = value;
  //   await asyncPrefs.setBool("checkVocabOnSave", value);
  // }

  Future<void> setCurrentCategory(int id) async {
    curCategory = await DatabaseHelper().getCategory(id);
    _catDDKey.currentState?.changeSelectedItem(curCategory);
  }

  Future<void> storeDefaultCategory(int id) async {
    categoryId = id;
    await asyncPrefs.setInt(defaultCategory, id);
  }

  Future<void> setCurrentProject(int id) async {
    curProject = await DatabaseHelper().getProject(id);
    _prjDDKey.currentState?.changeSelectedItem(curProject);
  }

  Future<void> storeDefaultProject(int id) async {
    projectId = id;
    await asyncPrefs.setInt(defaultProject, id);
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double scaling = displayHeight / refHeight;
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
      // backgroundColor: Colors.transparent,
      // backgroundColor: notepaperWhite,
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
              vertical: 12 * scaling, horizontal: 8 * scaling),
          child: Form(
            key: _settingsFormKey,
            child: ListView(padding: EdgeInsets.all(4 * scaling), children: [
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
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
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
                  Padding(padding: EdgeInsets.all(4 * scaling)),
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
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
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
              Padding(padding: EdgeInsets.all(8 * scaling)),
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
                        setCurrentCategory(1);
                        storeDefaultCategory(1);
                      });
                    },
                    child: Text("Clear Category"),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4 * scaling)),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: cyanAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      buildSnackBar(context, 'Clear default project');
                      setState(() {
                        setCurrentProject(1);
                        storeDefaultProject(1);
                      });
                    },
                    child: Text("Clear Project"),
                    // const Icon(
                    //   Icons.clear,
                    // ),
                  ),
                ),
              ],
              ),
              Padding(padding: EdgeInsets.all(4 * scaling)),
              Row(children: [
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                ),
                Switch(
                  value: initComplete? newMarkOnSave == 1 : false,
                  activeThumbColor: greenNotePaperColour,
                  activeTrackColor: greenAppbarColour,
                  onChanged: (bool value) {
                    setState(() {
                      newMarkOnSave = value ? 1 : 0;
                      print(newMarkOnSave);
                      storeMarkVocabListOnSave(newMarkOnSave);

                      buildSnackBar(context, 'Saving ...');
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                ),
                Expanded(
                  flex: 1,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Mark errors in vocabulary list on save'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                )
              ]
              ),
              Row(children: [
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                ),
                Switch(
                  value: initComplete? newCheckOnSave == 1 : false,
                  activeThumbColor: greenNotePaperColour,
                  activeTrackColor: greenAppbarColour,
                  onChanged: (bool value) {
                    setState(() {
                      newCheckOnSave = value ? 1 : 0;
                      storeCheckVocabOnSave(newCheckOnSave);
                      buildSnackBar(context, 'Saving ...');
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                ),
                Expanded(
                  flex: 2,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Check vocabulary for errors on save'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                )
              ]
              ),
              Row(children: [
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                ),
                Switch(
                  value: initComplete? newNoNonsense == 1 : false,
                  activeThumbColor: greenNotePaperColour,
                  activeTrackColor: greenAppbarColour,
                  onChanged: (bool value) {
                    setState(() {
                      newNoNonsense = value ? 1 : 0;
                      storeNoNonsense(newNoNonsense);
                      buildSnackBar(context, 'Saving ...');
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                ),
                Expanded(
                  flex: 2,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Hide original Nonsense! demo's"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0 * scaling),
                )
              ]
              )
            ]
          )
          )
        )
      )
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
