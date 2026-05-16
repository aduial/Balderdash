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
      <p>TThe idea of this app doesn't go well with the TL;DR attitude, but if 
      you want to see how it works, try one of the included text-only demo's.</p>
      <p>Tap <b>Run Balderdash!</b> in the app menu, then tap the gear icon top right. 
      In the drawer that opens, check if the first box says <b>PROJECT</b> - if not 
      tap the X button to the right. Then check if the box below that says 
      <b>Bootstrap</b>; if not, tap it and select <b>Bootstrap</b> from the list.</p>
      <p>Tap on the list screen left if it hasn't already moved back. Find the item 
      called <b>KIFFAZ</b>. Tap the red triangle on its right and then the <b>play</b> 
      button on the next screen to see a list of alliterative poetic descriptions 
      of a former Scary Rock Band. Other example vocabularies included:</p>
     
      <h3>Example vocabularies</h3>
      <p>The following name vocabularies are for the most part compiled from 
      publicly available online lists: <b>AFR_NAMES</b> (partly uses AMAZOKUWEWORDS), 
      <b>ASIA_NAMES</b>, <b>CHINA_NAMES</b>, <b>DUTCH_NAMES</b> (partly made up on the spot), 
      <b>ENG_NAMES</b>, <b>FRA_NAMES</b>, <b>GERMAN_NAMES</b>, <b>JAPAN_NAMES</b>,
      <b>PORTUGUESE_NAMES</b>, <b>SCAN_NAMES</b> and <b>SPA_NAMES</b>.</p>
      
      <p>The rest is quite different. These mostly use separate phoneme vocabularies 
      combined to create words resembling a certain language, to achieve a specific 
      (comedic) effect or for playful deconstructionism (a.k.a. Emperor Disrobement): 

      <ul>
      <li><b>AMAZOKUWEWORDS></b> is inspired by magnificent words like "Amazakué" 
      (a type of tropical hardwood)</li>
      <li><b>ANNIEMGNAMES</b> attempting to generate character names like those 
      found in the stories by Annie M.G. Schmidt</li>
      <li><b>BEDRIJVEN</b> nonsensical company names, Dutch oriented</li>
      <li><b>DUTCH_SILLYNAMES</b> resembling real names, but more wacky</li>
      <li><b>FATWANTPIEGSTRIX</b> ludicrous Dutch-sounding names created by combining
      two syllables, named after prototype <i>Fatwant Piegstrik</i>, <b><i>retesnelle chick</i></b>
      at Hipster Trajectory Designer <b>Toc-Toc</b></li>
      <li><b>SNAZIAKIPPEKIPPES</b> ludicrous Dutch-sounding names created by combining
      multiple separate phonemes, after prototype <i>Snaziak Ippekippe</i>, 
      Hipster Trajectory Designer <b>Toc-Toc</b>'s <b><i>Account Scratcher</i></b></li>
      <li><b>FATWANTIPPEKIPPES</b> and <b>SNAZIAKPIEGSTRIX</b> are superpositions
      of the two above</li>
      <li><b>JACKVANCENAMES</b> generates a list of character names reminiscent of
      those found in Jack Vance's fantastical SF stories</li>
      <li><b>FINNWORDS</b> early attempt to create Finnish-looking words. Needs more work.</li>
      <li><b>KRAKOEWORDS</b> fooling around with croaky gutteral-sounding phonemes 
      resulting in vaguely Orcish or Klingon-ish words. Probabl overuses the circonflex
      accent.</li>
      <li><b>MANAMAWORDS</b> using a limited set of phonemes with a lot of repetition,
      conjuring up memories of the Muppet-show</li>
      <li><b>SFBOOKLIST</b> creating mysterious-sounding SF book titles by combining
      concepts that don't fit together. Takes some inspiration from well-worn SF cliche's.</li>
      <li><b>WEIRDNAMES</b> pretty much self-explanatory</li>
      <li><b>WEIRDWORDS</b> likewise, but more so</li>
      <li><b>BV_MEDIGOED</b> A stab at playful deconstructionism, in this case of 
      a pharmaceutical company's PR attempts. In Dutch. Warning: may generate 
      repulsive descriptions, though aimed purely for comedic effect.</li>
      <li><b>MEDILIST</b> A list of slogans, from the above company.</li>
      <li><b>KIFFAZ</b> The A to Z of the Quadruple Cynosures of Meretriciously 
      Incommodious Stridency</li>
      <li><b>MAKIFF</b> One single line of the above</li>
      <li><b>FANTASY_SF_TITLES</b> Another attempt at Emperor Disrobement, 
      aimed at the kind of Fantasy that comes up with stuff like "the Garment of 
      Punishing", and at the sub-genre known as "grimdark" in particular. Throws
      in the occasional <b>Lovecraftian Abomination of the Day</b> by way of bonus.</li>
      <li><b>BLAHBLAHBLAH1-4</b> Check this out if you urgently need a snazzy 'Call
      to Action' in the Cultural Heritage Sector.</li>
      <li><b>ALIENNAMES</b> Well, that.</li>
      <li><b>AMGBOEKSERIE</b> Satirical: generates a series of children's book titles, 
      suggesting plots with increasing psychological complications as the audience
      grows up. In Dutch.</li>
      <li><b>APALLINGNAMES</b> As it says: an experiment with the most dreadful 
      phonemes. Be warned.</li>
      <li><b>BOEVEN</b> Names of Dutch criminals, as they appear in certain television
      series.</li>
      <li><b>CORPORATENAMES</b> TBD</li>
      <li><b>EMBARRASSINGWORDS</b> Almost as bad as APALLINGNAMES.</li>
      <li><b>NAAMEN</b> TBD</li>
      <li><b>SILLYNAMES</b> weird, but light-hearted. Safe.</li>
      </ul>
      </p>
     
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
