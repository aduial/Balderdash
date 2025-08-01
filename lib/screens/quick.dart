import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Quick extends StatelessWidget {
  Quick({super.key});

  Future<void>? _launched;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  final Uri _humorixUrl = Uri.parse(
      'https://web.archive.org/web/20010216043241/http://www.i-want-a-website.com/about-linux/');
  final Uri _freshMeatUrl = Uri.parse(
      'https://web.archive.org/web/20010515230012/http://freshmeat.net/');
  final Uri _techDirtUrl = Uri.parse(
      'https://web.archive.org/web/20000510013922/http://techdirt.com/');
  final Uri _slashDotUrl = Uri.parse(
      'https://web.archive.org/web/20010629214213/http://www.slashdot.org:80/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "Quickstart guide",
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
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20 * scaling, 0, 20 * scaling, 30 * scaling),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text:
                                  "The idea of this app doesn't go well with the TL;DR "
                                  "attitude but, oh, well.\n\nIf you like to see it working "
                                  "you best try one of the included demo's. There are the "
                                  "original examples from the ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: ithildin,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13 * scaling),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Balderdash! ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "app. Several of those work with a HTML or RDF template "
                                        "and generate a parody version of the ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                  text: "Techdirt",
                                  style: TextStyle(
                                      color: regularFormColour,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      _launched =
                                          _launchInBrowser(_techDirtUrl);
                                    },
                                ),
                                TextSpan(
                                    text: ", ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                  text: "Slashdot",
                                  style: TextStyle(
                                      color: regularFormColour,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      _launched =
                                          _launchInBrowser(_slashDotUrl);
                                    },
                                ),
                                TextSpan(
                                    text: ", ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                  text: "Freshmeat",
                                  style: TextStyle(
                                      color: regularFormColour,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      _launched =
                                          _launchInBrowser(_freshMeatUrl);
                                    },
                                ),
                                TextSpan(
                                    text: " or Nonsense! creator's own site ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                  text: "Humorix",
                                  style: TextStyle(
                                      color: regularFormColour,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      _launched = _launchInBrowser(_humorixUrl);
                                    },
                                ),
                                TextSpan(
                                    text: " as they were around 2001.\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text:
                                        "It's much easier to start with regular text Balderdash. "
                                        "Tap 'Run Balderdash! in the app menu. This opens a "
                                        "long list: tap the gear icon top right. Tap CATEGORY "
                                        "in the drawer that opens and choose 'Bootstrap' from "
                                        "the list. Halfway down you'll see 'KIFFAZ' - go ahead "
                                        "and tap the red triangle on its right. The 'Run KIFFAZ' "
                                        "screen opens: go ahead and tap the play button.\n"
                                        "What you're seeing is a list of alliterative poetic "
                                        "descriptions of a rock band that cultivated a "
                                        "'flirting with Evil' image.\nEMBARRASSINGNAMES is "
                                        "testing the emotional charge of certain letter "
                                        "combinations, WRITELC (tries to) produce a Lovecraftian "
                                        "abomination and YURPBLAH is about snazzy hollow phrases.\n\n"
                                        "If you speak Dutch, try 'BOEVEN, MEDINIX or 'DUTCHNAMES'.\n\n\n\n\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
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
