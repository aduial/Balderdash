import 'package:balderdash/model/vocabulary.dart';
import 'package:balderdash/model/template.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../database_helper/database_helper.dart';
import '../screens/template_detail.dart';
import '../model/project.dart';
import '../config/colours.dart';
import '../config/config.dart';
import 'dart:convert';

class ImExport extends StatefulWidget {
  const ImExport({super.key});

  @override
  State<ImExport> createState() => _ImExportState();
  static final navigatorKey = GlobalKey<NavigatorState>();
}

class _ImExportState extends State<ImExport>{

  final _prjDDKey = GlobalKey<DropdownSearchState<Project>>();
  final _settingsFormKey = GlobalKey<FormState>();
  late DatabaseHelper dbHelper;
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

  StringBuffer importPrjVoc = StringBuffer();
  StringBuffer importLibVoc = StringBuffer();
  StringBuffer importTemplates = StringBuffer();

  @override
  void initState() {
    dbHelper = DatabaseHelper.instance;
    initComplete = false;
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    _projects = dbHelper.getProjectsAbove(1);
    initComplete = true;
  }

  Future<void> saveAsNonsense() async {
    await saveDataFile(curProject.id!).then((_)
    => saveDataFile(1)).then((_)
    => saveTemplateFiles()).then((_)
    => saveNonsenseScript());
  }

