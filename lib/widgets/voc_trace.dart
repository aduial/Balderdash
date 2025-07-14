import 'package:balderdash/model/vocabulary.dart';
import 'package:balderdash/utils/string_utils.dart';
import 'package:diacritic/diacritic.dart';

class VocTrace {
  final Vocabulary vocabulary;
  int repeat = 1;
  String line = '';
  String variableName = '';

  final StringBuffer localResult = StringBuffer();

  VocTrace({required this.vocabulary, required this.line, required this.variableName});

  String getNormaLine(){
    return removeDiacritics(line);
  }

  String getResult() {
    return localResult.toString();
  }

  String getCasedResult() {
    return StringUtils.getCasey(variableName, localResult.toString());
  }
}
