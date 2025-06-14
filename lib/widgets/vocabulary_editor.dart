import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/src/mode.dart';
import 'package:nonsense/language/nonsense.dart';
import 'package:nonsense/language/dusty.dart';
// import 'package:highlight/languages/dust.dart';
import 'package:nonsense/config/nonsense_theme_colours.dart';
import 'package:nonsense/config/colours.dart';
import 'package:google_fonts/google_fonts.dart';


class VocabularyEditor extends StatelessWidget {
  final String content;
  final Function(String) onContentUpdated;
  VocabularyEditor({
    super.key,
    required this.content,
    required this.onContentUpdated
  });

  final controller = CodeController();

  @override
  Widget build(BuildContext context) {
    controller.text = content;
    controller.language = nonsense;
    // controller.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CodeTheme(
          data: CodeThemeData(
              styles: nonsenseTheme),
            child: SingleChildScrollView(
              child: CodeField(
                background: offWhite,
                cursorColor: darkVerbatimMatchColour,
                controller: controller,
                onChanged: (value) => onContentUpdated(value),
                textStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: "Courier",
                    fontWeight: FontWeight.normal),
                gutterStyle: GutterStyle(
                  margin: 8,
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
                  width: 56,
                  background: offWhite
                ),
              ),
            ),
        ),
      ),
    );
  }
}