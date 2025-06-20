import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:nonsense/model/vocabulary.dart';

class VocTrace {
  final Vocabulary vocabulary;
  int repeat = 1;
  String line = '';
  late String variableName = '';

  final StringBuffer localResult = StringBuffer();

  VocTrace({required this.vocabulary, required this.line});

  String get result {
    return localResult.toString();
  }

  void multiply() {
    String balderdash = localResult.toString();
    for (int i = 1; i < repeat; i++) {
      localResult.write(balderdash);
    }
  }

  // case 1 returns only capitalised string if result hasn't been cleared
  String getCasedResult() {
    if (repeat > 1) {
      multiply();
    }
    switch (getVariableCase()) {
      case 1:
        return localResult.toString().capitalize;
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


  int getVariableCase() {
    RegExp cap = RegExp(r'^\^');
    RegExp lc = RegExp(r'^[a-z0-9]+$');
    RegExp uc = RegExp(r'^[A-Z0-9]+$');
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
