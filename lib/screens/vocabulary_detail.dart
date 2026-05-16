import 'package:balderdash/config/balderdash_theme_colours.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/language/balderdash.dart';
import 'package:balderdash/model/category.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/model/vocabulary.dart';
import 'package:balderdash/screens/run_page.dart';
import 'package:balderdash/views/vocabulary_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:widgets_easier/widgets_easier.dart';
import '../utils/vocab_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VocabularyDetail extends StatefulWidget {
  final VocabularyView vocabularyView;
  const VocabularyDetail({super.key, required this.vocabularyView});
  @override
  State<VocabularyDetail> createState() => _VocabularyDetailState();
}

class _VocabularyDetailState extends State<VocabularyDetail> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  final _catDDKey = GlobalKey<DropdownSearchState<Category>>();
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  final _vocabularyFormKey = GlobalKey<FormState>();
  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  late List<VocabularyView> vvList;
  final TextEditingController titleController = TextEditingController(text: '');
  final TextEditingController commentController =
      TextEditingController(text: '');
  final TextEditingController testController = TextEditingController(text: '');
  final codeController = CodeController();

  bool vvListFetched = false;
  bool isExistingVV = false;
  bool hasProjectSet = false;
  bool isCategorySet = false;

  late Vocabulary newVocabulary;
  late int newCategoryId;
  late int newProjectId;
  late int newUsethis;
  int showNoNonsense = 1;
  int checkVocOnSave = 1;

  String titleStartState = '';
  String contentStartState = '';
  String commentStartState = '';
  bool categorySetStartState = false;
  bool prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadPreferences();
    _refreshLists();

    isExistingVV = (null != widget.vocabularyView.id);
    if (isExistingVV) {
      newCategoryId = widget.vocabularyView.categoryId!;
      DatabaseHelper()
          .getCategory(newCategoryId)
          .then((cat) => _catDDKey.currentState?.changeSelectedItem(cat));
    }

    hasProjectSet = (null != widget.vocabularyView.projectId);
    if (hasProjectSet) {
      newProjectId = widget.vocabularyView.projectId!;
      DatabaseHelper()
          .getProject(newProjectId)
          .then((prj) => _prjDDKey.currentState?.changeSelectedItem(prj));
    }

    titleController.text = widget.vocabularyView.title!;
    codeController.language = balderdash;
    codeController.text = widget.vocabularyView.content ?? '';
    commentController.text = widget.vocabularyView.comment == ""
        ? " "
        : widget.vocabularyView.comment ?? '';
    newUsethis = widget.vocabularyView.useThis!;
    setStartState();
  }

  Future loadPreferences() async {
    checkVocOnSave = await asyncPrefs.getInt(checkOnSave) ?? 1;
    showNoNonsense = await asyncPrefs.getInt(noNonsense) ?? 1;
    _projects = DatabaseHelper().getProjectsAbove(0, showNoNonsense == 1);
  }

  void setStartState() {
    titleStartState = titleController.text;
    contentStartState = codeController.text;
    commentStartState = commentController.text;
    categorySetStartState = isCategorySet;
    codeController.popupController.enabled = false;
    // contentController.selection.
  }

  void _refreshLists() {
    setState(() {
      _projects = DatabaseHelper().getProjectsAbove(0, showNoNonsense == 1);
      _categories = DatabaseHelper().getCategoriesAbove(1);
    });
  }

  onTitleChanged(String title) async {
    if (!vvListFetched) {
      vvList = await DatabaseHelper().getVocabularyViews();
      vvListFetched = true;
    }
  }

  Vocabulary makeNewVocabulary() {
    return Vocabulary.fromMap({
      "id": widget.vocabularyView.id,
      "categoryId": newCategoryId,
      "projectId": newProjectId,
      "title": titleController.text,
      "content": codeController.text,
      "comment": commentController.text,
      "useThis": newUsethis,
    });
  }

  Future<VocabularyView> getVV(int id) async {
    return await DatabaseHelper().getVocabularyView(id);
  }

  bool editsNotSaved() {
    return (titleController.text != titleStartState ||
        codeController.text != contentStartState ||
        commentController.text != commentStartState ||
        isCategorySet != categorySetStartState);
  }

  // launches the Vocabulary detail screen and awaits the result from Navigator.pop
  Future<void> _navigateToSelected(BuildContext context) async {
    bool inThisProject = false;
    VocabularyView selVV;
    bool inLibrary = false;
    int outOfScope = 0;
    int? status = 0;

    List<VocabularyView> foundList;
    String selected = codeController.selection.textInside(codeController.text);
    foundList = await DatabaseHelper().getVocabularyViewByTitle(selected.toUpperCase());

    if (foundList.isEmpty){
      if (mounted && context.mounted) {
        await showConfirmationAlertMonolog(
          context,
          title: "No vocabulary with title $selected found",
          message: "better luck next time",
          text: 'Drat!',
          highlight: true,
        );
      }
      return;
    } else if (foundList.length == 1 && context.mounted){
      if (foundList[0].projectId == 1 ||
          foundList[0].projectId == widget.vocabularyView.projectId) {
        openSelected(context, foundList[0]);
      } else {
        if (mounted) {
          // just wait for the click
          await showConfirmationAlertMonolog(
            context,
            title: "Vocabulary $selected not accessible",
            message: "it's in project $foundList[0].project",
            text: 'Darn!',
            highlight: true,
          );
        }
        return;
      }
    } else {
      // found > 1
      StringBuffer outOfScopeProjects = StringBuffer("'");
      for (VocabularyView foundVV in foundList) {
        if (foundVV.projectId == widget.vocabularyView.projectId) {
          inThisProject = true;
        } else if (foundVV.projectId == 1) {
          inLibrary = true;
        } else {
          outOfScope++;
          outOfScope > 1
              ? outOfScopeProjects.write("| ")
              : outOfScopeProjects.write("");
          outOfScopeProjects.write(foundVV.project);
        }
      }
      outOfScopeProjects.write("'");
      if (foundList.length == outOfScope) {
        // none in scope, bad luck
        status = 1;
      } else if (foundList.length - outOfScope == 1) {
        // there can only be one in scope, either project OR library
        if (inThisProject) {
          // it's in the project
          status = 2;
        } else {
          // it's in the library
          status = 3;
        }
      } else {
        // difference = 2, one in the project and one in the library, offer choice
        if (foundList.length == 2) {
          status = 4;
        } else {
          // there is also at least one out of scope, inform user
          status = 5;
        }
      }

      if (mounted && context.mounted) {
        final bool response = await showConfirmationAlertDialog(
          context,
          title:
          'Multiple versions of $selected exist',
          message: status == 1
              ? "unfortunately neither is in scope of the current project: they're in "
              "$outOfScopeProjects. Consider copying or moving one to the Library."
              : status == 2
              ? "Open the one in the current project?\n(the other is out of scope, in $outOfScopeProjects)."
              : status == 3
              ? "Open the one in the Library?\n(the other is out of scope, in $outOfScopeProjects)."
              : status == 4
              ? "Open the version in the current project or the one from the library?"
              : status == 5
              ? "Open the version in the current project or the one from the library?"
              "\n(Other version(s) out of scope in $outOfScopeProjects)"
              : "Unexpected error occurred",
          positiveText: status == 1
              ? 'cancel'
              : status < 4
              ? 'cancel'
              : 'library',
          negativeText: status == 1
              ? 'cancel'
              : status < 4
              ? 'open'
              : 'this project',
          highlightPositive: true,
        );
        if (response && context.mounted) {
          if (status == 1) {
            return;
          } else if (status == 2) {
            openSelected(context, pickVV(foundList, widget.vocabularyView.projectId!)!);
          } else if (status == 3) {
            openSelected(context, pickVV(foundList, 1)!);
          } else {
            openSelected(context, pickVV(foundList, widget.vocabularyView.projectId!)!);
          }
        } else {
          if (status < 4 ) {
            return;
          } else if (context.mounted) {
            openSelected(context, pickVV(foundList, 1)!);
          }
        }
      }
    }
    print(selected);
  }

  VocabularyView? pickVV(List<VocabularyView> vvl, int projectId){
    for (VocabularyView vv in vvl){
      if (vv.projectId == projectId){
        return vv;
      }
    }
    return null;
  }

  Future<void> openSelected(BuildContext context, VocabularyView vView) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute<bool>(
            builder: (context) =>
                VocabularyDetail(
                  vocabularyView: vView,
                )
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              if (editsNotSaved()) {
                final bool goBack = await showConfirmationAlertDialog(
                  context,
                  title: 'Dismiss your edits?',
                  message:
                      "You made some changes that will be lost if you close the screen. 'Stay' to "
                      "save the vocabulary first; 'Dismiss' to close the screen.",
                  positiveText: 'Dismiss',
                  negativeText: 'Stay',
                  highlightPositive: true,
                );
                if (goBack) {
                  return;
                } else {
                  setState(() {
                    Navigator.of(context).pop(true);
                  });
                }
              } else {
                Navigator.of(context).pop(false);
              }
            },
            icon: BackButtonIcon(),
            color: greenNotePaperColour),
        iconTheme: IconThemeData(
          color: greenNotePaperColour,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Edit ${widget.vocabularyView.title!}",
          style: TextStyle(color: notepaperWhite),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: greenNotePaperColour,
            ),
            onPressed: () async {
              if (checkVocOnSave == 1) {
                String checkResults = VocabUtils.checkContent(
                    codeController.text);
                if (checkResults.isNotEmpty) {
                  final bool goBack = await showConfirmationAlertDialog(
                    context,
                    title: 'Errors found!',
                    message:
                    "Line(s): $checkResults\n\n"
                        "'Cancel' to fix the errors, 'Save' to continue saving.",
                    positiveText: 'Save',
                    negativeText: 'Cancel',
                    highlightPositive: true,
                  );
                  if (goBack) {
                    return;
                  }
                }
              }
              if (_vocabularyFormKey.currentState!.validate()) {
                // if (VocabularyPage().)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: regularResultBGColour,
                      behavior: SnackBarBehavior.fixed,
                      // margin: EdgeInsets.only(bottom: 0.0),
                      content: Text(
                        'Saving vocabulary',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18 * scaling,
                        ),
                      ),
                      dismissDirection: DismissDirection.none),
                );
                newVocabulary = makeNewVocabulary();
                await DatabaseHelper().upsertVocabulary(newVocabulary);
                Navigator.of(context).pop(true);
              }
            },
          )
        ],
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
              vertical: 12 * scaling, horizontal: 8 * scaling),
          child: Form(
            key: _vocabularyFormKey,
            child: ListView(padding: EdgeInsets.all(2 * scaling), children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownSearch<Category>(
                      key: _catDDKey,
                      itemAsString: (item) => item.name!,
                      items: (filter, t) => _categories,
                      onSelected: (Category? item) {
                        setState(() {
                          if (item != null) {
                            isCategorySet = true;
                            newCategoryId = item.id!;
                            setStartState();
                          }
                        });
                      },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            constraints: BoxConstraints(
                              maxHeight: 40 * scaling,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: offWhite,
                            labelText: 'CATEGORY',
                            contentPadding: EdgeInsets.fromLTRB(
                                10 * scaling, 0, 0, 10 * scaling),
                            // labelText: widget.vocabularyView.category,
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
                            )),
                      ),
                      compareFn: (item, sItem) => item.id == sItem.id,
                      validator: (item) {
                        if (item == null && !isExistingVV) {
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
                    flex: 3,
                    child: DropdownSearch<Project>(
                      key: _prjDDKey,
                      itemAsString: (item) => item.title!,
                      items: (filter, t) => _projects,
                      onSelected: (Project? item) {
                        setState(() {
                          newProjectId = item!.id!;
                        });
                      },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            constraints: BoxConstraints(
                              maxHeight: 40 * scaling,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: offWhite,
                            labelText: 'PROJECT',
                            contentPadding: EdgeInsets.fromLTRB(
                                10 * scaling, 0, 0, 10 * scaling),
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
                            )),
                      ),
                      // selectedItem: currentCategory,
                      compareFn: (item, sItem) => item.title == sItem.title,
                      validator: (item) {
                        if (item == null && !isExistingVV) {
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
              Padding(padding: EdgeInsets.all(3)),
              Row(children: [
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    controller: titleController,
                    inputFormatters: [
                      UppercaseTextFormatter(),
                    ],
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        fillColor: offWhite,
                        labelText: 'TITLE',
                        contentPadding: EdgeInsets.fromLTRB(10 * scaling,
                            6 * scaling, 6 * scaling, 10 * scaling),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * scaling),
                        )),
                    maxLines: 1,
                    onChanged: (value) => onTitleChanged(value),
                    validator: (value) {
                      if (isExistingVV &&
                          value == widget.vocabularyView.title) {
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      List<VocabularyView> titleVVList =
                          vvList.where((i) => i.title == value).toList();
                      List<VocabularyView> filterVVList = titleVVList
                          .where((j) => j.projectId == newProjectId)
                          .toList();
                      if (filterVVList.isNotEmpty) {
                        return "${filterVVList[0].title!} exist in '${filterVVList[0].project!}'";
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('use?'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0 * scaling),
                ),
                Expanded(
                  flex: 1,
                  child: Switch(
                    value: newUsethis == 1,
                    activeThumbColor: greenNotePaperColour,
                    activeTrackColor: greenAppbarColour,
                    onChanged: (bool value) {
                      setState(() {
                        newUsethis = value ? 1 : 0;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0 * scaling),
                ),
              ]),
              Padding(padding: EdgeInsets.all(3)),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: offWhite,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'COMMENT',
                        contentPadding: EdgeInsets.fromLTRB(10 * scaling,
                            6 * scaling, 6 * scaling, 10 * scaling),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * scaling),
                        )),
                    maxLines: 1,
                    // onChanged: (value) => onCommentChanged(),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0 * scaling),
                ),
              ]),
              Padding(
                padding: EdgeInsets.all(5 * scaling),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: InsetBorder(width: 3 * scaling),
                ),
                child: SizedBox(
                  height: 460 * scaling,
                  width: double.infinity,
                  child: CodeTheme(
                    data: CodeThemeData(styles: balderdashTheme),
                    child: SingleChildScrollView(
                      child: CodeField(
                        background: offWhite,
                        cursorColor: darkVerbatimMatchColour,
                        controller: codeController,
                        textStyle: TextStyle(
                            fontSize: 12 * scaling,
                            fontFamily: "Courier",
                            fontWeight: FontWeight.normal),
                        gutterStyle: GutterStyle(
                            margin: 5 * scaling,
                            textStyle: TextStyle(
                              height: 1.5,
                              fontSize: 12,
                              fontFamily: "Courier",
                              fontWeight: FontWeight.bold,
                              color: lightAnyMatchColour,
                            ),
                            showErrors: false,
                            showFoldingHandles: false,
                            showLineNumbers: true,
                            width: 66 * scaling,
                            background: offWhite),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6 * scaling),
              ),
              Row(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22 *  scaling),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size.fromHeight(40 * scaling),
                      iconColor: greenAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      _navigateToSelected(context);
                    },
                    child: const Text(
                      "Go to selected",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 *  scaling),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size.fromHeight(40 * scaling),
                      iconColor: greenAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () async {
                      newVocabulary = makeNewVocabulary();
                      await DatabaseHelper().upsertVocabulary(newVocabulary);
                      VocabularyView newVV = await getVV(newVocabulary.id!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RunPage(vocabularyView: newVV),
                        ),
                      );
                    },
                    child: const Text(
                      "Test",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22 *  scaling),
                )
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

