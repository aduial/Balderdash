import 'dart:convert';
import 'dart:io';

import 'package:balderdash/model/template.dart';
import 'package:balderdash/model/vocabulary.dart';
import 'package:date_format/date_format.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/colours.dart';
import '../config/config.dart';
import '../database_helper/database_helper.dart';
import '../model/project.dart';
import '../screens/template_detail.dart';

class ImExport extends StatefulWidget {
  const ImExport({super.key});

  @override
  State<ImExport> createState() => _ImExportState();
  static final navigatorKey = GlobalKey<NavigatorState>();
}

class _ImExportState extends State<ImExport> {
  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  final _settingsFormKey = GlobalKey<FormState>();
  late Future<List<Project>> _projects;
  // late int projectId = 1;
  late Project curProject;
  late List<Vocabulary> _projectVocabularies;
  late List<Template> _projectTemplates;
  bool initComplete = false;

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _dialogTitleController = TextEditingController();
  final _defaultFileNameController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  final _newTitleController = TextEditingController();
  String? _extension;
  final bool _lockParentWindow = false;
  String _fileContent = '';
  bool _isLoading = false;
  bool _userAborted = false;
  List<PlatformFile>? pickedFiles;
  // late String directoryPath;
  late final ByteData fileBytes;
  late String importedPath;
  late int newProjectId;
  bool mergeLibrary = false;
  bool initialised = false;

  String impTitle = '';

  List<String> lines = [];

  StringBuffer importPrjVoc = StringBuffer();
  StringBuffer importLibVoc = StringBuffer();
  StringBuffer importTemplates = StringBuffer();

  @override
  void initState() {
    initComplete = false;
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    _projects = DatabaseHelper().getProjectsAbove(0);
    initComplete = true;
  }

