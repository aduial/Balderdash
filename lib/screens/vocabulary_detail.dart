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
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:widgets_easier/widgets_easier.dart';

class VocabularyDetail extends StatefulWidget {
  final VocabularyView vocabularyView;
  const VocabularyDetail({super.key, required this.vocabularyView});
  @override
  State<VocabularyDetail> createState() => _VocabularyDetailState();
}

class _VocabularyDetailState extends State<VocabularyDetail> {
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
  final contentController = CodeController();

  bool vvListFetched = false;
  bool isExistingVV = false;
  bool hasProjectSet = false;
  bool isCategorySet = false;

  late Vocabulary newVocabulary;
  late int newCategoryId;
  late int newProjectId;
  late int newUsethis;

  String titleStartState = '';
  String contentStartState = '';
  String commentStartState = '';
  bool categorySetStartState = false;

  @override
  void initState() {
    super.initState();
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
    contentController.language = balderdash;
    contentController.text = widget.vocabularyView.content ?? '';
    commentController.text = widget.vocabularyView.comment == ""
        ? " "
        : widget.vocabularyView.comment ?? '';
    newUsethis = widget.vocabularyView.useThis!;
    setStartState();
  }

  void setStartState() {
    titleStartState = titleController.text;
    contentStartState = contentController.text;
    commentStartState = commentController.text;
    categorySetStartState = isCategorySet;
  }

  void _refreshLists() {
    setState(() {
      _projects = DatabaseHelper().getProjectsAbove(0);
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
      "content": contentController.text,
      "comment": commentController.text,
      "useThis": newUsethis,
    });
  }

  Future<VocabularyView> getVV(int id) async {
    return await DatabaseHelper().getVocabularyView(id);
  }

  bool editsMade() {
    return (titleController.text != titleStartState ||
        contentController.text != contentStartState ||
        commentController.text != commentStartState ||
        isCategorySet != categorySetStartState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              if (editsMade()) {
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
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
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
              if (_vocabularyFormKey.currentState!.validate()) {
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
                Navigator.of(context).pop();
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
                            newCategoryId = item!.id!;
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
                  flex: 3,
                  child: TextFormField(
                    controller: titleController,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0 * scaling),
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
              ]),
              Padding(padding: EdgeInsets.all(1)),
              Row(children: [
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                        // constraints: BoxConstraints(
                        //   maxHeight: 54 * scaling,
                        // ),
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
                    activeColor: greenNotePaperColour,
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
              Padding(
                padding: EdgeInsets.all(3 * scaling),
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
                        controller: contentController,
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
                child: Text(negativeText.toUpperCase(),
                    style: highlightNegative
                        ? const TextStyle(color: Colors.red)
                        : const TextStyle(color: Colors.green)),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: Text(positiveText.toUpperCase(),
                    style: highlightPositive
                        ? const TextStyle(color: Colors.red)
                        : const TextStyle(color: Colors.green)),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          );
        },
      ) ??
      false;
}
