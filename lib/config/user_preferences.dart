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
  final _catAppKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjAppKey = GlobalKey<DropdownSearchState<Project>>();
  final _catRVocKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjRVocKey = GlobalKey<DropdownSearchState<Project>>();
  final _settingsFormKey = GlobalKey<FormState>();
  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  int appCategoryId = 1;
  int appProjectId = 1;
  int rVocCategoryId = 1;
  int rVocProjectId = 1;
  late int newMarkOnSave;
  late int newCheckOnSave;
  late int newNoNonsense;
  late Project curAppProject;
  late Category curAppCategory;
  late Project curRVocProject;
  late Category curRVocCategory;
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
    appCategoryId = await asyncPrefs.getInt(appCategory) ?? 1;
    appProjectId = await asyncPrefs.getInt(appProject) ?? 1;
    rVocCategoryId = await asyncPrefs.getInt(rVocCategory) ?? 1;
    rVocProjectId = await asyncPrefs.getInt(rVocProject) ?? 1;

    _projects = DatabaseHelper().getProjectsAbove(0, newNoNonsense == 1);
    _categories = DatabaseHelper().getCategoriesAbove(0);
    await setAppCategory(appCategoryId);
    await setAppProject(appProjectId);
    await setRVocCategory(rVocCategoryId);
    await setRVocProject(rVocProjectId);
    initComplete = true;
    setState(() {});
  }

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

  Future<void> setAppCategory(int id) async {
    curAppCategory = await DatabaseHelper().getCategory(id);
    _catAppKey.currentState?.changeSelectedItem(curAppCategory);
  }

  Future<void> storeAppCategory(int id) async {
    appCategoryId = id;
    await asyncPrefs.setInt(appCategory, id);
  }

  Future<void> setAppProject(int id) async {
    curAppProject = await DatabaseHelper().getProject(id);
    _prjAppKey.currentState?.changeSelectedItem(curAppProject);
  }

  Future<void> storeAppProject(int id) async {
    appProjectId = id;
    await asyncPrefs.setInt(appProject, id);
  }

  Future<void> setRVocCategory(int id) async {
    curRVocCategory = await DatabaseHelper().getCategory(id);
    _catRVocKey.currentState?.changeSelectedItem(curRVocCategory);
  }

  Future<void> storeRVocCategory(int id) async {
    rVocCategoryId = id;
    await asyncPrefs.setInt(rVocCategory, id);
  }

  Future<void> setRVocProject(int id) async {
    curRVocProject = await DatabaseHelper().getProject(id);
    _prjRVocKey.currentState?.changeSelectedItem(curRVocProject);
  }

  Future<void> storeRVocProject(int id) async {
    rVocProjectId = id;
    await asyncPrefs.setInt(rVocProject, id);
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double scaling = displayHeight / refHeight;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: greenNotePaperColour),
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
            vertical: 12 * scaling,
            horizontal: 8 * scaling,
          ),
          child: Form(
            key: _settingsFormKey,
            child: ListView(
              padding: EdgeInsets.all(4 * scaling),
              children: [
                DefaultTextStyle.merge(
                  style: TextStyle(
                    color: offWhite,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: darkerBlueGrey),
                      borderRadius: BorderRadius.circular(10 * scaling),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [middleGreen, middleGreen],
                      ),
                    ),
                    padding: EdgeInsets.all(7),
                    child: Text(
                      "Vocabulary editor default Category and Project",
                    ),
                  ),
                ),
                Row(
                  children: [Padding(padding: EdgeInsets.all(10.0 * scaling))],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownSearch<Category>(
                        key: _catAppKey,
                        itemAsString: (item) => item.name!,
                        items: (filter, t) => _categories,
                        onSelected: (Category? item) {
                          if (initComplete) {
                            setState(() {
                              if (item == null) {
                                storeAppCategory(1);
                              } else {
                                storeAppCategory(item.id!);
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
                            fillColor: notepaperYellow,
                            labelText: 'CATEGORY',
                            // labelText: widget.vocabularyView.category,
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
                            ),
                          ),
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
                          itemBuilder: categoryModalItem,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4 * scaling)),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: middleGreen,
                          backgroundColor: notepaperYellow,
                          iconColor: cyanAppbarColour,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          buildSnackBar(context, 'Clear default app category');
                          setState(() {
                            setAppCategory(1);
                            storeAppCategory(1);
                          });
                        },
                        child: Text("Clear"),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(5 * scaling)),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownSearch<Project>(
                        key: _prjAppKey,
                        itemAsString: (item) => item.title!,
                        items: (filter, t) => _projects,
                        onSelected: (Project? item) {
                          if (initComplete) {
                            setState(() {
                              if (item == null) {
                                storeAppProject(1);
                              } else {
                                storeAppProject(item.id!);
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
                            fillColor: notepaperYellow,
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

                    Padding(padding: EdgeInsets.all(4 * scaling)),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: middleGreen,
                          backgroundColor: notepaperYellow,
                          iconColor: cyanAppbarColour,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          buildSnackBar(context, 'Clear default app project');
                          setState(() {
                            setAppProject(1);
                            storeAppProject(1);
                          });
                        },
                        child: Text("Clear"),
                        // const Icon(
                        //   Icons.clear,
                        // ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [Padding(padding: EdgeInsets.all(15.0 * scaling))],
                ),
                DefaultTextStyle.merge(
                  style: TextStyle(
                    color: offWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: darkerBlueGrey),
                      borderRadius: BorderRadius.circular(10 * scaling),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [middleBlue, middleBlue],
                      ),
                    ),
                    padding: EdgeInsets.all(7),
                    child: Text("General application settings"),
                  ),
                ),
                Padding(padding: EdgeInsets.all(6 * scaling)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                    Switch(
                      value: initComplete ? newMarkOnSave == 1 : false,
                      activeThumbColor: blueNotePaperColour,
                      activeTrackColor: middleBlue,
                      onChanged: (bool value) {
                        setState(() {
                          newMarkOnSave = value ? 1 : 0;
                          // print(newMarkOnSave);
                          storeMarkVocabListOnSave(newMarkOnSave);
                          buildSnackBar(context, 'Saving ...');
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                    Expanded(
                      flex: 1,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Mark errors in vocabulary list on Save'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                  ],
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                    Switch(
                      value: initComplete ? newCheckOnSave == 1 : false,
                      activeThumbColor: blueNotePaperColour,
                      activeTrackColor: middleBlue,
                      onChanged: (bool value) {
                        setState(() {
                          newCheckOnSave = value ? 1 : 0;
                          storeCheckVocabOnSave(newCheckOnSave);
                          buildSnackBar(context, 'Saving ...');
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                    Expanded(
                      flex: 2,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Check vocabulary for errors on save'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                  ],
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                    Switch(
                      value: initComplete ? newNoNonsense == 1 : false,
                      activeThumbColor: blueNotePaperColour,
                      activeTrackColor: middleBlue,
                      onChanged: (bool value) {
                        setState(() {
                          newNoNonsense = value ? 1 : 0;
                          storeNoNonsense(newNoNonsense);
                          buildSnackBar(context, 'Saving ...');
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                    Expanded(
                      flex: 2,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Hide original Nonsense! content"),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4.0 * scaling)),
                  ],
                ),

                Row(
                  children: [Padding(padding: EdgeInsets.all(12.0 * scaling))],
                ),

                DefaultTextStyle.merge(
                  style: TextStyle(
                    color: offWhite,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: darkerBlueGrey),
                      borderRadius: BorderRadius.circular(10 * scaling),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [middleRed, middleRed],
                      ),
                    ),
                    padding: EdgeInsets.all(7),
                    child: Text("Run Balderdash default Category and Project"),
                  ),
                ),
                Row(
                  children: [Padding(padding: EdgeInsets.all(10.0 * scaling))],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownSearch<Category>(
                        key: _catRVocKey,
                        itemAsString: (item) => item.name!,
                        items: (filter, t) => _categories,
                        onSelected: (Category? item) {
                          if (initComplete) {
                            setState(() {
                              if (item == null) {
                                storeRVocCategory(1);
                              } else {
                                storeRVocCategory(item.id!);
                              }
                            });
                            buildSnackBar(
                              context,
                              'Saving default Run Vocab category',
                            );
                          }
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: notepaperOrange,
                            labelText: 'CATEGORY',
                            // labelText: widget.vocabularyView.category,
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
                            ),
                          ),
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
                          itemBuilder: categoryModalItem,
                        ),
                      ),
                    ),

                    Padding(padding: EdgeInsets.all(4 * scaling)),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: redAppbarColour,
                          backgroundColor: notepaperOrange,
                          iconColor: cyanAppbarColour,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          buildSnackBar(
                            context,
                            'Clear default run Balderdash category',
                          );
                          setState(() {
                            setRVocCategory(1);
                            storeRVocCategory(1);
                          });
                        },
                        child: Text("Clear"),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(5 * scaling)),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownSearch<Project>(
                        key: _prjRVocKey,
                        itemAsString: (item) => item.title!,
                        items: (filter, t) => _projects,
                        onSelected: (Project? item) {
                          if (initComplete) {
                            setState(() {
                              if (item == null) {
                                storeRVocProject(1);
                              } else {
                                storeRVocProject(item.id!);
                              }
                            });
                            buildSnackBar(
                              context,
                              'Saving default Run Vocab project',
                            );
                          }
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: notepaperOrange,
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

                    Padding(padding: EdgeInsets.all(4 * scaling)),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: redAppbarColour,
                          backgroundColor: notepaperOrange,
                          iconColor: cyanAppbarColour,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          buildSnackBar(
                            context,
                            'Clear default Run Balderdash project',
                          );
                          setState(() {
                            setRVocProject(1);
                            storeRVocProject(1);
                          });
                        },
                        child: Text("Clear"),
                        // const Icon(
                        //   Icons.clear,
                        // ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackBar(
    BuildContext context,
    String msg,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: regularResultBGColour,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
        // margin: EdgeInsets.only(bottom: 0.0),
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        dismissDirection: DismissDirection.up,
      ),
    );
  }
}
