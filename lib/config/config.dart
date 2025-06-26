

// reference screen height minus padding (iPhone 15)
  const double refHeight = 759.0;
  const String newVocabularyTitle = "NEW";
  const String newTemplateTitle = "New Template";
  const String newAuthorName = "New Author";
  const String newCategoryName = "New Category";
  const String newProjectTitle = "New Project";
  const String BootstrapSubTitle = "tap icon to filter on Project and Category";
  const String noEmptyVocabulary = "Vocabulary without content";
  const String vocabularyNotFound = "Vocabulary not found";
  const String endlessLoopDetected = "Endless loop";
  const String endlessLoopError = "ENDLESS_LOOP_ERROR";
  const String doubleCurlyBracesError = "DOUBLE_CURLY_BRACES_ERROR";

  Map<String, String> strfToDart = {
    '%a': 'D',
    '%A': 'DD',
    '%d': 'dd',
    '%-d': 'd',
    '%b': 'M',
    '%B': 'MM',
    '%m': 'mm',
    '%-m': 'm',
    '%y': 'yy',
    '%Y': 'yyyy',
    '%H': 'HH',
    '%-H': 'H',
    '%I': 'hh',
    '%-I': 'h',
    '%p': 'am',
    '%M': 'nn',
    '%-M': 'n',
    '%S': 'ss',
    '%-S': 's',
    '%f': 'SSS',
    '%g': 'uuu',
    '%W': 'WW',
    '%-W': 'W',
    '%z': 'z',
    '%Z': 'Z',
  };

