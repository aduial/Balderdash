import 'package:balderdash/config/balderdash_theme_colours.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/language/balderdash_template.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/model/template.dart';
import 'package:balderdash/views/template_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:widgets_easier/widgets_easier.dart';

class TemplateDetail extends StatefulWidget {
  final TemplateView templateView;
  const TemplateDetail({super.key, required this.templateView});
  @override
  State<TemplateDetail> createState() => _TemplateDetailState();
}

class _TemplateDetailState extends State<TemplateDetail> {
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  final _templateFormKey = GlobalKey<FormState>();
  late DatabaseHelper dbHelper;
  late Future<List<Project>> _projects;
  late List<TemplateView> tvList;
  final TextEditingController titleController = TextEditingController(text: '');
  final contentController = CodeController();
  final TextEditingController notesController = TextEditingController(text: '');

  bool tvListFetched = false;
  bool isExistingTV = false;
  late String contentType;

  late Template newTemplate;
  late int newProjectId;
  late int newIsHtml;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshLists();
    isExistingTV = (null != widget.templateView.id);
    if (isExistingTV) {
      newProjectId = widget.templateView.projectId!;
      dbHelper
          .getProject(newProjectId)
          .then((prj) => _prjDDKey.currentState?.changeSelectedItem(prj));
    }
    titleController.text = widget.templateView.title!;
    contentController.language = balderdashTemplate;
    contentController.text = widget.templateView.content!;
    newIsHtml = widget.templateView.isHtml!;
    contentType = widget.templateView.isHtml == 0 ? rdfContent : htmlContent;
    notesController.text =
        widget.templateView.notes == "" ? " " : widget.templateView.notes ?? '';
  }

  void _refreshLists() {
    setState(() {
      _projects = dbHelper.getProjects();
    });
  }

  setUpdatedProject(int projectId) {
    newProjectId = projectId;
  }

  onTitleChanged(String title) async {
    if (!tvListFetched) {
      tvList = await dbHelper.getTemplateViews();
      tvListFetched = true;
    }
  }

  onIsHtmlChanged(int isHtml) async {
    newIsHtml = isHtml;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: violetNotePaperColour,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Edit ${widget.templateView.title!}",
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
          padding: EdgeInsets.symmetric(
              vertical: 12 * scaling, horizontal: 8 * scaling),
          child: Form(
            key: _templateFormKey,
            child: ListView(padding: EdgeInsets.all(4 * scaling), children: [
              Row(
                children: [
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
                            // labelText: widget.templateView.project,
                            labelStyle: TextStyle(fontSize: 14 * scaling),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10 * scaling),
                            )),
                      ),
                      // selectedItem: currentCategory,
                      compareFn: (item, sItem) => item.title == sItem.title,
                      validator: (item) {
                        if (item == null && !isExistingTV) {
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
                  flex: 4,
                  child: TextFormField(
                    controller: titleController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: offWhite,
                        labelText: 'TEMPLATE TITLE',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * scaling),
                        )),
                    maxLines: 1,
                    onChanged: (value) => onTitleChanged(value),
                    validator: (value) {
                      if (isExistingTV && value == widget.templateView.title) {
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      if (value == newVocabularyTitle) {
                        return "Please change the default new title '$newTemplateTitle'";
                      }
                      List<TemplateView> titleTVList =
                          tvList.where((i) => i.title == value).toList();
                      List<TemplateView> filterTVList = titleTVList
                          .where((j) => j.projectId == newProjectId)
                          .toList();
                      if (filterTVList.isNotEmpty) {
                        return "Template ${filterTVList[0].title!} already exist in project '${filterTVList[0].project!}'";
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(newIsHtml == 0 ? rdfContent : htmlContent),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Switch(
                    value: newIsHtml == 1,
                    activeColor: greenNotePaperColour,
                    activeTrackColor: greenAppbarColour,
                    onChanged: (bool value) {
                      setState(() {
                        onIsHtmlChanged(value ? 1 : 0);
                      });
                    },
                  ),
                ),
              ]),
              Padding(padding: EdgeInsets.all(6)),
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
              Row(children: [
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
                    maxLines: 1,
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10 * scaling, height: 4 * scaling),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: violetAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () async {
                      if (_templateFormKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: regularResultBGColour,
                              behavior: SnackBarBehavior.fixed,
                              // margin: EdgeInsets.only(bottom: 0.0),
                              content: Text(
                                'Saving template',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18 * scaling,
                                ),
                              ),
                              dismissDirection: DismissDirection.none),
                        );
                        newTemplate = Template.fromMap({
                          "id": widget.templateView.id,
                          "projectId": newProjectId,
                          "title": titleController.text,
                          "content": contentController.text,
                          "notes": notesController.text,
                        });
                        await dbHelper.upsertTemplate(newTemplate);
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
