import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:nonsense/model/vocabulary.dart';
import 'dart:convert';
import 'dart:math';
import 'package:nonsense/database_helper/database_helper.dart';


class VocTrace {

  late final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Vocabulary vocabulary;
  final Function(String) flush;
  int repeat = 1;
  String line = '';
  late String variableName;
  final StringBuffer localResult = StringBuffer();
  VocTrace({
    required this.vocabulary,
    required this.flush,
    required this.repeat
  });

  String get result {
    return localResult.toString();
  }

  Future<Vocabulary> getVocabulary(String title, int projectId) {
    return _dbHelper.getVocabularyByTitleAndProject(title, projectId);
  }

  _onFlush(String result){
    localResult.write(result);
    // return flushLocalResult();
  }

  String flushLocalResult(){
    switch (getVariableCase()) {
      case 1:
        return localResult
            .toString()
            .capitalize;
      case 2:
        return localResult.toString().toLowerCase();
      case 3:
        return localResult.toString().toUpperCase();
      case 4:
        return localResult.toString();
      case 0:
        return localResult.toString();
    }
    return "Error applying case formatting";
  }

  String getVariableName(){
    return variableName.replaceFirst('^', '');
  }

  int getVariableCase() {
    RegExp cap = RegExp(r'^\^');
    RegExp lc = RegExp(r'^[a-z0-9]+$');
    RegExp uc = RegExp(r'^[a-z0-9]+$');
    RegExp mc = RegExp(r'^[a-zA-Z0-9]+$');

    if (cap.hasMatch(variableName)) {
      return 1;
    } else if (lc.hasMatch(variableName)) {
      return 2;
    } else if (uc.hasMatch(variableName)) {
      return 3;
    } else if (mc.hasMatch(variableName)) {
      return 4;
    } else {
      return 0;
    }
  }

  Future<String> parse() async {
    line = pickRandomLine(splitVocabulary(vocabulary.content!));
    await parseLine();
    return flush();
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

  Future<void> parseLine() async {
    line = line.replaceAll(RegExp(r'^#\d+#'), '');
    if (line.contains(RegExp(r'^#\d+-\d+}'))) {
      // weighting factor: random nr between two nrs, inclusive
      parseNumberRange();
    } else if (line.startsWith('{[')) {
      // anonymous, pick one and add
      parseAnonymous();
    } else if (line.startsWith('{\\')) {
      // line break
      parseSpecial();
    } else if (line.contains(RegExp(r'^{\^?\w*(#\d+-\d+)?}'))) {
      // variable
      await parseVariable();
    } else if (line.contains(RegExp(r'^[\w\s\\@()<>$%*";:?!\-+,.]'))) {
      // literal
      parseLiteral();
    }
    if (line.isNotEmpty) {
      // get to the next part of the line
      return await parseLine();
    } else {
      // end of this vc's lifecycle, flush vc buffer to global result
      flush(localResult.toString());
    }
  }

  void parseSpecial() {
    int start = line.indexOf('{') + 2;
    int end = line.indexOf('}', start + 1);
    switch (line.substring(start,end).toUpperCase()) {
      case 'N':
        localResult.write('\n');
      case 'L':
        localResult.write('{');
      case 'R':
        localResult.write('}');
      case '0':
        localResult.write('');
      default:
        localResult.write('');
    }
    localResult.write(line.substring(start + 1, end));
    // chop from current line
    line = line.substring(end + 1);
  }

  void parseNumberRange() {
    int between = parseNumberBetween();
    // add to result
    localResult.write(between.toString());
    int start = line.indexOf('{#');
    int end = line.indexOf('}', start + 2);
    // chop from current line
    line = line.substring(end + 1);
  }

  void parseAnonymous() {
    final random = Random();
    int start = line.indexOf('{[');
    int end = line.indexOf('}', start + 1);
    String anonymous = line.substring(start + 2, end);
    // add to result
    if (anonymous.split("|").length > 1 || random.nextBool()){
      localResult.write(pickRandomLine(anonymous.split("|")));
    }
    // chop from current line
    line = line.substring(end + 1);
  }

  Future<void> parseVariable() async {
    if (line.contains(RegExp(r'^{\^?\w*(#\d+-\d+)}'))) {
      repeat = parseNumberBetween();
      line = line.replaceFirst(RegExp(r'#\d+-\d+'), '');
    }
    int start = line.indexOf('{');
    int end = line.indexOf('}', start + 1);
    variableName = line.substring(start + 1, end);
    VocTrace vc = VocTrace(
        vocabulary: await getVocabulary(
            variableName.replaceFirst('^', '').toUpperCase(),
            vocabulary.projectId!),
        flush: (String addedResult){
          onResultAdded(addedResult);},
        repeat: repeat);
    vc.variableName = variableName;
    localResult.write(vc.parse());


    // add required nr of copies, the only way I could think of without
    // needing to figure out how to communicate across recursion levels
    // for (int i = 1; i <= repeat; i++) {
    //   await parse(next);
    // }
    // chop off from current line
    line = line.substring(end + 1);
  }

  void addChildResult(String childResult){
    localResult.write(childResult);
  }

  int parseNumberBetween(){
    final random = Random();
    int start = line.indexOf('#');
    int dash = line.indexOf('-');
    int end = line.indexOf('}', start + 1);
    int first = int.parse(line.substring(start + 1, dash));
    int second = int.parse(line.substring(dash + 1, end));
    int large = max(first, second) + 1;
    int small = min(first, second);
    return first + random.nextInt(large - small);
  }

  void parseLiteral(){
    int start = line.indexOf(RegExp(r'^'));
    int end = line.indexOf(RegExp(r'$|{'), start + 1);
    // add to result
    localResult.write(line.substring(start, end));
    // chop from line
    line = line.substring(end);
  }
  
  
}
