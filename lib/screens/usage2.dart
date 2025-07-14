import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/usage3.dart';

class Usage2 extends StatelessWidget {
  const Usage2({super.key});

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
          "Using the app (2)",
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
                            text: "Next to a ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * toScale),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Category",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: cyanNotePaperColour)),
                              TextSpan(
                                  text:
                                  ", ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Vocabularies ",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: greenNotePaperColour)),
                              TextSpan(
                                  text:
                                      "also belong to a ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Project",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: orangeNotePaperColour)),
                              TextSpan(
                                  text:
                                  ". That's not just a label; it defines the scope "
                                      "of a Vocabulary. If you run Balderdash, it can find "
                                      "all Vocabularies under the same Project - AND - "
                                      "those from the project called 'Library' (#ID=1). "
                                      "There are several demo projects available in the app "
                                      "and you can add as many as device space permits. ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Projects",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: orangeNotePaperColour)),
                              TextSpan(
                                  text:
                                  ", in their turn, have an ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Author ",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: blueNotePaperColour)),
                              TextSpan(
                                  text:
                                  "(ie. you), and a ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Type ",
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: yellowNotePaperColour)),
                              TextSpan(
                                  text:
                                      "(Legacy, Examples ...).\n\n"
                                      "You'll find screens to manage all that listed in the main "
                                      "menu. These look very similar for the most part: there's "
                                      "a list view that can be filtered by entering text in "
                                      "the search bar on top. You can edit an entry by tapping the "
                                      "Pencil button, delete it with the Trash can button and "
                                      "add a new entry with the floating + button bottom right.\n\n"
                                      "The Edit screens of Vocabularies and Templates have a text "
                                      "editor with custom syntax highlighting, the other screens "
                                      "use simple textfields and drop-down selectors as in any "
                                      "form.\n\n\n(continued ...)\n\n\n\n\n\n",
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
          icon: const Icon(Icons.skip_next_rounded),
          label: const Text('Last!'),
          foregroundColor: ithildin,
          backgroundColor: sortOfRed,
          // child: const Icon(Icons.add),
          onPressed: ()  {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Usage3()),
            );
          }),
    );
  }
}
