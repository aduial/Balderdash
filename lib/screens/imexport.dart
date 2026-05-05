import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Imexport extends StatelessWidget {
  const Imexport({super.key});
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
          "Fixing issues",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: ithildin,
              fontWeight: FontWeight.w500,
              fontSize: 18 * scaling),
        ),
      ),
      backgroundColor: blueTop,
      body: SafeArea(
        bottom: false,
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
      <p>This is all explained on the im/export page itself .</p>
      
  """;


final balderDashFont = GoogleFonts.merriweatherSans().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;
