import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fixing extends StatelessWidget {
  const Fixing({super.key});

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
          "Fixing issues",
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
                                  "We've tested this app with all included examples and they "
                                  "all work. However, if you go write your own grammars (as "
                                  "you should), you will certainly run into things not working "
                                  "as hoped. Using the Perl version of Nonsense it could be hard "
                                  "to pinpoint the cause of a problem because of the large .data "
                                  "files, and this app is hopefully a bit easier.\n\n"
                                  "Because of the recursive processing it's easy to get "
                                  "stuck in endless loops so we took some care to catch those. \n"
                                  "If that happens you will see an 'Endless loop detected' "
                                  "message instead of the expected Balderdash - sometimes with an "
                                  "indication where the problem occurred. But not always. The most common "
                                  "issues include having two {{ or }} instead of {command}.\n"
                                  "It's possible that some sequence of characters (eg %#2-@?) cannot "
                                  "be matched with any of the expected commands, so those are the first "
                                  "things to check for.\n\n"
                                  "Calling a non-existing vocabulary will give a clear error, "
                                  "though. A good way to start your search is to isolate the first line "
                                  "in your vocabulary by adding a return after it. Remember you can "
                                  "always run any downstream vocabulary in isolation to see if it works, "
                                  "except when it contains state variables that have not been set upstream.\n\n",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: ithildin,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13 * toScale),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "\n\n\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
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
