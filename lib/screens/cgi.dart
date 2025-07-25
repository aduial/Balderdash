import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Cgi extends StatelessWidget {
  Cgi({super.key});

  final Uri _yurpUrl = Uri.parse(
      'https://web.archive.org/web/20010216043241/http://www.i-want-a-website.com/about-linux/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ithildin,
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "CGI Deployment",
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
                                  "Balderdash created in this app can be run on a "
                                  "computer or even deployed on a webserver. First, you "
                                  "need to export your project in Nonsense format "
                                  "in the 'Export / import project' screen.\nThis will "
                                  "produce ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: ithildin,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13 * scaling),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "project.data",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: ", ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "default.data",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        " (with the Library vocabularies), the project's template "
                                        "files and ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "nonsense.zip",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: " (containing a copy of nonsense.pl "
                                        "+ original HOWTO.md and README.md files). Unzip this, "
                                        "and copy everything to a folder on your computer. If "
                                        "you have Perl installed you can then create Balderdash "
                                        "on the command line like this:\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "nonsense.pl -F garble\n\n",
                                    style: GoogleFonts.notoSansMono(
                                        color: ithildin,
                                        fontSize: 13 * scaling,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text:
                                        "... which will run the Vocabulary with title "
                                        "'garble' (if present in project.data or default.data, "
                                        "of course). Make sure nonsense.pl is executable, and "
                                        "if it won't run you can try running the script like this:\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "./nonsense.pl -F garble\n",
                                    style: GoogleFonts.notoSansMono(
                                        color: ithildin,
                                        fontSize: 13 * scaling,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: "- or -\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "perl nonsense.pl -F garble\n\n",
                                    style: GoogleFonts.notoSansMono(
                                        color: ithildin,
                                        fontSize: 13 * scaling,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: "If you want to create a balderdash/"
                                        "nonsense-driven web-page or RDF feed on your webserver "
                                        "you need to create a ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "Template",
                                    style: TextStyle(
                                        color: violetNotePaperColour,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        " for your page, where commands like {Garble} will "
                                        "insert the output of Vocabulary 'garble' in your page. ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                  text: "Here's",
                                  style: TextStyle(
                                      color: regularFormColour,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (!await canLaunchUrl(_yurpUrl)) {
                                        throw Exception(
                                            'Could not launch $_yurpUrl');
                                      }
                                    },
                                ),
                                TextSpan(
                                    text:
                                        " an example of a Nonsense-generated page (a parody "
                                        "of my employer's 'Who's Who' page).\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text:
                                        "Make sure to read HOWTO.md for cgi parameters and "
                                        "check out the included example templates.\n"
                                        "Your web server will need to have Perl cgi enabled; "
                                        "check with your web host how to do that. Also, be "
                                        "prepared to handle permissions issues.\n\n"
                                        "If there's a 'cgi-bin' directory: create a folder for your project "
                                        "there and upload .data files, template(s) and nonsense.pl "
                                        "all in there. CSS and images best go in their own folders, "
                                        "just make sure the path in the template or .data files "
                                        "is correct.\n\nYour page's url will look something like this:\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "https://your_domain.net/"
                                        "cgi-bin/project/nonsense.pl?template=project.html.template&allfiles=1\n\n",
                                    style: GoogleFonts.notoSansMono(
                                        color: ithildin,
                                        fontSize: 13 * scaling,
                                        fontWeight: FontWeight.w500)),
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
