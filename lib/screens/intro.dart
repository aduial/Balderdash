import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Intro extends StatelessWidget {
  Intro({super.key});

  Future<void>? _launched;

  final Uri _sourceForgeUrl = Uri.parse('https://nonsense.sourceforge.net/');
  final Uri _aduialUrl = Uri.parse('https://github.com/aduial/nonsense');

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "About this app",
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
                                  "This app is a continuation of a context-free grammar text generator "
                                  "from 2001 called ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: ithildin,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13 * scaling),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Nonsense",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: ", that you can still download from ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                  text: "nonsense.sourceforge.net",
                                  style: TextStyle(
                                      color: regularFormColour,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      _launched =
                                          _launchInBrowser(_sourceForgeUrl);
                                    },
                                ),
                                TextSpan(
                                    text:
                                        ".\nA slightly extended version 0.7.1 that fixes the issue "
                                        "with cgi-bin deployment and adds some minor features is available ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                  text: "here on Github",
                                  style: TextStyle(
                                      color: regularFormColour,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      _launched = _launchInBrowser(_aduialUrl);
                                    },
                                ),
                                TextSpan(
                                    text:
                                        ".\n\nNonsense defines the grammar in ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: ".data files",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: ", each containing many ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "vocabularies ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "(groups of lines containing text and commands). "
                                        "Balderdash! is fully compatible with grammars written "
                                        "for Nonsense. The original demo content is imcluded in "
                                        "this app. The difference is that this app doesn’t "
                                        "use .data files, but a local ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "SQLite ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "database.\n\nThis allows adding structure to the "
                                        "process with entities like 'users', 'categories' "
                                        "and 'projects' that you can use or ignore as you see fit. "
                                        "The smaller screen size gave rise to the ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text:
                                        "vocabulary ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: "as the basic unit of a grammar, instead of ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: ".data files ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                  text: "containing dozens of vocabularies each.\n\n"
                                        "How Balderdash! works, how to write vocabularies and managing "
                                        "projects in the app is all described in help pages.\n\n\n\n\n",
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
