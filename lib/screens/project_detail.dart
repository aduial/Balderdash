import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/model/author.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/model/type.dart';
import 'package:balderdash/views/project_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ProjectDetail extends StatefulWidget {
  final ProjectView projectView;
  const ProjectDetail({super.key, required this.projectView});
  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  final _typeDDKey = GlobalKey<DropdownSearchState<Type>>();
  final _authDDKey = GlobalKey<DropdownSearchState<Author>>();
  final _projectFormKey = GlobalKey<FormState>();
  late DatabaseHelper dbHelper;
  late Future<List<Type>> _types;
  late Future<List<Author>> _authors;
  late List<ProjectView> pvList;
  final TextEditingController titleController = TextEditingController(text: '');
  // final ScrollController contentScrollController = ScrollController();
  final TextEditingController notesController = TextEditingController(text: '');

  bool pvListFetched = false;
  bool isExistingPV = false;

  late Project newProject;
  late int newId;
  late int newTypeId;
  late int newAuthorId;
  late String newTitle;
  late String newNotes;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshLists();
    isExistingPV = (null != widget.projectView.id);
    if (isExistingPV) {
      newId = widget.projectView.id!;
      newTypeId = widget.projectView.typeId!;
      dbHelper.getType(newTypeId).then(
          (type) => _typeDDKey.currentState?.changeSelectedItem(type as Type?));
      newAuthorId = widget.projectView.authorId!;
      dbHelper.getAuthor(newAuthorId).then((auth) =>
          _authDDKey.currentState?.changeSelectedItem(auth as Author?));
    }
    newTitle = widget.projectView.title ?? "";
    newNotes = widget.projectView.notes ?? "";
  }

  // _catDDKey.currentState.changeSelectedItem(currentCategory)

  void _refreshLists() {
    setState(() {
      _types = dbHelper.getTypes();
      _authors = dbHelper.getAuthors();
    });
  }

  setUpdatedType(int typeId) {
    newTypeId = typeId;
  }

  setUpdatedAuthor(int authorId) {
    newAuthorId = authorId;
  }

  onTitleChanged(String title) async {
    if (!pvListFetched) {
      pvList = await dbHelper.getProjectViews();
      pvListFetched = true;
    }
    newTitle = title;
  }

  onNotesChanged(String notes) async {
    if (!pvListFetched) {
      pvList = await dbHelper.getProjectViews();
      pvListFetched = true;
    }
    newNotes = notes;
  }

  initialisePvList() async {
    if (!pvListFetched) {
      pvList = await dbHelper.getProjectViews();
      pvListFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = newTitle;
    notesController.text = newNotes;
    initialisePvList();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: orangeNotePaperColour,
        ),
        backgroundColor: inActiveLargeSetColour,
        title: Text(
          "Edit ${widget.projectView.title!}",
          style: TextStyle(color: notepaperWhite),
        ),
      ),
      backgroundColor: orangeNotePaperColour,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [notepaperWhite, lightBlueGrey],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 12 * scaling, horizontal: 8 * scaling),
          child: Form(
            key: _projectFormKey,
            child: ListView(padding: EdgeInsets.all(4 * scaling), children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<Type>(
                      key: _typeDDKey,
                      itemAsString: (item) => item.name!,
                      items: (filter, t) => _types,
                      onSelected: (Type? item) {
                        setState(() {
                          setUpdatedType(item!.id!);
                        });
                      },
                      // onSelected: (item) {
                      //   setUpdatedCategory(item!);
                      // },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: offWhite,
                            labelText: 'TYPE',
                            // labelText: widget.projectView.category,
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
                            )),
                      ),
                      compareFn: (item, sItem) => item.id == sItem.id,
                      validator: (item) {
                        if (item == null && !isExistingPV) {
                          return 'please select a Type';
                        }
                        return null;
                      },
                      popupProps: PopupProps.modalBottomSheet(
                          showSelectedItems: true,
                          showSearchBox: false,
                          itemBuilder: typeModalItem),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4 * scaling)),
                  Expanded(
                    child: DropdownSearch<Author>(
                      key: _authDDKey,
                      itemAsString: (item) => item.name!,
                      items: (filter, t) => _authors,
                      onSelected: (Author? item) {
                        setState(() {
                          setUpdatedAuthor(item!.id!);
                        });
                      },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            filled: true,
                            fillColor: offWhite,
                            labelText: 'AUTHOR',
                            // labelText: widget.projectView.project,
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
                            )),
                      ),
                      // selectedItem: currentCategory,
                      compareFn: (item, sItem) => item.name == sItem.name,
                      validator: (item) {
                        if (item == null && !isExistingPV) {
                          return 'please select a Project';
                        }
                        return null;
                      },
                      popupProps: PopupProps.modalBottomSheet(
                          showSelectedItems: true,
                          showSearchBox: false,
                          itemBuilder: authorModalItem),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(8 * scaling)),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: offWhite,
                        labelText: 'PROJECT TITLE',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * scaling),
                        )),
                    maxLines: 1,
                    onChanged: (value) => onTitleChanged(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      if (value == newProjectTitle) {
                        return "Please change the default new title '$newProjectTitle'";
                      }
                      List<ProjectView> titlePVList =
                          pvList.where((i) => i.title == value).toList();
                      if (null == newId && titlePVList.isNotEmpty) {
                        return "Project '${titlePVList[0].title!}' exist, choose another title}'";
                      }
                      return null;
                    },
                  ),
                ),
              ]),
              Padding(padding: EdgeInsets.all(6 * scaling)),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    controller: notesController,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: offWhite,
                        labelText: 'NOTES',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * scaling),
                        )),
                    maxLines: 20,
                    onChanged: (value) => onNotesChanged(value),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0 * scaling),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: orangeAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () async {
                      if (_projectFormKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: regularResultBGColour,
                              behavior: SnackBarBehavior.fixed,
                              // margin: EdgeInsets.only(bottom: 0.0),
                              content: Text(
                                'Saving project',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18 * scaling,
                                ),
                              ),
                              dismissDirection: DismissDirection.none),
                        );
                        newProject = Project.fromMap({
                          "id": widget.projectView.id,
                          "typeId": newTypeId,
                          "authorId": newAuthorId,
                          "title": newTitle,
                          "notes": newNotes,
                        });
                        await dbHelper.upsertProject(newProject);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Icon(
                      Icons.save,
                    ),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

Widget typeModalItem(
    BuildContext context, Type item, bool isDisabled, bool isSelected) {
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

Widget authorModalItem(
    BuildContext context, Author item, bool isDisabled, bool isSelected) {
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
