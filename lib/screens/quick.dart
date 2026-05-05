import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Quick extends StatelessWidget {
  const Quick({super.key});
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
          "Quick start guide",
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
                              if (element.classes.contains('ylw')){
                                return {'color': '#FFEF40'};
                              } else if (element.classes.contains('greentp')){
                                return {'color': '#BAFFBC'};
                              } else if (element.classes.contains('violntp')){
                                return {'color': '#C090FF'};
                              } else if (element.classes.contains('brigrn')){
                                return {'color': '#97FFCD'};
                              } else if (element.classes.contains('cyantp')){
                                return {'color': '#83FFFF'};
                              } else if (element.classes.contains('orantp')){
                                return {'color': '#FFA265'};
                              } else if (element.classes.contains('bluntp')){
                                return {'color': '#78B1FF'};
                              } else if (element.classes.contains('yelntp')){
                                return {'color': '#FCFF7F'};
                              } else if (element.classes.contains('redntp')){
                                return {'color': '#FF7F7F'};
                              }
                              return null;
                            },
                            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: balderDashFont,
                              fontWeight: FontWeight.w300,
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
      <p>TThe idea of this app doesn't go well with the TL;DR attitude, but if 
      you want to see how it works, try one of the included text-only demo's.</p>
      <p>Tap <b>Run Balderdash!</b> in the app menu, then tap the gear icon top right. 
      In the drawer that opens, check if the first box says <b>PROJECT</b> - if not 
      tap the X button to the right. Then check if the box below that says 
      <b>Bootstrap</b>; if not, tap it and select <b>Bootstrap</b> from the list.</p>
      <p>Tap on the list screen left if it hasn't already moved back. Find the item 
      called <b>KIFFAZ</b>. Tap the red triangle on its right and then the <b>play</b> 
      button on the next screen to see a list of alliterative poetic descriptions 
      of a former Scary Rock Band.</p>
      
      <p><b>EMBARRASSINGNAMES</b> generates embarrassing names, <b>WRITELC</b> 
      a Lovecraftian abomination, and <b>WRITESOME</b> advertises the latest Fantasy- and SF 
      book-titles. Try one of the <b>BLAHBLAHBLAH</b>'s if you need a snazzy 'Call 
      to Action' - or why not one of the dozen or so name generators?</p>
      <p>If you speak Dutch, try <b>BOEVEN</b>, <b>MEDILIST</b> or <b>AMGBOOKSERIE</b>.</p>
      <p>This app includes the original demo files from the Nonsense! perl script, 
      including several that use HTML or RDF templates to generate parody 
      versions of early geek-favourites like 
      <a href='https://web.archive.org/web/20000510013922/http://techdirt.com/'>Techdirt</a>, 
      <a href='https://web.archive.org/web/20010629214213/http://www.slashdot.org:80/'>Slashdot</a>, 
      <a href='https://web.archive.org/web/20010515230012/http://freshmeat.net/'>Freshmeat</a> 
      and Nonsense! creator's own website 
      <a href='https://web.archive.org/web/20010216043241/http://www.i-want-a-website.com/about-linux/'>
      Humorix</a> as they existed around 2001.</p>
     
      
  """;


final balderDashFont = GoogleFonts.merriweatherSans().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;
