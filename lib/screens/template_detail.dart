import 'package:flutter/material.dart';
import 'package:nonsense/model/project.dart';
import 'package:nonsense/model/template.dart';
import 'package:nonsense/views/template_view.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:nonsense/widgets/content_editor.dart';
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
  final TextEditingController htmlController =
      TextEditingController(text: '');
  // final ScrollController contentScrollController = ScrollController();
  final TextEditingController notesController =
      TextEditingController(text: '');

  bool tvListFetched = false;
  bool isExistingTV = false;

  late Template newTemplate;
  late int newProjectId;
  late String newTitle;
  late String newHtml;
  late String newNotes;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshLists();
    isExistingTV = (null != widget.templateView.id);
    if (isExistingTV) {
      newProjectId = widget.templateView.projectId!;
      dbHelper.getProject(newProjectId).then((prj) => _prjDDKey.currentState?.changeSelectedItem(prj));
    }
    newTitle = widget.templateView.title!;
    newHtml = widget.templateView.html!;
    newNotes =
        widget.templateView.notes == ""
            ? " "
            : widget.templateView.notes!;
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
    newTitle = title;
  }

  onHtmlChanged(String html) async {
    if (!tvListFetched) {
      tvList = await dbHelper.getTemplateViews();
      tvListFetched = true;
    }
    newHtml = html;
  }

  onNotesChanged(String notes) async {
    if (!tvListFetched) {
      tvList = await dbHelper.getTemplateViews();
      tvListFetched = true;
    }
    newNotes = notes;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double deviceScaling = refHeight / displayHeight;
    titleController.text = newTitle;
    htmlController.text = newHtml;
    notesController.text = newNotes;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: notepaperWhite,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Edit ${widget.templateView.title!}",
          style: TextStyle(color: notepaperWhite),
        ),

      ),
      backgroundColor: notepaperWhite,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Form(
          key: _templateFormKey,
          child: ListView(padding: EdgeInsets.all(4),
              children: [
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
                      labelText: 'TEMPLATE TITLE',
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
                      return "Please change the default new title '$newTemplateTitle'";
                    }
                    List<TemplateView> titleTVList =
                        tvList.where((i) => i.title == value).toList();
                    List<TemplateView> filterTVList =
                        titleTVList.where((j) => j.projectId == newProjectId).toList();
                    if (filterTVList.isNotEmpty) {
                      return "Template ${filterTVList[0].title!} already exist in project '${filterTVList[0].project!}'";
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
                  content: widget.templateView.html!,
                  onContentUpdated: (String updatedContent){
                    onHtmlChanged(updatedContent);},
                    isVocabulary: false
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
                  controller: notesController,
                  decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: offWhite,
                      labelText: 'NOTES',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                  maxLines: 1,
                  onChanged: (value) => onNotesChanged(value),
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child:  ElevatedButton(
                  style: const ButtonStyle(
                    iconAlignment: IconAlignment.end,
                  ),
                  onPressed: () async {
                    if (_templateFormKey.currentState!.validate()) {
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
                      newTemplate = Template.fromMap({
                        "id": widget.templateView.id,
                        "projectId": newProjectId,
                        "title": newTitle,
                        "html": newHtml,
                        "notes": newNotes,
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
          ]
          ),
        ),
      ),
    );
  }
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
