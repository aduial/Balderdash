import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/about_voc6.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutVoc5 extends StatelessWidget {
  const AboutVoc5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "Variables",
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
                                "To preserve a semblance of context amidst the random chaos, "
                                "Balderdash! offers variables. These contain either fixed "
                                "text or the result of a {command} and once set, they can be "
                                "recalled as often as needed until Balderdash! reaches the end of "
                                "the starting vocabulary:\n\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * scaling),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "{var1=some text} ",
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
                                  text: " in variable ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "\$var1\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text: "{var2:=command} ",
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
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic)),
                              TextSpan(
                                  text: "in variable ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "\$var2\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "SETTING state variables does not add text to the result. To GET "
                                      "text from a variable, put it between curly brackets prefixed "
                                      "with a dollar sign: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{\$var1} {\$var2} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500,
                                      color: brightGreen)),
                              TextSpan(
                                  text: "after ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "you have set them.\nIt's best practice to set all variables "
                                      "together in a dedicated one-line vocabulary, and call that in the "
                                      "starting vocabulary. "
                                      "Note that case formatting also works for variables; it "
                                      "is applied when you read them, eg. ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "{\$var} {\$VAR} {\$Var} {\$^var} ",
                                  style: GoogleFonts.notoSansMono(
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: "- see the previous page.\n\n"
                                      "A variable prefixed with TWO dollar signs: ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "{\$\$var1} {\$\$var2} ",
                                  style: GoogleFonts.notoSansMono(
                                  fontWeight: FontWeight.w500,
                                  color: brightGreen)),
                              TextSpan(
                                  text:  "functions as a ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "pointer:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:  " its value is interpreted as a Vocabulary name, "
                                      "allowing for interesting dynamic behaviour.\n\n\n\n\n\n",
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
              MaterialPageRoute(builder: (context) => const AboutVoc6()),
            );
          }),
    );
  }
}
