class StringUtils {
  StringUtils._();
  static String exampleCase = '';
  static String followCase = '';

  static String capitalise(String input) {
    if (input.length > 1) {
      int start = input.indexOf(RegExp(r'[a-zA-Z]'));
      if (start > 0) {
        String fuzz = input.substring(0, start);
        String word = input.substring(start);
        return fuzz + word[0].toUpperCase() + word.substring(1);
      } else {
        return input[0].toUpperCase() + input.substring(1);
      }
    } else {
      return input.toUpperCase();
    }
  }

  static String getCasey(String example, String follow) {
    exampleCase = example;
    followCase = follow;
    switch (checkCase()) {
      case 1:
        return capitalise(followCase.toString());
      case 2:
        return followCase.toString().toLowerCase();
      case 3:
        return followCase.toString().toUpperCase();
      case 4:
        return followCase.toString();
      case 0:
        return followCase.toString();
    }
    return "Error applying case formatting";
  }

  static int checkCase() {
    RegExp cap = RegExp(r'^\^');
    RegExp lc = RegExp(r'^[a-z0-9]+$');
    RegExp uc = RegExp(r'^[A-Z0-9]+$');
    RegExp mc = RegExp(r'^[a-zA-Z0-9]+$');

    if (cap.hasMatch(exampleCase)) {
      return 1;
    } else if (lc.hasMatch(exampleCase)) {
      return 2;
    } else if (uc.hasMatch(exampleCase)) {
      return 3;
    } else if (mc.hasMatch(exampleCase)) {
      return 4;
    } else {
      return 0;
    }
  }
}
