import 'package:flutter/material.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/model/vocabulary.dart';
import 'package:balderdash/model/category.dart';
import 'package:balderdash/views/vocabulary_view.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:balderdash/widgets/content_editor.dart';
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
  late DatabaseHelper dbHelper;
  late Future<List<Project>> _projects;
  late Future<List<Category>> _categories;
  late List<VocabularyView> vvList;
  final TextEditingController titleController = TextEditingController(text: '');
  final TextEditingController contentController =
      TextEditingController(text: '');
  // final ScrollController contentScrollController = ScrollController();
  final TextEditingController commentController =
      TextEditingController(text: '');

  bool vvListFetched = false;
  bool isExistingVV = false;

  late Vocabulary newVocabulary;
  late int newCategoryId;
  late int newProjectId;
  late String newTitle;
  late String newContent;
  late String newComment;
  late int newUsethis;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshLists();
    isExistingVV = (null != widget.vocabularyView.id);
    if (isExistingVV) {
      newCategoryId = widget.vocabularyView.categoryId!;
      dbHelper.getCategory(newCategoryId).then((cat) => _catDDKey.currentState?.changeSelectedItem(cat));
      newProjectId = widget.vocabularyView.projectId!;
      dbHelper.getProject(newProjectId).then((prj) => _prjDDKey.currentState?.changeSelectedItem(prj));
    }
    newTitle = widget.vocabularyView.title!;
    newContent = widget.vocabularyView.content!;
    newComment =
        widget.vocabularyView.comment == ""
            ? " "
            : widget.vocabularyView.comment!;
    newUsethis = widget.vocabularyView.useThis!;
  }

  void _refreshLists() {
    setState(() {
      _projects = dbHelper.getProjects();
      _categories = dbHelper.getCategoriesAbove(1);
    });
  }

  setUpdatedCategory(int categoryId) async {
    if (!vvListFetched) {
      vvList = await dbHelper.getVocabularyViews();
      vvListFetched = true;
    }
    newCategoryId = categoryId;
  }

  setUpdatedProject(int projectId) async {
    if (!vvListFetched) {
      vvList = await dbHelper.getVocabularyViews();
      vvListFetched = true;
    }
    newProjectId = projectId;
  }

  onTitleChanged(String title) async {
    if (!vvListFetched) {
      vvList = await dbHelper.getVocabularyViews();
      vvListFetched = true;
    }
    newTitle = title;
  }

  onContentChanged(String content) async {
    if (!vvListFetched) {
      vvList = await dbHelper.getVocabularyViews();
      vvListFetched = true;
    }
    newContent = content;
  }

  onCommentChanged(String comment) async {
    if (!vvListFetched) {
      vvList = await dbHelper.getVocabularyViews();
      vvListFetched = true;
    }
    newComment = comment;
  }

  onUseThisChanged(int useThis) async {
    if (!vvListFetched) {
      vvList = await dbHelper.getVocabularyViews();
      vvListFetched = true;
    }
    newUsethis = useThis;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double deviceScaling = refHeight / displayHeight;
    titleController.text = newTitle;
    contentController.text = newContent;
    commentController.text = newComment;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: greenNotePaperColour,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Edit ${widget.vocabularyView.title!}",
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
            key: _vocabularyFormKey,
            child: ListView(padding: EdgeInsets.all(4),
                children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<Category>(
                      key: _catDDKey,
                      itemAsString: (item) => item.name!,
                      items: (filter, t) => _categories,
                      onSelected: (Category? item) {
                        setState(() {
                          setUpdatedCategory(item!.id!);
                        });
                      },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                          filled: true,
                          fillColor: offWhite,
                            labelText: 'CATEGORY',
                          // labelText: widget.vocabularyView.category,
                          labelStyle:
                              TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
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
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<Project>(
                      key: _prjDDKey,
                      itemAsString: (item) => item.title!,
                      items: (filter, t) => _projects,
                      onSelected: (Project? item) {
                        setState(() {
                          setUpdatedProject(item!.id!);
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
              Padding(padding: EdgeInsets.all(8)),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: titleController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: offWhite,
                        labelText: 'VOCABULARY TITLE',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                    maxLines: 1,
                    onChanged: (value) => onTitleChanged(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      if (value == newVocabularyTitle) {
                        return "Please change the default new title '$newVocabularyTitle'";
                      }
                      List<VocabularyView> titleVVList =
                          vvList.where((i) => i.title == value).toList();
                      List<VocabularyView> filterVVList =
                          titleVVList.where((j) => j.projectId == newProjectId).toList();
                      if (filterVVList.isNotEmpty) {
                        return "Vocabulary ${filterVVList[0].title!} already exist in project '${filterVVList[0].project!}'";
                      }
                      return null;
                    },
                  ),
                ),
              ]),
              Padding(padding: EdgeInsets.all(6)),
              Container(
                decoration: const ShapeDecoration(
                  shape: InsetBorder(width: 3),
                ),
                child: SizedBox(
                  height: 460 * deviceScaling,
                  width: double.infinity,
                  child: ContentEditor(
                    content: widget.vocabularyView.content!,
                    onContentUpdated: (String updatedContent){
                      onContentChanged(updatedContent);},
                      isVocabulary: true
                    ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(6),
              ),
              Row(children: [
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: offWhite,
                        labelText: 'COMMENT',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                    maxLines: 1,
                    onChanged: (value) => onCommentChanged(value),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text('use?'),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                // ),
                Expanded(
                  flex: 2,
                  child:  Switch(
                    value: newUsethis == 1,
                    activeColor: greenNotePaperColour,
                    activeTrackColor: greenAppbarColour,
                    onChanged: (bool value) {
                      setState(() {
                        onUseThisChanged(value ? 1 : 0);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                ),
                Expanded(
                  flex: 3,
                  child:  ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            iconColor: greenAppbarColour,
                            shadowColor: Colors.black,
                    ),
                    onPressed: () async {
                      if (_vocabularyFormKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: regularResultBGColour,
                              behavior: SnackBarBehavior.fixed,
                              // margin: EdgeInsets.only(bottom: 0.0),
                              content: Text('Saving vocabulary',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              dismissDirection: DismissDirection.none
                          ),
                        );
                        newVocabulary = Vocabulary.fromMap({
                          "id": widget.vocabularyView.id,
                          "categoryId": newCategoryId,
                          "projectId": newProjectId,
                          "title": newTitle,
                          "content": newContent,
                          "comment": newComment,
                          "useThis": newUsethis,
                        });
                        await dbHelper.upsertVocabulary(newVocabulary);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Icon(
                        Icons.save,
                    ),
                  ),
                ),
              ]),
            ]
            ),
          ),
        ),
      ),
    );
  }
}

Widget categoryModalItem(
    BuildContext context, Category item, bool isDisabled, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20),
            color: inActiveMinimalSetColour,
          ),
    child: ListTile(
        selected: isSelected,
        dense: true,
        visualDensity: VisualDensity(vertical: -1),
        title: Text(
          item.name!,
          style: TextStyle(
              fontSize: 14,
              color: isSelected ? offWhite : onPrimaryFixed),
        )),
  );
}

Widget projectModalItem(
    BuildContext context, Project item, bool isDisabled, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20),
            color: inActiveMinimalSetColour,
          ),
    child: ListTile(
        selected: isSelected,
        dense: true,
        visualDensity: VisualDensity(vertical: -1),
        title: Text(
          item.title!,
          style: TextStyle(
              fontSize: 14,
              color: isSelected ? offWhite : onPrimaryFixed),
        )),
  );
}
