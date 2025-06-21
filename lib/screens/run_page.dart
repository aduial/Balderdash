import 'package:flutter/material.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:nonsense/views/vocabulary_view.dart';
import 'package:nonsense/model/vocabulary.dart';
import 'dart:convert';
import 'dart:math';
import 'package:nonsense/widgets/voc_trace.dart';
import 'package:date_format/date_format.dart';

class RunPage extends StatefulWidget {
  final VocabularyView _vocabularyView;
  const RunPage({super.key, required VocabularyView vocabularyView})
      : _vocabularyView = vocabularyView;

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  Map<String, String> stateVariables = {};
  late DatabaseHelper _dbHelper;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController resultController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
  }

  Future<Vocabulary> getVocabulary(String title, int projectId) {
    return _dbHelper.getVocabularyByTitleAndProject(title, projectId);
  }

  Future<void> doThings() async {
    Vocabulary voc = Vocabulary.fromMap({
      "id": widget._vocabularyView.id,
      "categoryId": widget._vocabularyView.categoryId,
      "projectId": widget._vocabularyView.projectId,
      "title": widget._vocabularyView.title,
      "content": widget._vocabularyView.content,
      "comment": widget._vocabularyView.comment,
      "useThis": widget._vocabularyView.useThis,
    });
    VocTrace vc = VocTrace(
        vocabulary: voc,
        line: pickRandomLine(splitVocabulary(voc.content!)));
    resultController.text = await parseVocabulary(vc);
  }

  Future<String> parseVocabulary(VocTrace vcn) async {
    VocTrace vc = vcn;
    return await parseLine(vc);
    // return globalResult.toString();
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
      if (line.isEmpty) {
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
      // line break, { } or null
      vc = parseSpecial(vc);
    } else if (vc.line.contains(RegExp(r'^\{\w*:=\^?\w+(#\d+-\d+)?\}'))) {
      // evaluate command and store as state variable
      vc = await parseStateVariable(vc);
    } else if (vc.line.contains(RegExp(r'^\{\w*=([\w\s\\@()<>%*_";:?!\-+,.])+\}'))) {
      // add literal string as state variable
      vc = parseStateLiteral(vc);
    } else if (vc.line.contains(RegExp(r'^\{\^?\w+(#\d+-\d+)?\}'))) {
      // variable
      vc = await parseVariable(vc);
    } else if (vc.line.contains(RegExp(r'^[\w\s\\@()<>%*_";:?!\-+,.]'))) {
      // literal
      vc = parseLiteral(vc);
    } else if (vc.line.contains(RegExp(r'^\{\$\w*\}'))) {
      // read state variable
      vc = readStateVariable(vc);
    } else if (vc.line.contains(RegExp(r'^\{@(%-?\w\w?\W*)*(\|\d+\|\d+)?\}'))) {
      // {@strftime format|number1|number2}
      vc = insertStrfTime(vc);
    }
    if (vc.line.isNotEmpty) {
      // get to the next part of the line
      return await parseLine(vc);
    } else {
      // end of vc lifecycle, flush child buffer to parent
      return vc.getCasedResult();
    }
  }

  // convert most strftime commands into their equivalent Dart counterpart
  // to ensure backwards compatibility with existing Nonsense grammar files
  VocTrace insertStrfTime(VocTrace vc) {
    final random = Random();
    int begin = 0;
    int end = 0;
    int between = 0;
    if (vc.line.contains(RegExp(r'\|\d+\|\d+'))) {
      int eerste = vc.line.indexOf('|');
      int tweede = vc.line.indexOf('|', eerste + 1);
      int laatste = vc.line.indexOf('}');
      String numberOne = vc.line.substring(eerste + 1, tweede);
      String numberTwo = vc.line.substring(tweede + 1, laatste);
      int nr1 = int.parse(numberOne);
      int nr2 = int.parse(numberTwo);
      int small = min(nr1, nr2);
      int large = max(nr1, nr2) + 1;
      between = small + random.nextInt(large - small);
    }
    DateTime someTimeAgo = DateTime.now().subtract(Duration(seconds: 0 - between));
    begin = vc.line.indexOf('@') + 1;
    if (vc.line.contains('|')){
      end = vc.line.indexOf('|');
    } else {
      end = vc.line.indexOf('}');
    }
    String strfTime = vc.line.substring(begin, end);
    strfTime = strfTime.replaceFirst('%f', '%f%g');
    List<String> strfTokens = strfTime.split('%');
    RegExp azAZ = new RegExp(r'([a-zA-Z]+)');
    RegExp rest = new RegExp(r'([^a-zA-Z]+)');
    List<String> dtFormat = [];
    for (String token in strfTokens){
      if (token.isNotEmpty){
        var key = azAZ.firstMatch(token)?.group(0) ?? '';
        dtFormat.add(strfToDart["%$key"] ?? '');
        var fuzz = rest.firstMatch(token)?.group(0) ?? '';
        if (fuzz.isNotEmpty){
          dtFormat.add(fuzz);
        }
      }
    }
    vc.localResult.write(formatDate(someTimeAgo, dtFormat));
    vc.line = vc.line.substring(vc.line.indexOf('}') + 1);
    return vc;
  }

  VocTrace parseSpecial(VocTrace vc) {
    int start = vc.line.indexOf('{') + 2;
    int end = vc.line.indexOf('}', start + 1);
    switch (vc.line.substring(start, end).toUpperCase()) {
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
    if (anonymous.split("|").length > 1 || random.nextBool()) {
      vc.localResult.write(pickRandomLine(anonymous.split("|")));
    }
    // chop from current line
    vc.line = vc.line.substring(end + 1);
    return vc;
  }

  Future<VocTrace> parseStateVariable (VocTrace vc) async {
    VocTrace vcs = VocTrace(
        vocabulary: vc.vocabulary,
        line: vc.line);
    int start = vcs.line.indexOf('{');
    int end = vcs.line.indexOf(':=', start + 1);
    String key = vcs.line.substring(start + 1, end);
    vcs.line = vcs.line.replaceFirst(RegExp(r'^\{.+?:='), '{');
    VocTrace value = await parseVariable(vcs);
    stateVariables.addAll({key : value.getCasedResult()});
    // chop off from current line
    int endCmd = vc.line.indexOf('}', end);
    vc.line = vc.line.substring(endCmd + 1);
    return vc;
  }

  Future<VocTrace> parseVariable(VocTrace vc) async {
    int repeat = 1;
    String varTitle = '';
    if (vc.line.contains(RegExp(r'^{\^?\w*(#\d+-\d+)}'))) {
      repeat = parseNumberBetween(vc);
      vc.line = vc.line.replaceFirst(RegExp(r'#\d+-\d+'), '');
    }
    int start = vc.line.indexOf('{');
    int end = vc.line.indexOf('}', start + 1);
    varTitle = vc.line.substring(start + 1, end);
    Vocabulary next = await getVocabulary(
        varTitle.replaceFirst('^', '').toUpperCase(),
        widget._vocabularyView.projectId!);
    VocTrace vcn = VocTrace(
        vocabulary: next,
        line: pickRandomLine(splitVocabulary(next.content!)));
    vcn.repeat = repeat;
    vcn.variableName = varTitle;
    vc.localResult.write(await parseVocabulary(vcn));
    // chop off from current line
    vc.line = vc.line.substring(end + 1);
    return vc;
  }

  int parseNumberBetween(VocTrace vc) {
    final random = Random();
    int start = vc.line.indexOf('#');
    int dash = vc.line.indexOf('-');
    int end = vc.line.indexOf('}', start + 1);
    int first = int.parse(vc.line.substring(start + 1, dash));
    int second = int.parse(vc.line.substring(dash + 1, end));
    int large = max(first, second) + 1;
    int small = min(first, second);
    return small + random.nextInt(large - small);
  }


  VocTrace parseStateLiteral (VocTrace vc) {
    int start = vc.line.indexOf('{');
    int equals = vc.line.indexOf('=', start + 1);
    int end = vc.line.indexOf('}');
    String key = vc.line.substring(start + 1, equals);
    String value = vc.line.substring(equals + 1, end);
    stateVariables.addAll({key : value});
    vc.line = vc.line.substring(end + 1);
    return vc;
  }

  VocTrace readStateVariable (VocTrace vc) {
    int start = vc.line.indexOf('{\$') + 2;
    int end = vc.line.indexOf('}', start + 2);
    String key = vc.line.substring(start, end);
    if (stateVariables.containsKey(key)){
      vc.localResult.write(stateVariables[key]);
    } else {
      vc.localResult.write("[variable '$key' not found]");
    }
    vc.line = vc.line.substring(end + 1);
    return vc;
  }

  VocTrace parseLiteral(VocTrace vc) {
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              Expanded(
                flex: 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
              ),
              Padding(padding: EdgeInsets.all(12)),
            ]),
          ),
        ),
      ),
    );
  }
}