  Future<void> saveAsNonsense() async {
    if (!initialised) {
      if (mounted) {
        await showConfirmationAlertDialog(
          context,
          title: "please select a project",
          message: "",
          text: 'OK',
          highlight: true,
        );
      }
    } else {
      await saveDataFile(curProject.id!)
          .then((_) => saveDataFile(1))
          .then((_) => saveTemplateFiles())
          .then((_) => saveNonsense());
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: cyanAppbarColour,
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 1200),
            content: Text(
              "'${curProject.title}' saved in Nonsense format",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18 * scaling,
              ),
            ),
            dismissDirection: DismissDirection.up),
      );
    }
  }

  Future<void> saveDataFile(int projectId) async {
    StringBuffer sbd = StringBuffer();
    _projectVocabularies =
        await DatabaseHelper().getVocabulariesByProject(projectId);
    for (Vocabulary voc in _projectVocabularies) {
      sbd.write(voc.title?.toUpperCase());
      sbd.write("\n");
      sbd.write(voc.content);
      sbd.write("\n\n");
    }
    _fileContent = sbd.toString();
    _dialogTitleController.text = projectId == 1
        ? 'save library as .data file'
        : 'save project as .data file';
    _extension = 'data';
    _defaultFileNameController.text =
        projectId == 1 ? 'default.data' : "${curProject.title!}.${_extension!}";
    await _saveFile();
  }

  Future<void> saveTemplateFiles() async {
    _projectTemplates =
        await DatabaseHelper().getTemplatesByProject(curProject.id!);
    if (_projectTemplates.isNotEmpty) {
      for (Template tpl in _projectTemplates) {
        String tplType = tpl.isHtml == 1
            ? htmlContent.toLowerCase()
            : rdfContent.toLowerCase();
        _fileContent = tpl.content ?? '';
        _dialogTitleController.text = 'save $tplType template';
        _extension = 'template';
        _defaultFileNameController.text =
            "${curProject.title!}.$tplType.$_extension";
        await _saveFile();
      }
    }
  }

  saveNonsense() async {
    ByteData assetBytes = await rootBundle.load("assets/nonsense.zip");
    final buffer = assetBytes.buffer;
    var list =
        buffer.asUint8List(assetBytes.offsetInBytes, assetBytes.lengthInBytes);
    _fileContent = utf8.decode(list);
    _dialogTitleController.text = 'export Nonsense.pl & documentation';
    _extension = 'zip';
    _defaultFileNameController.text = 'nonsense.$_extension';
    await _saveFile();
  }

  Future<void> exportProject() async {
    if (!initialised) {
      if (mounted) {
        await showConfirmationAlertDialog(
          context,
          title: "please select a project",
          message: "",
          text: 'OK',
          highlight: true,
        );
      }
    } else {
      StringBuffer sb = StringBuffer();
      sb.writeln(curProject.dump());
      sb.writeln(pvocMark);
      sb.write(await createVocabularyInserts(curProject.id!));
      sb.writeln(lvocMark);
      sb.write(await createVocabularyInserts(1));
      if (await DatabaseHelper().anyTemplatesForProject(curProject.id!)) {
        sb.writeln(tmplMark);
        sb.write(await createTemplateInserts(curProject.id!));
      }

      _fileContent = sb.toString();
      _dialogTitleController.text = 'export project as .bdd file';
      _extension = 'bdd';
      String fileNameTitle =
          curProject.title!.toLowerCase().replaceAll(' ', '_');
      _defaultFileNameController.text = "$fileNameTitle.$_extension";
      await _saveFile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: cyanAppbarColour,
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 1200),
              content: Text(
                "project '${curProject.title}' exported",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18 * scaling,
                ),
              ),
              dismissDirection: DismissDirection.up),
        );
      }
    }
  }

  Future<String> createVocabularyInserts(int projectId) async {
    List<Vocabulary> vocs =
        await DatabaseHelper().getVocabulariesByProject(projectId);
    StringBuffer sbv = StringBuffer();
    for (Vocabulary voc in vocs) {
      sbv.writeln(voc.dump());
    }
    return sbv.toString();
  }

  Future<String> createTemplateInserts(int projectId) async {
    List<Template> tpls =
        await DatabaseHelper().getTemplatesByProject(projectId);
    StringBuffer sbt = StringBuffer();
    for (Template tpl in tpls) {
      sbt.writeln(tpl.dump());
    }
    return sbt.toString();
  }

  Future<void> _saveFile() async {
    String? pickedSaveFilePath;
    bool hasUserAborted = true;
    _resetState();

    try {
      final Uint8List fileData = Uint8List.fromList(_fileContent.codeUnits);
      pickedSaveFilePath = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: FileType.custom,
        dialogTitle: _dialogTitleController.text,
        fileName: _defaultFileNameController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
        bytes: fileData,
      );
      hasUserAborted = pickedSaveFilePath == null;
    } on PlatformException catch (e) {
      _logException('Unsupported operation: $e');
    } catch (e) {
      _logException(e.toString());
    }
  }

  void _resetState() {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _userAborted = false;
    });
  }

  void _logException(String message) {
    printInDebug(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> importProject() async {
    int nrPVocs = 0;
    int nrLVocs = 0;
    int nrTmpls = 0;
    File importedFile;
    String fileContent;

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);
    if (result != null) {
      importedFile = File(result.files.first.path!);
      importedPath = importedFile.path;
      fileContent = String.fromCharCodes(importedFile.readAsBytesSync());
    } else {
      return;
    }

    LineSplitter ls = LineSplitter();
    lines = ls.convert(fileContent);
    int userChoice = 1;

    // 2§1§2§2§1§3§Medigoed§4§
    RegExp prjMatch = RegExp(r'^\d+§1§\d+§2§\d+§3§(\w+)§4§\w+');
    if (lines[0].contains(prjMatch)) {
      // retrieve title
      impTitle = prjMatch.firstMatch(lines[0])?.group(1) ?? '';
      // remove project line
      lines.removeAt(0);
      // await user choice
      userChoice = await upsertProject();
    } else {
      // nothing to do
      throw NoProjectDataFoundException();
    }
    // Project is now created, or existing will be replaced / merged
    if (userChoice > 1) {
      if (lines[0].contains(pvocMark)) {
        print("start project vocs");
        // remove pvocMark
        lines.removeAt(0);
        // if user chose to overwrite: delete existing project vocabularies
        if (userChoice == 3) {
          print("`Choice 3: delete vocabularies for project $newProjectId");
          DatabaseHelper().deleteProjectVocabularies(newProjectId);
        }
        // choice 2 = new prj, 3 = emptied prj, 4 = merge vocs
        nrPVocs = await insertVocs(true, true);
      } else {
        // this ain't right
        throw NoVocabularyDataFoundException();
      }
      if (lines[0].contains(lvocMark)) {
        print("start library vocs");
        // library section, remove lvocMark
        lines.removeAt(0);
        if (mounted) {
          mergeLibrary = await showConfirmationChoiceDialog(
            context,
            title: "Merge imported Library with existing?",
            message:
                "Merging will overwrite existing Library vocabularies with those from the "
                "import. You can choose to Cancel this, but that may cause the imported project "
                "to fail. You cannot undo a merge!",
            positiveText: 'Merge',
            negativeText: 'Cancel',
            highlightPositive: true,
          );
        }
        nrLVocs = await insertVocs(false, mergeLibrary);
        if (!mergeLibrary) {
          if (mounted) {
            await showConfirmationAlertDialog(
              context,
              title: "Library vocabularies will NOT be imported",
              message:
                  "This may break the imported project. If you change your mind, "
                  "import the project again, choose to overwrite, and then accept to "
                  "merge the library.",
              text: 'OK',
              highlight: true,
            );
          }
        }
      } else {
        // this ain't right either
        throw NoLibraryDataFoundException();
      }
      // anything left?
      if (lines.isNotEmpty && lines[0].contains(tmplMark)) {
        print("start templates");
        // template section, remove tmplMark
        lines.removeAt(0);
        nrTmpls = await insertTmpl();
      }
    }
    StringBuffer sb = StringBuffer();
    sb.write("Imported project '$impTitle' with $nrPVocs vocabularies");
    if (nrTmpls > 0) {
      sb.write(" and $nrTmpls template");
    }
    if (nrTmpls > 1) {
      sb.write("s");
    }
    if (nrLVocs > 0) {
      sb.write("; merged $nrLVocs library vocabularies from the import file.");
    }
    if (mounted) {
      await showConfirmationAlertDialog(
        context,
        title: "Import finished",
        message: sb.toString(),
        text: 'OK',
        highlight: true,
      );
    }
  }

  Future<int> upsertProject() async {
    int importAction = 1;
    String prjNotes = '';
    Project? prj =
        await DatabaseHelper().getProjectByTitle(impTitle.toLowerCase());
    if (prj == null) {
      // no existing project with that title. createProject sets newProjectId
      createProject(impTitle, prjNotes);
      // treat as renamed
      return 2;
    } else {
      // project with that title exists. First we set newProjectId = existing projectId;
      // this will be replaced further down if a new project is created
      newProjectId = prj.id ?? 0;
      prjNotes = prj.notes ?? '';

      if (mounted) {
        importAction = await showImportActionDialog(
          context,
          title: "Project $impTitle exists",
          message:
              "A Project $impTitle already exists. You can: cancel the import; rename the "
              "imported project; replace it (deleting all existing '$impTitle' vocabularies) "
              "or merge the imported project into the existing one, replacing "
              "existing vocabularies with the same name:",
          cancelText: 'Cancel',
          renameText: 'Rename imported',
          replaceText: 'Replace existing',
          mergeText: 'Merge projects',
          highlightCancel: false,
          highlightRename: false,
          highlightReplace: true,
          highlightMerge: true,
        );
      }
      if (importAction == 1) {
        // abort, do nothing
        return 1;
      } else if (importAction == 2) {
        int i = 0;
        do {
          if (mounted) {
            impTitle = await _showTextInputDialog(context, impTitle, i) ??
                'nothing_chosen_abort';
          }
          i++;
        } while (
            await DatabaseHelper().getProjectByTitle(impTitle.toLowerCase()) !=
                null);
        if (impTitle == 'nothing_chosen_abort') {
          return 1;
        }
        // sets newProjectId
        print("create new project $impTitle ");
        newProjectId = await createProject(impTitle, prjNotes);
        print("nieuwnieuwnieuw: $newProjectId");
        return 2;
      } else if (importAction == 3) {
        bool isReplace = false;
        if (mounted) {
          isReplace = await showConfirmationChoiceDialog(
            context,
            title: "Replace content of '$impTitle?'",
            message:
                "This replaces all current vocabularies of '$impTitle'! You cannot undo this!",
            positiveText: 'Replace',
            negativeText: 'Cancel',
            highlightPositive: true,
          );
        }
        if (isReplace) {
          // don't create new project, but delete and replace vocs
          return 3;
        }
        // rather not, after all
        return 1;
      } else if (importAction == 4) {
        bool isMerge = false;
        if (mounted) {
          isMerge = await showConfirmationChoiceDialog(
            context,
            title: "Overwrite Vocabularies for '$impTitle?'",
            message:
                "This will overwrite Vocabularies for '$impTitle' with the same "
                "name as imported ones. You cannot undo this!",
            positiveText: 'Merge',
            negativeText: 'Cancel',
            highlightPositive: true,
          );
        }
        if (isMerge) {
          return 4;
        }
      }
      // Aaargh, can't decide
      return 1;
    }
  }

  Future<int> createProject(String title, String existingNotes) async {
    String newNotes = "Imported from file $importedPath on ${nowString()}";
    String notes = '';
    if (existingNotes.isNotEmpty) {
      notes = "$existingNotes | $newNotes";
    } else {
      notes = newNotes;
    }
    print("create project $title");
    return await DatabaseHelper().insertAndGetId(
        "INSERT INTO project (typeId, authorId, title, notes) VALUES (2, 3, '$title', '$notes');");
  }

  String nowString() {
    return formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }

  Future<int> insertVocs(bool arePrjVocs, bool doInsert) async {
    List<String> insertLines = [];
    StringBuffer sb = StringBuffer();
    RegExp clauseStart = RegExp(r'^\d+§1§');
    String sectionMark = arePrjVocs == true ? lvocMark : tmplMark;
    int pid = arePrjVocs == true ? newProjectId : 1;
    int until = 1;
    for (int i = 0; i < lines.length; i++) {
      sb.writeln(lines[i]);
      if (i == (lines.length - 1) || lines[i + 1].startsWith(clauseStart)) {
        insertLines.add(sb.toString());
        sb.clear();
      }
      if (lines[i + 1].contains(sectionMark)) {
        insertLines.add(sb.toString());
        sb.clear();
        until = i + 1;
        break;
      }
    }
    lines.removeRange(0, until);
    if (doInsert) {
      print("insert ${insertLines.length} vocs project $pid");
      for (String dump in insertLines) {
        await DatabaseHelper().upsertVocabulary(Vocabulary.fromDump(dump, pid));
      }
      return insertLines.length;
    } else {
      return 0;
    }
  }

  Future<int> insertTmpl() async {
    List<String> insertLines = [];
    StringBuffer sb = StringBuffer();
    RegExp clauseStart = RegExp(r'^\d+§1§');
    for (int i = 0; i < lines.length; i++) {
      sb.writeln(lines[i]);
      if (i == (lines.length - 1) || lines[i + 1].startsWith(clauseStart)) {
        insertLines.add(sb.toString());
        sb.clear();
      }
    }
    print("insert ${insertLines.length} templated project $newProjectId");
    for (String dump in insertLines) {
      await DatabaseHelper()
          .upsertTemplate(Template.fromDump(dump, newProjectId));
    }
    return insertLines.length;
  }

  void printInDebug(Object object) => debugPrint(object.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: greenNotePaperColour,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Export & Import projects",
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
            key: _settingsFormKey,
            child: ListView(padding: EdgeInsets.all(4 * scaling), children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownSearch<Project>(
                      key: _prjDDKey,
                      itemAsString: (item) => item.title!,
                      items: (filter, t) => _projects,
                      onSelected: (Project? item) {
                        setState(() {
                          if (item != null) {
                            initialised = true;
                            curProject = item;
                          }
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
                  SizedBox(
                    height: 16 * scaling,
                    width: 8 * scaling,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        iconColor: cyanAppbarColour,
                        shadowColor: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          initialised = false;
                          _prjDDKey.currentState?.clear();
                        });
                      },
                      child: Text("Clear"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    8 * scaling, 4 * scaling, 8 * scaling, 4 * scaling),
              ),
              Row(children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: cyanAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        saveAsNonsense();
                      });
                    },
                    child: Text("save for Nonsense"),
                  ),
                ),
                SizedBox(
                  height: 16 * scaling,
                  width: 8 * scaling,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: cyanAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        exportProject();
                      });
                    },
                    child: Text("export .bdd"),
                  ),
                ),
              ]),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    8 * scaling, 4 * scaling, 8 * scaling, 4 * scaling),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: darkerBlueGrey),
                  borderRadius: BorderRadius.circular(10 * scaling),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [notepaperWhite, notepaperWhite],
                  ),
                ),
                padding: EdgeInsets.all(7),
                child: Text(
                    "'save for Nonsense' saves selected Project + Library as .data files, "
                    "templates (if any) & nonsense.zip (nonsense.pl + documentation) that "
                    "can be deployed on a web server or run as a command-line Perl application.\n\n"
                    "'export .bdd' exports project + library in a single project.bdd file that "
                    "can be shared with other Balderdash! users."),
              ),
              Divider(
                  height: 20 * scaling,
                  thickness: 1 * scaling,
                  indent: 8 * scaling,
                  endIndent: 8 * scaling,
                  color: blueGrey),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: darkerBlueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [notepaperWhite, notepaperWhite],
                  ),
                ),
                padding: EdgeInsets.all(7 * scaling),
                child: Text(
                    "Import a project: tap 'import .bdd', find the project.bdd "
                    "file and open. If there's an existing project with the same name "
                    "you'll be prompted to rename the new project, overwrite the existing "
                    "one or merge the two projects. Library vocabularies in the import "
                    "can be merged into your existing library. "),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    8 * scaling, 8 * scaling, 8 * scaling, 8 * scaling),
              ),
              Row(children: [
                SizedBox(
                  height: 16 * scaling,
                  width: 60 * scaling,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: cyanAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        importProject();
                      });
                    },
                    child: Text("import .bdd"),
                  ),
                ),
                SizedBox(
                  height: 16 * scaling,
                  width: 60 * scaling,
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Future<String?> _showTextInputDialog(
      BuildContext context, String existingTitle, int i) async {
    // print(i);
    String msg = "Please enter a new title for '$existingTitle':";
    if (i > 0 && i < 4) {
      msg = "'$existingTitle' also exists, try again:";
    } else if (i >= 4) {
      msg = "Maybe you should look at the list of Projects first?";
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
            content: TextField(
              controller: _newTitleController,
              decoration:
                  const InputDecoration(hintText: "Enter a unique title:"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("CANCEL"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () =>
                    Navigator.pop(context, _newTitleController.text),
              ),
            ],
          );
        });
  }
}