Widget categoryModalItem(
    BuildContext context, Category item, bool isDisabled, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8 * scaling),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20 * scaling),
            color: inActiveMinimalSetColour,
          ),
    child: ListTile(
        selected: isSelected,
        dense: true,
        visualDensity: VisualDensity(vertical: -1),
        title: Text(
          item.name!,
          style: TextStyle(
              fontSize: 14 * scaling,
              color: isSelected ? offWhite : onPrimaryFixed),
        )),
  );
}

Widget projectModalItem(
    BuildContext context, Project item, bool isDisabled, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8 * scaling),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20 * scaling),
            color: inActiveMinimalSetColour,
          ),
    child: ListTile(
        selected: isSelected,
        dense: true,
        visualDensity: VisualDensity(vertical: -1),
        title: Text(
          item.title!,
          style: TextStyle(
              fontSize: 14 * scaling,
              color: isSelected ? offWhite : onPrimaryFixed),
        )),
  );
}


Future<void> showConfirmationAlertMonolog(
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
            child: Text(text.toUpperCase(),
                style: highlight
                    ? const TextStyle(color: Colors.red)
                    : const TextStyle(color: Colors.green)),
            onPressed: () => Navigator.of(ctx).pop(false),
          )
        ],
      );
    },
  );
}

Future<bool> showConfirmationAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String positiveText,
  required String negativeText,
  bool highlightPositive = false,
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
                child: Text(negativeText.toUpperCase(),
                    style: !highlightPositive
                        ? const TextStyle(color: Colors.blueGrey)
                        : const TextStyle(color: Colors.deepOrange)),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
              TextButton(
                child: Text(positiveText.toUpperCase(),
                    style: highlightPositive
                        ? const TextStyle(color: Colors.blueGrey)
                        : const TextStyle(color: Colors.deepOrange)),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
            ],
          );
        },
      ) ??
      false;
}

class UppercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
