import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/about_voc4.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutVoc3 extends StatelessWidget {
  const AboutVoc3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "Anonymous Vocabularies",
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
                            text: "Maybe you noticed these in the example:\n\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: ithildin,
                                    fontSize: 13 * scaling),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "{[me|you} {[an|the|her} {[ very loudly}\n\n",
                                  style: GoogleFonts.notoSansMono(
                                      color: laurelin,
                                      fontSize: 13 * scaling,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: "These ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin)),
                              TextSpan(
                                  text: "Anonymous Vocabularies ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      " act like inline mini-vocabularies. They start with a "
                                      "curly bracket and a left square bracket ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin)),
                              TextSpan(
                                  text: "{[",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text: ", close with a right curly bracket ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin)),
                              TextSpan(
                                  text: "}",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      ", with alternatives separated by a pipe ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin)),
                              TextSpan(
                                  text: "| ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                      "character. Balderdash! randomly picks one of the alternatives. "
                                      "When one word is given, it has a 50% chance "
                                      "of being selected. You can tweak the "
                                      "odds by duplicating words and/or adding empty terms. These are "
                                      "not ignored as in regular Vocabularies, so you can use:\n\n ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin)),
                              TextSpan(
                                  text: "{[|||Tom|Harry|Harry}\n\n",
                                  style: GoogleFonts.notoSansMono(
                                      color: laurelin,
                                      fontSize: 13 * scaling,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text:
                                      "||| means three 'empty strings', and with one Tom "
                                      "and two Harry's there's a 50% chance of '' (nothing), one in three "
                                      "of 'Harry' and one in six of 'Tom'.\n\n\n\n\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ithildin)),
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
              MaterialPageRoute(builder: (context) => const AboutVoc4()),
            );
          }),
    );
  }
}
