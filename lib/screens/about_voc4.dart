import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/about_voc5.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutVoc4 extends StatelessWidget {
  const AboutVoc4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "Vocabularies - text case",
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
              flex: 5,
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
                            text:
                                "Vocabulary START of the example grammar took off with: ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * scaling),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "{^Whoknows}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " referring to vocabulary WHOKNOWS. Vocabulary titles are "
                                      "UPPERCASE, but the case of the {commands} referring to them "
                                      "determines the case of the text they return:\n\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * scaling)),
                              TextSpan(
                                  text: "{Whoknows}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " (mixed case) returns the text unchanged re. case: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * scaling)),
                              TextSpan(
                                  text:
                                      "'If we don't fix that stereo set,' \n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text: "{whoknows}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " (all lowercase) returns the text in lowercase: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * scaling)),
                              TextSpan(
                                  text: "'maybe'\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text: "{WHOKNOWS}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " (all UPPERCASE) returns the text in UPPERCASE:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * scaling)),
                              TextSpan(
                                  text: "'MAYBE'\n\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13 * scaling)),
                              TextSpan(
                                  text: "{^Whoknows}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " (prefixed with ^) returns the text with the first letter capitalised:\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * scaling)),
                              TextSpan(
                                  text: "'If nothing comes between,'\n\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  )),
                              TextSpan(
                                  text:
                                      "So, the example grammar might result in: \n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * scaling)),
                              TextSpan(
                                  text:
                                      "'If nothing comes between, Charles might slap neighbour Todd "
                                      "next week'\n"
                                      "'Maybe neighbour Todd could drop by tomorrow'\n"
                                      "'If we don't fix that stereo set, auntie Bertha might start "
                                      "playing her electric wah-wah guitar very loudly one of these days'\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: laurelin)),
                              TextSpan(
                                  text:
                                      "... or some variation thereof.\n\n\n\n\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * scaling))
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
              MaterialPageRoute(builder: (context) => const AboutVoc5()),
            );
          }),
    );
  }
}
