import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/about_voc7.dart';

class AboutVoc6 extends StatelessWidget {
  const AboutVoc6({super.key});

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
          "Numbers and repetitions",
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
                            text: "Nonsense! will replace this command:\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * toScale),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                  "{",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                  "#",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text:
                                  "number1",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text:
                                  "-",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: limeAccent)),
                              TextSpan(
                                  text:
                                  "number2",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text:
                                  "}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: "(whole numbers only!)\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "with a random whole number between ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "number1 ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "and ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "number2 ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "(inclusive).\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "When processing a vocabulary, Nonsense! randomly picks "
                                      "one of the lines. However, you can influence the odds a line "
                                      "is selected by prefixing the line with a weight factor ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                  "#",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "number",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text:
                                  "#",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: " (a whole number), for instance:\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "...\nrandom chance being picked\n",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: "#",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "2",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "#",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "twice as {often}\n",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500)),

                              TextSpan(
                                  text: "#",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "7",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "#",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "seven times as {[likely|often}\n"
                                      "...\n",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text:
                                      "This goes for all lines regardless their content.\n\n"
                                      "You can have Nonsense! evaluate a command multiple "
                                      "times using this format:\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                  "{command",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                  "#",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text:
                                  "number1",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text:
                                  "-",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: limeAccent)),
                              TextSpan(
                                  text:
                                  "number2",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text:
                                  "}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: "(whole numbers only!)\nwhich will repeat it a random "
                                      "whole number between ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "number1 ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "and ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "number2 ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "(inclusive) times. This is especially useful "
                                      "in starting (bootstrap) vocabularies.\n\n\n\n\n\n\n\n",
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
          icon: const Icon(Icons.skip_next_rounded),
          label: const Text('Last!'),
          foregroundColor: ithildin,
          backgroundColor: sortOfRed,
          // child: const Icon(Icons.add),
          onPressed: ()  {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AboutVoc7()),
            );
          }),
    );
  }
}
