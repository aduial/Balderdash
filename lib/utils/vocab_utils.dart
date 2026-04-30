

import 'dart:convert';

import 'package:diacritic/diacritic.dart';

import '../config/config.dart';
import '../views/vocabulary_view.dart';

class VocabUtils {
  VocabUtils._();

  static String checkContent(String vcc) {
    StringBuffer sb = StringBuffer();
    Map<int, bool> lineErrorState = {};
    int i = 0;
    bool isOK = true;
    for (String line in splitContent(vcc, false)){
      i++;
      lineErrorState[i] = checkLine(line);
    }
    if (lineErrorState.containsValue(false)){
      lineErrorState.forEach((key, value) {
        if (!value){
          sb.write('$key ');
        }
      });
    }
    // print(sb.toString());
    return sb.toString().trimRight();
  }

  static Map<int, bool> checkVocabularyViews(List<VocabularyView> vvs) {
    Map<int, bool> vvErrorState = {};
    bool isOK = true;
    for (VocabularyView vv in vvs){
      isOK = true;
      for (String line in splitContent(vv.content!, false)){
        isOK = checkLine(line);
        if (!isOK){
          break;
        }
      }
      vvErrorState[vv.id!] = isOK;
    }
    return vvErrorState;
  }

  static List<String> splitContent(String content, bool onlyVars) {
    List<String> uniqueLines = [];
    List<String> activeLines = [];
    LineSplitter ls = LineSplitter();
    uniqueLines = ls.convert(content);
    if (uniqueLines[0].isEmpty) {
      return [emptyFirstLineError];
    }
    for (var line in uniqueLines) {
      if (line.isEmpty) {
        break;
      }
      if (onlyVars) {
        RegExp varMatch = RegExp(r'\{\^?\w+:?=?\^?\w+(#\d+-\d+)?\}');
        if (line.contains(varMatch)) {
          activeLines.add(
              varMatch.allMatches(line).map((m) => m.group(0)).toString());
        }
      } else {
        activeLines.add(line);
      }
    }
    return activeLines;
  }

  static bool checkLine(String line) {
    // weighting factor
    line = line.replaceAll(RegExp(r'^#\d+#'), '');
    // anonymous
    line = removeDiacritics(line).replaceAll(RegExp(r'\{\[[\x27\w\s\\^@|()<>%*_";:?!\-+,.™©®]+\}'), '');
    // special
    line = line.replaceAll(RegExp(r'{\\[NRLnrl0]\}'), '');
    // assign state var
    line = removeDiacritics(line).replaceAll(RegExp(r'\{\w+:=[\x27\w\s\\^@|()<>%*_";:?!\-+,.]+\}'), '');
    // assign state literal
    line = removeDiacritics(line).replaceAll(RegExp(r'^\{\w*=([\w\s\\@()<>%*_";:?!\-+,.™©®])+\}'), '');
    // vocabulary var
    line = removeDiacritics(line).replaceAll(RegExp(r'\{\^?\w+(#\d+-\d+)?\}'), '');
    // pointer
    line = removeDiacritics(line).replaceAll(RegExp(r'\{\$\$\^?\w*\}'), '');
    // strftime
    line = removeDiacritics(line).replaceAll(RegExp(r'\{@(%-?\w\w?\W*)*(\|\d+\|\d+)?\}'), '');
    // write state variable
    line = removeDiacritics(line).replaceAll(RegExp(r'\{\$\^?\w*\}'), '');
    // no more curly braces left, now remove all literals
    line = removeDiacritics(line).replaceAll(RegExp(r'[\x27\w\s\\@()&\$<>%*_"/;:?!\-+,.™©®]'), '');
    if (line.isNotEmpty) {
      // if something's left, its an error
      return false;
    } else {
      return true;
    }
  }



}