import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/about_voc2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutVoc1 extends StatelessWidget {
  const AboutVoc1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "About Vocabularies",
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
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: "A ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * scaling),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Vocabulary ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      "is a named group of one to many lines containing plain text "
                                      "and ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{commands} ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      "between curly braces. These commands can be ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "references to other vocabularies, inline alternatives "
                                      "(anonymous vocabularies), state variables, formatted "
                                      "date/time, numbers ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "or ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "special characters",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      ". \n\nWe'll explain all those in the next screens. Just keep "
                                      "hitting that '> next' button! The text is scrollable "
                                      "if it doesn't fit on your device's screen.\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "Lines can be any length, and must be separated by a ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "\\n",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " newline (return / linefeed) character.\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "A vocabulary can’t be empty: empty lines and anything below them "
                                      "are ignored (useful for testing a line: put it on "
                                      "top and add a return after it).\n"
                                      "A vocabulary title must be unique within a project.\n\n"
                                      "Vocabularies can be set active or inactive in the editor: "
                                      "when inactive, vocabularies are ignored by Balderdash! and appear greyed out "
                                      "in the 'Run Balderdash! and vocabulary editor lists.\n\n\n\n\n\n",
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
        //),
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
              MaterialPageRoute(builder: (context) => const AboutVoc2()),
            );
          }),
    );
  }
}
