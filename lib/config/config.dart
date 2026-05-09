import 'dart:math';

import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

double scaling = 1.0;

String _menuImg = 'assets/images/shampoo.png';
String _helpImg = 'assets/images/einenhand.png';
String _drawerImg = 'assets/images/eend.png';
String _rbdImg = 'assets/images/afwas.png';

setMenuImg() {
  _menuImg = getImage();
}

setHelpImg() {
  _helpImg = getImage();
  do {
    "set helpImg";
    _helpImg = getImage();
  } while (_helpImg == _menuImg);
}

setDrawerImg() {
  do {
    "set drawerImg";
    _drawerImg = getImage();
  } while (_drawerImg == _menuImg || _drawerImg == _helpImg);
}

setRBDImg() {
  do {
    "set BDimg";
    _rbdImg = getImage();
  } while (_rbdImg == _menuImg || _rbdImg == _helpImg || _rbdImg == _drawerImg);
}

String getMenuImg() {
  return _menuImg;
}

String getHelpImg() {
  return _helpImg;
}

String getDrawerImg() {
  return _drawerImg;
}

String getRBDImg() {
  return _rbdImg;
}

// reference screen height minus padding (iPhone 15)
const double refHeight = 759.0;
const String newVocabularyTitle = "NEW";
const String newTemplateTitle = "New Template";
const String newAuthorName = "New Author";
const String newCategoryName = "New Category";
const String newProjectTitle = "New Project";
const String bootstrapSubTitle = "tap gear icon to filter list";
const String wordSearchSubTitle = "find vocabularies with search term";
const String noEmptyVocabulary = "Vocabulary without content";
const String vocabularyNotFound = "Vocabulary not found";
const String endlessLoopDetected = "Endless loop";
const String endlessLoopError = "ENDLESS_LOOP_ERROR";
const String doubleCurlyBracesError = "DOUBLE_CURLY_BRACES_ERROR";
const String emptyFirstLineError = "EMPTY_FIRST_LINE_ERROR";
const String defaultProject = "defaultProject";
const String defaultCategory = "defaultCategory";
const String markOnSave = "markOnSave";
const String checkOnSave = "checkOnSave";
const String noNonsense = "noNonsense";
const String htmlContent = "HTML";
const String rdfContent = "RDF";
const String prjInsertInto =
    "INSERT INTO project (typeId, authorId, title, notes) VALUES ";
const String vocInsertInto =
    "INSERT INTO vocabulary (projectId, categoryId, title, content, comment, useThis) VALUES ";
const String tplInsertInto =
    "INSERT INTO template (projectId, title, content, isHtml, notes) VALUES ";
const String pvocMark = "--projectvocabularies";
const String lvocMark = "--libraryvocabularies";
const String tmplMark = "--templates";
// const String pidMark = "§@pId@§";

const String sep1 = "%1@";
const String sep2 = "%2@";
const String sep3 = "%3@";
const String sep4 = "%4@";
const String sep5 = "%5@";
String prjRegex = "r'^\\d+$sep1\\d+$sep2\\d+$sep3(\\w+)$sep4\\w+'";
const String vocInsert = "INSERT INTO vocabulary (";

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

List<String> images = [
  'assets/images/aftershave.png',
  'assets/images/afwas.png',
  'assets/images/allergiepillen.png',
  'assets/images/anwb.png',
  'assets/images/badschuim.png',
  'assets/images/bergschoenen.png',
  'assets/images/bestek.png',
  'assets/images/boek.png',
  'assets/images/bzztop.png',
  'assets/images/deodorant.png',
  'assets/images/didier.png',
  'assets/images/diveholiday.png',
  'assets/images/drwho.png',
  'assets/images/eend.png',
  'assets/images/einenhand.png',
  'assets/images/gel.png',
  'assets/images/gitaar.png',
  'assets/images/glazen.png',
  'assets/images/groke.png',
  'assets/images/haarlak.png',
  'assets/images/hangmat.png',
  'assets/images/hellsangel.png',
  'assets/images/hoed.png',
  'assets/images/juwelen.png',
  'assets/images/kleurtjes.png',
  'assets/images/knijn.png',
  'assets/images/knijpers.png',
  'assets/images/kompas.png',
  'assets/images/kurketrekker.png',
  'assets/images/lipbalsem.png',
  'assets/images/luchtpomp.png',
  'assets/images/makeup.png',
  'assets/images/matras.png',
  'assets/images/motor.png',
  'assets/images/muts.png',
  'assets/images/nachtcreme.png',
  'assets/images/netteschoenen.png',
  'assets/images/oma.png',
  'assets/images/pechspul.png',
  'assets/images/picnic.png',
  'assets/images/pleisters.png',
  'assets/images/plu.png',
  'assets/images/poejoe.png',
  'assets/images/poezerik.png',
  'assets/images/pollepel.png',
  'assets/images/prommah.png',
  'assets/images/radio.png',
  'assets/images/regen.png',
  'assets/images/rubberhamer.png',
  'assets/images/sandalen.png',
  'assets/images/schaak.png',
  'assets/images/schaar.png',
  'assets/images/schans.png',
  'assets/images/scheer.png',
  'assets/images/shampoo.png',
  'assets/images/skiholiday.png',
  'assets/images/slippers.png',
  'assets/images/smite.png',
  'assets/images/strandbal.png',
  'assets/images/strandschepje.png',
  'assets/images/tandpasta.png',
  'assets/images/tas.png',
  'assets/images/tennisballen.png',
  'assets/images/tent.png',
  'assets/images/verrekijker.png',
  'assets/images/voetbal.png',
  'assets/images/watercooler.png',
  'assets/images/wfh.png',
  'assets/images/zakmes.png',
];

String getImage() {
  int nrImages = images.length;
  final random = Random();
  int imagenr = random.nextInt(nrImages);
  // print("image nr: $imagenr");
  return images[imagenr] ?? '';
}
