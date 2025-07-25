import 'package:balderdash/config/balderdash_theme_colours.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/language/balderdash.dart';
import 'package:balderdash/language/balderdash_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

import '../config/config.dart';

class ContentEditor extends StatelessWidget {
  final String content;
  final Function(String) onContentUpdated;
  bool isVocabulary = true;
  ContentEditor({
    super.key,
    required this.content,
    required this.onContentUpdated,
    required this.isVocabulary,
  });

  final controller = CodeController();

  @override
  Widget build(BuildContext context) {
    controller.text = content;
    if (isVocabulary) {
      controller.language = balderdash;
    } else {
      controller.language = balderdashTemplate;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CodeTheme(
          data: CodeThemeData(styles: balderdashTheme),
          child: SingleChildScrollView(
            child: CodeField(
              background: offWhite,
              cursorColor: darkVerbatimMatchColour,
              controller: controller,
              onChanged: (value) => onContentUpdated(value),
              textStyle: TextStyle(
                  fontSize: 12 * scaling,
                  fontFamily: "Courier",
                  fontWeight: FontWeight.normal),
              gutterStyle: GutterStyle(
                  margin: 5 * scaling,
                  textStyle: TextStyle(
                    height: 1.5,
                    fontSize: 12,
                    fontFamily: "Courier",
                    fontWeight: FontWeight.bold,
                    color: lightAnyMatchColour,
                  ),
                  showErrors: false,
                  showFoldingHandles: false,
                  showLineNumbers: true,
                  width: 66 * scaling,
                  background: offWhite),
            ),
          ),
        ),
      ),
    );
  }
}
