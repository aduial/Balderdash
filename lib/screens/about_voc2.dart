import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/about_voc3.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutVoc2 extends StatelessWidget {
  const AboutVoc2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "Example Vocabulary",
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
                                "Have a look at this example. You'll probably need "
                                "to scroll down to see all of it:\n\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: ithildin,
                                    fontSize: 13 * scaling),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "START\n"
                                      "{^Whoknows} {Person} {Dothis} {sometime}\n\n"
                                      "WHOKNOWS\n"
                                      "Maybe\n"
                                      "if nothing comes between, \n"
                                      "If we don't fix that stereo set, \n\n"
                                      "PERSON\n"
                                      "Charles\n"
                                      "neighbour Todd\n"
                                      "auntie Bertha\n\n"
                                      "SOMETIME\n"
                                      "Tomorrow\n"
                                      "Next week\n"
                                      "One of these days\n\n"
                                      "DOTHIS\n"
                                      "{maybe} {something}\n"
                                      "{surely} {somethingelse}\n\n"
                                      "MAYBE\n"
                                      "could\n"
                                      "might\n\n"
                                      "SURELY\n"
                                      "will\n"
                                      "might{[ instead}\n\n"
                                      "SOMETHING\n"
                                      "start sneezing\n"
                                      "drop by\n"
                                      "{[slap|hit} {Person}\n\n"
                                      "SOMETHINGELSE\n"
                                      "wait for {[me|you}\n"
                                      "start playing {[an|the|her} electric wah-wah guitar{[ very loudly}\n\n\n\n",
                                  style: GoogleFonts.notoSansMono(
                                      color: ithildin,
                                      fontSize: 13 * scaling,
                                      fontWeight: FontWeight.w500)),
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
              MaterialPageRoute(builder: (context) => const AboutVoc3()),
            );
          }),
    );
  }
}
