import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/about_voc6.dart';

class AboutVoc5 extends StatelessWidget {
  const AboutVoc5({super.key});

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
          "State variables",
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
                            text: "To preserve a semblance of context amidst the random chaos, "
                                "Nonsense! offers State variables. These contain either fixed "
                                "text or the result of a {command} and once set, they can be "
                                "recalled as often as needed until Nonsense! reaches the end of "
                                "the starting vocabulary:\n\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * toScale),
                            children: <TextSpan>[
                               TextSpan(
                                  text: "{statevar1=some text} ",
                                  style: GoogleFonts.notoSansMono(
                                    fontWeight: FontWeight.w500,
                                    color: brightGreen)),
                              TextSpan(
                                  text: "stores ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "'some text' ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic)),
                              TextSpan(
                                  text: " in state variable ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "\$statevar1\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text: "{statevar2:=command} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "stores the result of ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "command ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic)),
                              TextSpan(
                                  text: "in state variable ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "\$statevar2\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "SETTING state variables does not add text to the result. To GET "
                                      "text from a state variable is done like this:\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{\$statevar1} {\$statevar2}\n\n",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "after ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "you have set them. It's best practice to set all state variables "
                                      "together in a dedicated one-line vocabulary, and call that in the "
                                      "starting vocabulary.\n"
                                      "Note that case formatting also works for state variables; it "
                                      "is applied when you read them, eg. \n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "{\$statevar} {\$STATEVAR} {\$StateVar} {\$^statevar} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500)), TextSpan(
                                  text:
                                  "- see the previous page.\n\n\n\n\n\n",
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
          onPressed: ()  {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AboutVoc6()),
            );
          }),
    );
  }
}
