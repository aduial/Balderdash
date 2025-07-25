import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/help.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutVoc7 extends StatelessWidget {
  const AboutVoc7({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "Special characters & strftime",
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
                                "A \\n newline (return / linefeed), curly brackets {} "
                                "and NULL a.k.a. 'nothing') can be included in a Vocabulary "
                                "like this:\n\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * scaling),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "{\\n} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "newline (return / linefeed)\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{\\L} {\\R} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "left & right curly braces\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{\\0} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      "Null (i.e. nothing)\n\nLast but not least, we pay homage "
                                      "to the good old ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "strftime ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      "datetime format that was so harshly deprecated in php 8.1. "
                                      "Hah! With that, Balderdash! may be the only IOS app that supports it. "
                                      "You can use:\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{@",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "strftime format",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text: " e.g. ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{@",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "%Y",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "}\n",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      "that returns the current date & time; or:\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{@",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "strftime format",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "|",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: limeAccent)),
                              TextSpan(
                                  text: "number1",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "|",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: limeAccent)),
                              TextSpan(
                                  text: "number2",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "e.g.\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{@",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "%H:%M:%S",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: lightPink)),
                              TextSpan(
                                  text: "|",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: limeAccent)),
                              TextSpan(
                                  text: "0",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "|",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: limeAccent)),
                              TextSpan(
                                  text: "86400",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w600,
                                      color: activeCompleteSetColour)),
                              TextSpan(
                                  text: "} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w700,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      "(... whole numbers!)\n\nThe latter returning ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "a timestamp between number1 and number2 seconds ago (ie. one day)",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text:
                                      ", of which original Nonsense author James Baughn says it is 'actually "
                                      "more useful than it might first appear…' though I haven't been "
                                      "able to discover what that is about. A strftime format cheat sheet is "
                                      "available on\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "https://strftime.org/.\n\n\n\n\n\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
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
          icon: const Icon(Icons.fast_rewind_rounded),
          label: const Text('Help'),
          foregroundColor: ithildin,
          backgroundColor: sortOfRed,
          // child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Help()),
            );
          }),
    );
  }
}
