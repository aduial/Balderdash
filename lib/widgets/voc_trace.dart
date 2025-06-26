import 'package:nonsense/model/vocabulary.dart';
import 'package:nonsense/utils/string_utils.dart';

class VocTrace {
  final Vocabulary vocabulary;
  int repeat = 1;
  String line = '';
  String variableName = '';

  final StringBuffer localResult = StringBuffer();

  VocTrace({required this.vocabulary, required this.line, required this.variableName});

  String getResult() {
    return localResult.toString();
  }

  String getCasedResult() {
    return StringUtils.getCasey(variableName, localResult.toString());
  }
}
