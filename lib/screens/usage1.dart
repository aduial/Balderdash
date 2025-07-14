import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/usage2.dart';

class Usage1 extends StatelessWidget {
  const Usage1({super.key});

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
          "Using the app(1)",
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
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: "We put some effort telling you about ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * toScale),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Vocabularies ",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: greenNotePaperColour)),
                              TextSpan(
                                  text:
                                      "because they're the most important part of the app. \n"
                                      "Still there's a bit more to it: there are the ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Templates ",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: violetNotePaperColour)),
                              TextSpan(
                                  text:
                                      "that you can use to show off your Balderdash! to the world, "
                                      "up to an entire website that shows new content on every reload. "
                                      "There's more about that on the ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                  "CGI deployment ",
                                  style: TextStyle(fontWeight: FontWeight.w400,
                                      color: brightGreen)),
                              TextSpan(
                                  text:
                                  "help page (TBD).\n\nSince Balderdash! uses a SQLite database instead "
                                  "of plain text .data files, it made sense to add some structure "
                                  "so you can find your stuff back, share a project with another "
                                  "Balderdash! user, etcetera. We'll briefly walk you through "
                                  "that below.\n\n",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),

                              TextSpan(
                                  text:
                                      "Vocabularies ",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: greenNotePaperColour)),
                              TextSpan(
                                  text: "have a (one) ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Category ",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                          color: cyanNotePaperColour)),
                              TextSpan(
                                  text:
                                      "(eg. Adjective, Noun, Phrase ...) These are convenience "
                                      "labels that you can use to keep track of your Vocabularies; "
                                      "they don't influence how Balderdash! works. There's "
                                      "about twenty defined in the database and you can add "
                                      "as many as you like, or delete them. Categories can be "
                                      "nested by specifying a Parent Category in the Category "
                                      "detail screen, so you can refine "
                                      "your Categories as much as you want.\n\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text:
                                      "(continued ...) \n\n\n\n\n\n\n\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
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
        //),
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
                  builder: (context) => const Usage2()),
            );
          }),
    );
  }
}
