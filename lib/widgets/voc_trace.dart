import 'package:flex_color_scheme/flex_color_scheme.dart';

class VocTrace {

  final Function(String) flushResult;
  int repeat = 1;
  String line = '';
  late String variableName;
  final StringBuffer localResult = StringBuffer();
  VocTrace({
    required this.flushResult,
    required this.line,
  });

  String get result {
    return localResult.toString();
  }

  String getCasedResult(){
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
}
