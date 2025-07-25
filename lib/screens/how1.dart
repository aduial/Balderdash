import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/how2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class How1 extends StatelessWidget {
  const How1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "How Balderdash! works (1)",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: ithildin,
              fontWeight: FontWeight.w500,
              fontSize: 18 * scaling),
        ),
      ),
      backgroundColor: blueTop,
      body: SafeArea(
        bottom: false,
        //child: Padding(
        //padding: EdgeInsetsDirectional.fromSTEB(0, 10 * scaling, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    10 * scaling, 10 * scaling, 10 * scaling, 10 * scaling),
                child: Text(
                  "What & How",
                  style: GoogleFonts.playfairDisplay(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontWeight: FontWeight.w200,
                      fontSize: 50 * scaling,
                      color: ithildin),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 25.0 * scaling,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: yellowGrey,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 10.0 * scaling,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: sortOfRed,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 18.0 * scaling,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: iceBlue,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [iceBlue, mountainBlue],
                  ),
                ),
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        20 * scaling, 0, 20 * scaling, 30 * scaling),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: "The idea is that you provide ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * scaling),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Balderdash! ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text:
                                      "with a bootstrap vocabulary, say, VOC1. This can be *any* "
                                      "vocabulary regardless of it's 'Category' (which is just a "
                                      "convenience label) because Balderdash! has got to start ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "somewhere.\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "This vocabulary (like any) contains lines with text, and "
                                      "commands between curly brackets {} that refer to other "
                                      "vocabularies (and perform some other functions that we'll "
                                      "get into later).\n\n"
                                      "Balderdash! randomly selects a line from VOC1 and starts "
                                      "working its way through it: plain text is added to the result "
                                      "and when a command - say, {VOC2} - is encountered, "
                                      "work on VOC1 is put on hold. It identifies {VOC2} as "
                                      "referring to another Vocabulary VOC2, "
                                      "gets that from the database and starts working on ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "that: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "picking a line, adding text found in there to "
                                      "the result, until it either comes across another variable (and "
                                      "the process repeats one level deeper) or until it reaches the "
                                      "end of the current line, pops back up to where it left "
                                      "off, and continues there. This goes on until Balderdash! reaches "
                                      "the end of the line in the bootstrap vocabulary and it returns "
                                      "whatever it has collected.\n\n(continues on next page)\n\n\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.navigate_next_rounded),
          label: const Text('Next'),
          foregroundColor: ithildin,
          backgroundColor: sortOfRed,
          // child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const How2()),
            );
          }),
    );
  }
}
