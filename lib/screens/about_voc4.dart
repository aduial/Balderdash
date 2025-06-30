import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:nonsense/screens/about_voc5.dart';

class AboutVoc4 extends StatelessWidget {
  const AboutVoc4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double toScale = refHeight / displayHeight;
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
              fontSize: 18 * toScale),
        ),
      ),
      backgroundColor: blueTop,
      body: SafeArea(
        bottom: false
        ,
        //child: Padding(
        //padding: EdgeInsetsDirectional.fromSTEB(0, 10 * toScale, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    10 * toScale, 10 * toScale, 10 * toScale, 10 * toScale),
                child: Text(
                  "What & How",
                  style: GoogleFonts.playfairDisplay(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontWeight: FontWeight.w200,
                      fontSize: 50 * toScale,
                      color: ithildin),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 25.0 * toScale,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: yellowGrey,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 10.0 * toScale,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: sortOfRed,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 18.0 * toScale,
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
                        20 * toScale, 0, 20 * toScale, 30 * toScale),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: "Vocabulary START of the example grammar started with: ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * toScale),
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
                                  style: TextStyle(fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * toScale
                                  )),
                              TextSpan(
                                  text: "{Whoknows}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " (mixed case) returns the text unchanged re. case: ",
                                  style: TextStyle(fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * toScale
                                  )),
                              TextSpan(
                                  text: "'If we don't fix that stereo set,' \n\n",
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
                                  style: TextStyle(fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * toScale
                                  )),
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
                                  style: TextStyle(fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * toScale
                                  )),
                              TextSpan(
                                  text: "'MAYBE'\n\n",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      fontSize: 13 * toScale
                                  )),
                              TextSpan(
                                  text: "{^Whoknows}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " (prefixed with ^) returns the text with the first letter capitalised:\n",
                                  style: TextStyle(fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * toScale
                                  )),
                              TextSpan(
                                  text: "'If nothing comes between,'\n\n",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w600,)),
                              TextSpan(
                                  text:
                                      "So, the example grammar might result in: \n",
                                  style: TextStyle(fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * toScale
                                  )),
                              TextSpan(
                                  text:
                                      "'If nothing comes between, Charles might slap neighbour Todd "
                                      "next week'\n"
                                      "'Maybe neighbour Todd could drop by tomorrow'\n"
                                      "'If we don't fix that stereo set, auntie Bertha might start "
                                      "playing her electric wah-wah guitar very loudly one of these days'\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500,
                                      color: laurelin)),
                              TextSpan(
                                  text: "... or some variation thereof.\n\n\n\n\n",
                                  style: TextStyle(fontWeight: FontWeight.w300,
                                      color: ithildin,
                                      fontSize: 13 * toScale
                                  ))
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
          onPressed: ()  {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AboutVoc5()),
            );
          }),
    );
  }
}
