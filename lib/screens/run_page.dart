import 'package:flutter/material.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:nonsense/views/vocabulary_view.dart';
import 'package:nonsense/model/vocabulary.dart';
import 'package:nonsense/widgets/voc_trace.dart';

import '../widgets/voc_trace.dart';

class RunPage extends StatefulWidget {
  final VocabularyView _vocabularyView;
  const RunPage({super.key, required VocabularyView vocabularyView})
      : _vocabularyView = vocabularyView;

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  late DatabaseHelper _dbHelper;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController resultController =
      TextEditingController(text: '');
  StringBuffer globalResult = StringBuffer();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
  }

  Future<Vocabulary> getVocabulary(String title, int projectId) {
    return _dbHelper.getVocabularyByTitleAndProject(title, projectId);
  }

  Future<void> doThings() async {
    globalResult.clear();
    Vocabulary voc = Vocabulary.fromMap({
      "id": widget._vocabularyView.id,
      "categoryId": widget._vocabularyView.categoryId,
      "projectId": widget._vocabularyView.projectId,
      "title": widget._vocabularyView.title,
      "content": widget._vocabularyView.content,
      "comment": widget._vocabularyView.comment,
      "useThis": widget._vocabularyView.useThis,
    });
    VocTrace vc = VocTrace(
        vocabulary: voc,
        flush: _onFlush,
        repeat: 1);
    globalResult.write(await vc.parse());
    resultController.text = globalResult.toString();
  }

  _onFlush(String result){
    globalResult.write(result);
    // return flushLocalResult();
  }

  void addChildResult(String childResult){
    globalResult.write(childResult);
  }


  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double deviceScaling = refHeight / displayHeight;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: notepaperWhite,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Run ${widget._vocabularyView.title!}",
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
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      'assets/images/shampoo.png',
                    ),
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                        iconAlignment: IconAlignment.end,
                      ),
                      onPressed: () {
                        setState(() {
                          doThings();
                        });
                      },
                      child: const Icon(
                        Icons.cable_rounded,
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.all(6)),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: resultController,
                      decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: offWhite,
                          labelText: '${widget._vocabularyView.title!} result',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
