import 'package:flutter/cupertino.dart';


// reference screen height minus padding (iPhone 15)
const double refHeight = 759.0;
const String newVocabularyTitle = "NEW";
const String newTemplateTitle = "New Template";
const String newAuthorName = "New Author";
const String newCategoryName = "New Category";
const String newProjectTitle = "New Project";
const String BootstrapSubTitle = "tap icon to filter on Project and Category";

var langCategories = <String>[
  'minimal',
  'basic',
  'medium',
  'large',
  'complete',
];

var matchingMethods = <String>[
  'anywhere',
  'strict',
  'start',
  'end',
  'verbatim',
  'regex',
];

List<IconData> matchIcons = [
  CupertinoIcons.search,
  CupertinoIcons.search_circle,
  CupertinoIcons.arrow_left_to_line,
  CupertinoIcons.arrow_right_to_line,
  CupertinoIcons.equal,
  CupertinoIcons.ellipsis,
];

