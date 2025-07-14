import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/help.dart';

class How2 extends StatelessWidget {
  const How2({super.key});

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
          "How Balderdash! works (2)",
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
                          20 * toScale, 0, 20 * toScale, 30 * toScale),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text: "As can be imagined, this can become quite a convoluted "
                                  "leapfrog journey across vocabularies, and the results of a "
                                  "well-written grammar (set of vocabularies) can be truly "
                                  "surprising - Nonsense! can produce combinations of phrases "
                                  "(and, for the truly bold & brave: new words from separate "
                                  "syllables or even letters) that you would never have "
                                  "thought of.\n\n",
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
                                        "In that sense, Nonsense! is way more creative and free than "
                                        "any AI, that obediently regurgitates content found elsewhere. "
                                        "It walks the narrow path between meaningless chaos and "
                                        "boring copy-pasting, and it is up to you, as user, to find it.\n\n"
                                        "Copy-pasting and generating chaos are simple; compiling text "
                                        "alternatives, crafting phrase patterns and using state variables "
                                        "as contextual cement to produce a great grammar that leaves you "
                                        "in stitches is hard, but immensely rewarding.\n\n"
                                        "And, of course, it's a magnificent brain workout and a well-deserved "
                                        "slap in the face of Big-Buck 'generative AI'.",
                                    style: TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "",
                                    style: TextStyle(fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                        ),
                      )
                  ),
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
          onPressed: ()  {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Help()),
            );
          }),
    );
  }
}