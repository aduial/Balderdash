import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class How extends StatelessWidget {
  const How({super.key});
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
          "How Balderdash works",
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
                          child: HtmlWidget(htmlData,
                            key: Key(htmlData),
                            onTapUrl: (url) {
                              _launchInBrowser(Uri.parse(url));
                              return true;
                            },
                            customStylesBuilder: (element) {
                              if (element.localName == 'a') {
                                return const {
                                  'color': '#40EFC4',
                                  'font-weight': 'bold',
                                  'text-decoration': 'none'
                                };
                              }
                              if (element.localName == 'li') {
                                return const {
                                  'font-weight': '400',
                                  'color': '#C0FEE8',
                                };
                              }
                              if (element.classes.contains('ylw')){
                                return {'color': '#FFEF40'};
                              } else if (element.classes.contains('greentp')){
                                return {'color': '#BAFFBC'};
                              } else if (element.classes.contains('violntp')){
                                return {'color': '#C090FF'};
                              } else if (element.classes.contains('brigrn')){
                                return {'color': '#90FF40'};
                              } else if (element.classes.contains('cyantp')){
                                return {'color': '#83FFFF'};
                              } else if (element.classes.contains('orantp')){
                                return {
                                  'font-weight': '900',
                                  'color': '#FFA265',
                                };
                              } else if (element.classes.contains('bluntp')){
                                return {'color': '#4B89FF'};
                              } else if (element.classes.contains('yelntp')){
                                return {'color': '#FFEF40'};
                              } else if (element.classes.contains('redntp')){
                                return {
                                  'color': '#FF4C4F',
                                  'font-weight': '900'
                                };
                              } else if (element.classes.contains('fix')){
                                return {
                                  'color': '#FFF7BC',
                                  'padding': '6px',
                                  'background-color': '#27466F',
                                  'font-family' : '"Lucida Console", "Courier New", monospace',
                                  'font-size': '12px',
                                  'font-weight': '600'
                                };
                              }
                              return null;
                            },
                            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: '"Segoe UI", Roboto, Helvetica, Arial, sans-serif',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: ithildin,
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}
const htmlData = r"""
      <p>The idea is that you provide <b>Balderdash!</b> with a bootstrap vocabulary, 
      say, <b>VOC1</b>. This provides Balderdash! with a starting point for your 
      grammar. Its 'Category' doesn't matter because that's just a label: all 
      vocabularies are processed in the same way.</p>
      <p>All vocabularies contain lines with text and commands between curly 
      braces {} that refer to other vocabularies (and perform some other functions 
      that we'll get into later).</p>
      <p>Balderdash! randomly selects a line from <b>VOC1</b> and starts working its 
      way through it. Any plain text it finds is added to the result. When a 
      command - say, <b>{VOC2}</b> - is encountered, work on <b>VOC1</b> is put on 
      hold. If it identifies <b>{VOC2}</b> as referring to another Vocabulary called 
      <b>VOC2</b>, it gets that from the database and starts working on that: 
      pick a line, add plain text to the result, until it either comes across 
      another variable (and the process repeats one level deeper). </p>
      <p>When Balderdash!  reaches the end of the current line, it returns to where 
      it left off and continues there. This goes on until Balderdash! reaches the 
      end of the line in the bootstrap vocabulary, and it presents whatever it 
      has collected.</p>
      <p>As can be imagined, this can become quite a convoluted leapfrog journey 
      across vocabularies, and the results of a well-written grammar (set of 
      vocabularies) can be surprising. Balderdash! can produce combinations 
      of phrases (and, for the bold & brave: new words from separate syllables 
      or even letters) that you would never have thought of.</p>
      <p>In that sense, Balderdash! is (or, really, YOU are) way more creative 
      and free than an AI that obediently regurgitates content found elsewhere.</p>
      <p>Balderdash! can walk the narrow path between meaningless chaos and boring 
      copy-pasting, but it is up to you, dear user, to lead the way.</p>
      <p>Copy-pasting and generating chaos are simple; compiling text alternatives, 
      crafting phrase patterns and using variables as contextual cement to produce 
      a grammar that leaves you in stitches is hard, but immensely rewarding.</p>
      <p>And, of course, it's a magnificent brain workout and a well-deserved 
      slap in the face of Big-Buck generative AI.</p>
     
      
  """;


final balderDashFont = GoogleFonts.merriweatherSans().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;