  Future<void> saveDataFile(int projectId) async {
    StringBuffer sbd = StringBuffer();
    _projectVocabularies = await dbHelper.getVocabulariesByProject(projectId);
    for (Vocabulary voc in _projectVocabularies){
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
    _defaultFileNameController.text = projectId == 1
        ? 'default.data'
        : "${curProject.title!}.${_extension!}";
    await _saveFile();
  }

  Future<void> saveTemplateFiles() async {
    _projectTemplates = await dbHelper.getTemplatesByProject(curProject.id!);
    if (_projectTemplates.isNotEmpty){
      for (Template tpl in _projectTemplates){
        String tplType = tpl.isHtml == 1
          ? htmlContent.toLowerCase()
          : rdfContent.toLowerCase();
        _fileContent = tpl.content ?? '';
        _dialogTitleController.text = 'save $tplType template';
        _extension = 'template';
        _defaultFileNameController.text = "${curProject.title!}.$tplType.$_extension";
        await _saveFile();
      }
    }
  }

  saveNonsenseScript() async {
    ByteData assetBytes = await rootBundle.load("assets/nonsense.pl");
    final buffer = assetBytes.buffer;
    var list = buffer.asUint8List(assetBytes.offsetInBytes, assetBytes.lengthInBytes);
    _fileContent = utf8.decode(list);
    _dialogTitleController.text = 'export Nonsense Perl script';
    _extension = 'pl';
    _defaultFileNameController.text = 'nonsense.$_extension';
    await _saveFile();
  }

  Future<void> exportProject() async {
    StringBuffer sb = StringBuffer();
    sb.write(createProjectInsert());
    sb.write(await createVocabularyInserts(curProject.id!));
    sb.write(await createVocabularyInserts(1));
    sb.write(await createTemplateInserts(curProject.id!));
    _fileContent = sb.toString();
    _dialogTitleController.text = 'export project as .sql file';
    _extension = 'sql';
    String fileNameTitle = curProject.title!.toLowerCase().replaceAll(' ', '_');
    _defaultFileNameController.text = "$fileNameTitle.$_extension";
    await _saveFile();
  }

  String createProjectInsert() {
    return "$prjInsertInto(0, 0, '${curProject.title}', '${curProject.notes}');\n\n";
  }

  Future<String> createVocabularyInserts(int projectId) async {
    List<Vocabulary> vocs = await dbHelper.getVocabulariesByProject(projectId);
    if (projectId > 1){
      projectId = 0;
    }
    StringBuffer sbv = StringBuffer();
    sbv.writeln(vocInsertInto);
    final length = vocs.length;
    int i = 0;
    for (Vocabulary voc in vocs) {
      i++;
      sbv.write("($projectId, ${voc.categoryId}, '${voc.title}', '${voc.content}', '${voc.comment}', ${voc.useThis})");
      if(i == length){
        sbv.write(";\n\n");
      } else {
        sbv.write(",\n");
      }
    }
    return sbv.toString();
  }

  Future<String> createTemplateInserts(int projectId) async {
    List<Template> tpls = await dbHelper.getTemplatesByProject(projectId);
    StringBuffer sbt = StringBuffer();
    sbt.writeln(tplInsertInto);
    final length = tpls.length;
    int i = 0;
    for (Template tpl in tpls) {
      i++;
      sbt.write("(0, '${tpl.title}', '${tpl.content}', ${tpl.isHtml}, '${tpl.notes}')");
      if(i == length){
        sbt.write(";\n\n");
      } else {
        sbt.write(",\n");
      }
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
    File importedFile;
    String fileContent;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, withData: true);
    if (result != null) {
      importedFile = File(result.files.first.path!);
      importedPath = importedFile.path;
      fileContent = String.fromCharCodes(importedFile.readAsBytesSync());
    } else {
      return;
    }

    LineSplitter ls = LineSplitter();
    List<String> lines = ls.convert(fileContent);

    if (lines[0].contains("INSERT INTO project")){
      await upsertProject(lines[0]);
      lines.removeAt(0);
    } else {
      throw NoProjectDataFoundException();
    }
    if (lines[0].contains("INSERT INTO vocabulary")){
      lines = assembleVocInserts(lines);
    } else {
      throw NoVocabularyDataFoundException();
    }
    if (lines[0].contains("INSERT INTO vocabulary")){
      lines = assembleLibraryInserts(lines);
    } else {
      throw NoLibraryDataFoundException();
    }
    if (lines.isNotEmpty){
      assembleTemplateInserts(lines);
    }
    print('done');
  }

  List<String> assembleVocInserts(List<String> lines){
    importPrjVoc.clear();
    importPrjVoc.writeln(lines[0]);
    lines.removeAt(0);
    final int until = lines.indexWhere((line) => line.startsWith('INSERT INTO vocabulary'));
    importPrjVoc.writeAll(lines.sublist(0, until), "\n");
    lines.removeRange(0, until);
    return lines;
  }

  List<String> assembleLibraryInserts(List<String> lines){
    importLibVoc.clear();
    importLibVoc.writeln(lines[0]);
    lines.removeAt(0);
    final int until = lines.indexWhere((line) => line.startsWith('INSERT INTO template'));
    if (until > 1){
      importLibVoc.writeAll(lines.sublist(0, until), "\n");
      lines.removeRange(0, until);
    } else {
      importLibVoc.writeAll(lines, "\n");
      lines.clear();
    }
    return lines;
  }

  void assembleTemplateInserts(List<String> lines){
    importTemplates.clear();
    importTemplates.writeAll(lines, "\n");
  }

  Future<void> upsertProject(String sql) async {
    //0, 0, 'Medigoed', 'null');
    int importAction = 1;
    RegExp pTitle = RegExp(r"0, '([a-zA-Z0-9\s_]+)");
    var title = pTitle.firstMatch(sql)?.group(1) ?? '';

    Project? prj = await dbHelper.getProjectByTitle(title.toLowerCase());

    if (prj != null) {
      importAction = await showImportActionDialog(
        context,
        title: "Project $title exists",
        message: "A Project $title already exists. You can: cancel the import, rename the "
            "imported project, replace it (and delete all existing '$title' vocabularies), "
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

      if (importAction == 1) {
        // abort
        return;
      } else if (importAction == 2) {
        int i = 0;
        do {
          title = await _showTextInputDialog(context, title, i) ?? 'nothing_chosen_abort';
          i++;
        } while (await dbHelper.getProjectByTitle(title.toLowerCase()) != null);
        if (title == 'nothing_chosen_abort'){
          // cancelled
          print("aborted import of $title");
        } else {
          createProject(title);
        }

      } else if (importAction == 3) {
        // await dbHelper.deleteTemplate(templateView);
        final bool isReplace = await showConfirmationAlertDialog(
          context,
          title: "Delete existing Project '$title?'",
          message: "This deletes '$title' and all its Vocabularies. You cannot undo this!" ,
          positiveText: 'Delete',
          negativeText: 'Cancel',
          highlightPositive: true,
        );
        if (isReplace){
          // go on delete then create
        }
      } else if (importAction == 4) {

        final bool isMerge = await showConfirmationAlertDialog(
          context,
          title: "Overwrite Vocabularies for '$title?'",
          message: "This will overwrite existing Vocabularies for '$title' with the same "
              "name as newly imported ones. You cannot undo this!" ,
          positiveText: 'Delete',
          negativeText: 'Cancel',
          highlightPositive: true,
        );
        if (isMerge){
          // go on with voc merge
        }
      }
    } else {
      // project doesn't exist yet
      createProject(title);
    }
  }

  void createProject(String title){
    String notes = "Imported from file $importedPath on ${nowString()}";
    dbHelper.executeQuery("INSERT INTO project (typeId, authorId, title, notes) VALUES (2, 3, '$title', '$notes');");
  }

  String nowString(){
    return formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }

  void printInDebug(Object object) => debugPrint(object.toString());

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double deviceScaling = refHeight / displayHeight;
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
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Form(
            key: _settingsFormKey,
            child: ListView(padding: EdgeInsets.all(4),
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex:3,
                        child: DropdownSearch<Project>(
                          key: _prjDDKey,
                          itemAsString: (item) => item.title!,
                          items: (filter, t) => _projects,
                          onSelected: (Project? item) {
                            setState(() {
                              curProject = item!;
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
                            if (item == null ) {
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
                        height: 16 ,
                        width: 8,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            iconColor: cyanAppbarColour,
                            shadowColor: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _prjDDKey.currentState?.clear();
                            });
                          },
                          child: Text("Clear"),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: const EdgeInsetsDirectional.fromSTEB(
                      8, 4, 8, 4),
                  ),
                  Row(
                      children: [
                        Expanded(
                          flex:2,
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
                            child: Text("pack for Nonsense"),
                          ),
                        ),
                        SizedBox(
                          height: 16 ,
                          width: 8,
                        ),
                        Expanded(
                          flex:1,
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
                            child: Text("export"),
                          ),
                        ),
                      ]
                  ),
                  Padding(padding: const EdgeInsetsDirectional.fromSTEB(
                      8, 4, 8, 4),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: darkerBlueGrey
                      ),
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [notepaperWhite, notepaperWhite],
                      ),
                    ),
                    padding: EdgeInsets.all(7),
                    child: Text("Export your project: 'save for Nonsense' saves the selected "
                        "Project as .data files, template files (if any) and a copy of nonsense.pl "
                        "that can be deployed on a web server or run as a command-line Perl "
                        "application. The 'Export' button will save it in a format "
                        "that can be shared with other Balderdash! users." ),
                  ),
                  Padding(padding: const EdgeInsetsDirectional.fromSTEB(
                      8, 8, 8, 8),
                  ),
                  Row(
                      children: [
                        Expanded(
                          flex:2,
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
                            child: Text("import"),
                          ),
                        ),
                        SizedBox(
                          height: 16 ,
                          width: 8,
                        ),
                        Expanded(
                          flex:1,
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
                            child: Text("--"),
                          ),
                        ),
                      ]
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
  Future<String?> _showTextInputDialog(BuildContext context, String existingTitle, int i) async {
    // print(i);
    String msg = "Please enter a new title for '$existingTitle':";
      if (i > 0 && i < 4){
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
              decoration: const InputDecoration(hintText: "Enter a unique title:"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("CANCEL"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context, _newTitleController.text),
              ),
            ],
          );
        });
  }
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
              child: Text(
              cancelText.toUpperCase(),
              style: highlightCancel
                ? const TextStyle(
                    color: Colors.red)
                  : const TextStyle(
                  color: Colors.green)
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 2),
              child: Text(
                renameText.toUpperCase(),
                style: highlightRename
                    ? const TextStyle(
                    color: Colors.red)
                    : const TextStyle(
                    color: Colors.green)
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 3),
              child: Text(
                replaceText.toUpperCase(),
                style: highlightReplace
                    ? const TextStyle(
                    color: Colors.red)
                    : const TextStyle(
                    color: Colors.green)
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 4),
              child: Text(
                mergeText.toUpperCase(),
                style: highlightMerge
                    ? const TextStyle(
                    color: Colors.red)
                    : const TextStyle(
                    color: Colors.green)
              ),
            ),
          ],
        );
      },
  ) ?? 1;
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
            child: Text(
              negativeText.toUpperCase(),
              style: highlightNegative
                  ? const TextStyle(
                  color: Colors.red)
                  : const TextStyle(
                  color: Colors.green)
            ),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text(
              positiveText.toUpperCase(),
              style: highlightPositive
                  ? const TextStyle(
                  color: Colors.red)
                  : const TextStyle(
                  color: Colors.green)
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      );
    },
  ) ?? false;
}

class NoProjectDataFoundException implements Exception {
  @override
  String toString() => 'The import does not contain project data.';
}

class NoVocabularyDataFoundException implements Exception {
  @override
  String toString() => 'The import does not contain Vocabulary data where expected.';
}

class NoLibraryDataFoundException implements Exception {
  @override
  String toString() => 'The import does not contain library data as expected.';
}





