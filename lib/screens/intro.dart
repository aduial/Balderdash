import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

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
          "About this app",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: ithildin,
              fontWeight: FontWeight.w500,
              fontSize: 18 * toScale),
        ),
      ),
      backgroundColor: blueTop,
      body: SafeArea(
        bottom: false,
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
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20 * toScale, 0, 20 * toScale, 30 * toScale),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text:
                                  "This app is a continuation of a context-free grammar text generator "
                                  "from 2001 called ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: ithildin,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13 * toScale),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Nonsense",
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        ", that you can still download from\nhttps://nonsense.sourceforge.net/. "
                                            "A slightly extended version 0.7.1 that fixes the issue "
                                            "with cgi-bin deployment and adds some minor features is available "
                                            "on Github here:\nhttps://github.com/aduial/nonsense\n\n"
                                        "Nonsense defines the grammar in ",
                                    style: TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: ".data files",
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: ", each containing many ",
                                    style: TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "vocabularies",
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "(a group of lines containing text and commands). "
                                        "Balderdash! is completely compatible with grammars written "
                                        "for Nonsense. In fact, I've included the original demo "
                                        "content in this app. The difference is that this app doesn’t "
                                        "use .data files, but a local ",
                                    style: TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "SQLite ",
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "database.\n\nThis allows adding entities like users, "
                                        "categories and projects to structure the process, "
                                        "that you can use or ignore as you see fit. "
                                        "The smaller screen size gave rise to the vocabulary as the "
                                        "basic unit of a grammar instead of .data files containing "
                                        "dozens of vocabularies each.\n\n"
                                        "How Nonsense! works, writing vocabularies and managing "
                                        "projects in the app is all described in help pages.\n\n\n\n\n",
                                    style: TextStyle(fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ]),
      ),
    );
  }
}
