import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nonsense/model/type.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nonsense/model/project.dart';
import 'package:nonsense/model/vocabulary.dart';
import 'package:nonsense/model/category.dart';
import 'package:nonsense/views/vocabulary_view.dart';

class RunPage extends StatefulWidget {
  final VocabularyView vocabularyView;
  const RunPage({super.key, required this.vocabularyView});

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  late DatabaseHelper dbHelper;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double deviceScaling = refHeight / displayHeight;
    // titleController.text = newTitle;
    // notesController.text = newNotes;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: notepaperWhite,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Run ${widget.vocabularyView.title!}",
          style: TextStyle(color: notepaperWhite),
        ),
      ),
      backgroundColor: notepaperWhite,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 24.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/eend.png',
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.people_rounded),
                  title: Text('Authors'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
