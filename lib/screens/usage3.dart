import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/screens/help.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Usage3 extends StatelessWidget {
  const Usage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "Using the app (3)",
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
                        20 * scaling, 0, 20 * scaling, 30 * scaling),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: "The ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: ithildin,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13 * scaling),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Run Balderdash! ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: redNotePaperColour)),
                              TextSpan(
                                  text: "screen looks like the ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: "Vocabularies ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: greenNotePaperColour)),
                              TextSpan(
                                  text:
                                      "screen but, apart from using the search bar, the list "
                                      "can also be filtered on Project and Category using the "
                                      "gear icon top right. This opens a drawer similar to the "
                                      "menu drawer where you can select those filters. When one "
                                      "or both filters are active it is indicated underneath the "
                                      "search bar. Note that Vocabularies from the Library "
                                      "project are always listed. When you filter on a project, "
                                      "Library vocabularies are listed below the Project's own "
                                      "Vocabularies.\n\n",
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
        //),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.fast_rewind_rounded),
          label: const Text('Help'),
          foregroundColor: ithildin,
          backgroundColor: sortOfRed,
          // child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Help()),
            );
          }),
    );
  }
}
