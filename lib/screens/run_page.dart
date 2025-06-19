import 'package:flutter/material.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:nonsense/views/vocabulary_view.dart';
import 'package:nonsense/model/vocabulary.dart';
import 'dart:convert';
import 'dart:math';
import 'package:nonsense/widgets/voc_trace.dart';

import '../widgets/voc_trace.dart';

class RunPage extends StatefulWidget {
  final VocabularyView _vocabularyView;
  const RunPage({super.key, required VocabularyView vocabularyView})
      : _vocabularyView = vocabularyView;

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  late DatabaseHelper _dbHelper;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController resultController =
      TextEditingController(text: '');
  StringBuffer globalResult = StringBuffer();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
  }

  Future<Vocabulary> getVocabulary(String title, int projectId) {
    return _dbHelper.getVocabularyByTitleAndProject(title, projectId);
  }

  Future<void> doThings() async {
    globalResult.clear();
    Vocabulary voc = Vocabulary.fromMap({
      "id": widget._vocabularyView.id,
      "categoryId": widget._vocabularyView.categoryId,
      "projectId": widget._vocabularyView.projectId,
      "title": widget._vocabularyView.title,
      "content": widget._vocabularyView.content,
      "comment": widget._vocabularyView.comment,
      "useThis": widget._vocabularyView.useThis,
    });
    resultController.text = await parseVocabulary(voc);
  }

  Future<String> parseVocabulary(Vocabulary voc, [int contentCase = 0]) async {
    VocTrace vc = VocTrace(
      line: pickRandomLine(splitVocabulary(voc.content!)),
        flushResult: (String childResult){
          addToResul(childResult);
        }
    );
    child: ContentEditor(
        content: widget.vocabularyView.content!,
        onContentUpdated: (String updatedContent){
          onContentChanged(updatedContent);},
        isVocabulary: true
    )
    await parseLine(vc);
    return globalResult.toString();
  }

  // copy original Nonsense Perl script behaviour:
  // ignore lines after an empty line (useful for testing)
  List<String> splitVocabulary(String content) {
    List<String> uniqueLines = [];
    List<String> activeLines = [];
    List<String> linesToAdd = [];
    LineSplitter ls = LineSplitter();
    uniqueLines = ls.convert(content);
    for (var line in uniqueLines) {
      if (line.isEmpty){
        break;
      }
      activeLines.add(line);
    }
    for (var line in activeLines) {
      if (line.contains(RegExp(r'^#\d+#'))) {
        linesToAdd.addAll(applyWeighting(line));
      }
    }
    return List.from(activeLines)..addAll(linesToAdd);
  }

  List<String> applyWeighting(String line) {
    List<String> addingLines = [];
    int start = line.indexOf('#');
    int end = line.indexOf('#', start + 1);
    int weight = int.parse(line.substring(start + 1, end));
    for (int i = 1; i <= weight; i++) {
      // add as many copies as the factor specifies
      addingLines.add(line);
    }
    return addingLines;
  }

  String pickRandomLine(List<String> weightedLines) {
    final random = Random();
    return weightedLines[random.nextInt(weightedLines.length)];
  }

  Future<String> parseLine(VocTrace vc) async {
    vc.line = vc.line.replaceAll(RegExp(r'^#\d+#'), '');
    if (vc.line.contains(RegExp(r'^#\d+-\d+}'))) {
      // weighting factor: random nr between two nrs, inclusive
      vc = parseNumberRange(vc);
    } else if (vc.line.startsWith('{[')) {
      // anonymous, pick one and add
      vc = parseAnonymous(vc);
    } else if (vc.line.startsWith('{\\')) {
      // line break
      vc = parseSpecial(vc);
    } else if (vc.line.contains(RegExp(r'^{\^?\w*(#\d+-\d+)?}'))) {
      // variable
      vc = await parseVariable(vc);
    } else if (vc.line.contains(RegExp(r'^[\w\s\\@()<>$%*";:?!\-+,.]'))) {
      // literal
      vc = parseLiteral(vc);
    }
    if (vc.line.isNotEmpty) {
      // get to the next part of the line
      return await parseLine(vc);
    } else {
      // end of vc lifecycle, flush vc buffer to global result
      globalResult.write(vc.localResult.toString());

      return "";
    }
  }

  VocTrace parseSpecial(VocTrace vc) {
    int start = vc.line.indexOf('{') + 2;
    int end = vc.line.indexOf('}', start + 1);
    switch (vc.line.substring(start,end).toUpperCase()) {
      case 'N':
        vc.localResult.write('\n');
      case 'L':
        vc.localResult.write('{');
      case 'R':
        vc.localResult.write('}');
      case '0':
        vc.localResult.write('');
      default:
        vc.localResult.write('');
    }
    vc.localResult.write(vc.line.substring(start + 1, end));
    // chop from current line
    vc.line = vc.line.substring(end + 1);
    return vc;
  }

  VocTrace parseNumberRange(VocTrace vc) {
    int between = parseNumberBetween(vc);
    // add to result
    vc.localResult.write(between.toString());
    int start = vc.line.indexOf('{#');
    int end = vc.line.indexOf('}', start + 2);
    // chop from current line
    vc.line = vc.line.substring(end + 1);
    return vc;
  }

  VocTrace parseAnonymous(VocTrace vc) {
    final random = Random();
    int start = vc.line.indexOf('{[');
    int end = vc.line.indexOf('}', start + 1);
    String anonymous = vc.line.substring(start + 2, end);
    // add to result
    if (anonymous.split("|").length > 1 || random.nextBool()){
      vc.localResult.write(pickRandomLine(anonymous.split("|")));
    }
    // chop from current line
    vc.line = vc.line.substring(end + 1);
    return vc;
  }

  Future<VocTrace> parseVariable(VocTrace vc) async {
    print(vc.line);
;    if (vc.line.contains(RegExp(r'^{\^?\w*(#\d+-\d+)}'))) {
      vc.repeat = parseNumberBetween(vc);
      vc.line = vc.line.replaceFirst(RegExp(r'#\d+-\d+'), '');
    }
    int start = vc.line.indexOf('{');
    int end = vc.line.indexOf('}', start + 1);
    vc.variableName = vc.line.substring(start + 1, end);
    Vocabulary next = await getVocabulary(
        vc.getVariableName().toUpperCase(),
        widget._vocabularyView.projectId!);
    // suspend vc, flush local buffer to global
    globalResult.write(vc.localResult.toString());
    // and clear to store the rest
    vc.localResult.clear();
    // add required nr of copies, the only way I could think of without
    // needing to figure out how to communicate across recursion levels
    for (int i = 1; i <= vc.repeat; i++) {
      await parseVocabulary(next);
    }
    // chop off from current line
    vc.line = vc.line.substring(end + 1);
    return vc;
  }

  int parseNumberBetween(VocTrace vc){
    final random = Random();
    int start = vc.line.indexOf('#');
    int dash = vc.line.indexOf('-');
    int end = vc.line.indexOf('}', start + 1);
    int first = int.parse(vc.line.substring(start + 1, dash));
    int second = int.parse(vc.line.substring(dash + 1, end));
    int large = max(first, second) + 1;
    int small = min(first, second);
    return first + random.nextInt(large - small);
  }

  VocTrace parseLiteral(VocTrace vc){
    int start = vc.line.indexOf(RegExp(r'^'));
    int end = vc.line.indexOf(RegExp(r'$|{'), start + 1);
    // add to result
    vc.localResult.write(vc.line.substring(start, end));
    // chop from line
    vc.line = vc.line.substring(end);
    return vc;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double deviceScaling = refHeight / displayHeight;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: notepaperWhite,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Run ${widget._vocabularyView.title!}",
          style: TextStyle(color: notepaperWhite),
        ),
      ),
      backgroundColor: notepaperWhite,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 128.0,
                    height: 128.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 24.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/shampoo.png',
                    ),
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                        iconAlignment: IconAlignment.end,
                      ),
                      onPressed: () {
                        setState(() {
                          doThings();
                        });
                      },
                      child: const Icon(
                        Icons.cable_rounded,
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.all(6)),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: resultController,
                      decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: offWhite,
                          labelText: '${widget._vocabularyView.title!} result',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
