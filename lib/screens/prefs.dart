import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';

class Prefs extends StatelessWidget {
  const Prefs({super.key});

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
          "Preferences",
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
                                  "Category 'none' means indeed 'No Category', but "
                                  "explicitly so: filtering on Category 'none' will list "
                                  "Vocabularies of ALL Categories (including 'none'). "
                                  "However, if you assign a Vocabulary to Category 'none', "
                                  "it will NOT show up when filtering on other Categories.\n\n"
                                  "Project 'Library' behaves in the same way. Also note "
                                  "that clearing the Category or Project filter sets them "
                                  "to 'none' and 'Library' respectively.\n\n"
                                  "Setting these filters in the 'Run Balderdash' screen's "
                                  "drawer persists until you tap the back button to return "
                                  "to the main menu.\n\nIf you want to set a default Project "
                                  "and/or Category filter that persist, you can do so in "
                                  "in the Preferences screen. These will be used as default "
                                  "filter in the 'Run Balderdash' screen. You can still change "
                                  "them in the filter drawer, but will apply each time you open "
                                  "'Run Balderdash' until cleared in the preferences screen.\n\n\n\n\n",
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
                                    style: TextStyle(fontWeight: FontWeight.w600)),
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
