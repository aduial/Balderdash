import 'package:flutter/painting.dart';
import 'package:balderdash/config/colours.dart';

const balderdashTheme = {
  'root':
  TextStyle(
      backgroundColor: notepaperWhite,
      color: Color(0xff000000)),
  'comment': TextStyle(color: Color(0xff008000)),
  'repeater': TextStyle(color: Color(0xff60A000)),
  'variable': TextStyle(color: Color(0xff008000)),
  'number': TextStyle(color: Color(0xffc31515)),
  'keyword': TextStyle(color: Color(0xff0000ff)),
  'hash': TextStyle(color: Color(0xFF303080)),
  'pipe': TextStyle(color: Color(0xFF878188)),
  'brace': TextStyle(color: Color(0xFF303080)),
  'div': TextStyle(color: Color(0xFF5968B3)),
  'year': TextStyle(color: Color(0xFF876D97)),
  'curly': TextStyle(color: Color(0xffa31515)),
  'literal': TextStyle(color: Color(0xffa31515)),
  'vocab-literal': TextStyle(color: Color(0xFF208020), fontWeight: FontWeight.bold),
  'vocab-ref': TextStyle(color: Color(0xffff4000), fontWeight: FontWeight.bold),
  'vocab-title': TextStyle(color: Color(0xff60C000), fontWeight: FontWeight.bold),
  'attr': TextStyle(color: Color(0xFF520021)),
  'doctag': TextStyle(color: Color(0xFF705050)),
  'meta': TextStyle(color: Color(0xFF9B4050)),
  'meta-keyword': TextStyle(color: Color(0xFF9B4080)),
  'meta-string': TextStyle(color: Color(0xFF808050)),
  'name': TextStyle(color: Color(0xFF705020)),
  'string': TextStyle(color: Color(0xFF907000)),
  'symbol': TextStyle(color: Color(0xFF809000)),
  'tag': TextStyle(color: Color(0xFF700020)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
};