extension IterableReplaceWhere<E> on List<E> {
  Iterable<E> replaceWhere(bool Function(E) test, E Function(E) replace) =>
      map((e) => test(e) ? replace(e) : e);
  Iterable<E> replaceWhereNot(bool Function(E) test, E Function(E) replace) =>
      map((e) => test(e) ? e : replace(e));
}

Future<int> showImportActionDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String cancelText,
  required String renameText,
  required String replaceText,
  required String mergeText,
  bool highlightCancel = false,
  bool highlightRename = false,
  bool highlightReplace = false,
  bool highlightMerge = false,
}) async {
  return await showDialog<int>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 1),
                child: Text(cancelText.toUpperCase(),
                    style: highlightCancel
                        ? const TextStyle(color: Colors.red)
                        : const TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 2),
                child: Text(renameText.toUpperCase(),
                    style: highlightRename
                        ? const TextStyle(color: Colors.red)
                        : const TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 3),
                child: Text(replaceText.toUpperCase(),
                    style: highlightReplace
                        ? const TextStyle(color: Colors.red)
                        : const TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 4),
                child: Text(mergeText.toUpperCase(),
                    style: highlightMerge
                        ? const TextStyle(color: Colors.red)
                        : const TextStyle(color: Colors.green)),
              ),
            ],
          );
        },
      ) ??
      1;
}

Future<bool> showConfirmationChoiceDialog(
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

Future<void> showConfirmationAlertDialog(
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

class NoProjectDataFoundException implements Exception {
  @override
  String toString() => 'The import does not contain project data.';
}

class NoVocabularyDataFoundException implements Exception {
  @override
  String toString() =>
      'The import does not contain Vocabulary data where expected.';
}

class NoLibraryDataFoundException implements Exception {
  @override
  String toString() => 'The import does not contain library data as expected.';
}
