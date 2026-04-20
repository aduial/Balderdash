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
                                  "attitude but if you want to see how it works, try one of the included text-only demo's.\n",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: ithildin,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13 * scaling),
                              children: <TextSpan>[
                              TextSpan(
                                  text: "Tap ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "Run Balderdash!  ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: "in the app menu, then tap the gear icon "
                                  "top right. In the drawer that opens, check if the first box says ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "PROJECT",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: " - if not tap the X button to the right. "
                                        "Then check the 'Category' box below that says ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "Bootstrap",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: "; if not, tap it and select 'Bootstrap' from the list."
                                  "Tap on the list screen left if it hasn't already moved "
                                  "back. Find the item called ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "KIFFAZ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: ". Tap the red triangle on its right. Tap the 'play' button "
                                  "In the next screen to see a list of alliterative poetic descriptions of "
                                  "a rock band that cultivated a ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "'flirting with Evil' ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic)),
                                TextSpan(
                                    text: "image.\n",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "EMBARRASSINGNAMES ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: "generates embarrassing names, ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "WRITELC ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: "a Lovecraftian abomination of sorts, and ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "YURPBLAH ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: "is the Executive's best friend.\n\n"
                                  "If you speak Dutch, try ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "BOEVEN",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: ", ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "MEDINIX",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: " or ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "DUTCHNAMES.\n\n",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: "This app includes the original demo files from the ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "Nonsense! ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "perl script, including several that use HTML or RDF templates "
                                        "to generate parody versions of classic websites like ",
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
                                    text: " and Nonsense! creator's own website ",
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
                                    text: " as they existed around 2001.\n\n\n\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300))
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
