import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Cgi extends StatelessWidget {
  const Cgi({super.key});
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
          "CGI deployment",
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
                              } else if (element.classes.contains('fix')){
                                return {
                                  'color': '#E2FFFE',
                                  'padding': '6px',
                                  'background-color': '#27466F',
                                  'font-family' : "$vocabFont",
                                  'font-size': '12px'
                                };
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
      <h3>Creating Balderdash websites</h3>
      <p>Balderdash created in this app can be run on a computer or even 
      deployed on a webserver. First, you need to export your project in <b>Nonsense</b> 
      format in the <b>'Export / import project'</b> screen.
      This will produce <b>project.data</b>, <b>default.data</b> (containing the 
      <b>Library</b> vocabularies) and the project's <b>template</b> files (if any).</p>

      <p>An updated version of 
      <a href="https://raw.githubusercontent.com/aduial/nonsense/refs/heads/master/nonsense.pl">Nonsense.pl</a> 
      (v0.7.1) that works on a webserver is available on 
      <a href="https://github.com/aduial/nonsense">this Github repository</a>, 
      together with the original examples and 
      <a href="https://raw.githubusercontent.com/aduial/nonsense/refs/heads/master/HOWTO.md">
      <b>HOWTO.md</b></a> documentation.</p>
      
      <p>Copy <b>nonsense.pl</b> to the folder 
      containing the <b>.data</b> files; if you have <b>Perl</b> installed you can then 
      create Balderdash on the command line like this:</p>

      <p class="fix">nonsense.pl -F garble</p>

      <p>... which will run the Vocabulary with title <b>garble</b> (if present in 
      <b>project.data</b> or <b>default.data</b>). Make sure <b>nonsense.pl</b> is executable, and 
      if it won't run you can try running it like this instead:</p>

      <p class="fix">./nonsense.pl -F garble<br>
      - or -<br>
      perl nonsense.pl -F garble</p>

      <p>If you want to create a balderdash/nonsense-driven web-page or RDF feed 
      on your webserver you need to create a <b>Template</b> for your page, where 
      commands like <b>{Garble}</b> will insert the output of Vocabulary <b>GARBLE</b> in 
      your page. 
      <a href="https://animatrice.nl/cgi-bin/yurp/nonsense.pl?template=yurpeana.html.template&allfiles=1">
      Here's an example</a> of a Nonsense-generated page (a parody of my 
      employer's <i>'Who's Who'</i> page).</p>

      <p>Make sure to read <b>HOWTO.md</b> for cgi parameters and check out the included 
      example templates. Your web server will need to have Perl cgi enabled; 
      check with your web host how to do that. Also, be prepared to handle 
      permissions issues.</p>

      <p>If there's a <b>cgi-bin</b> directory, create a folder for your project there 
      and upload <b>.data</b> files, <b>template(s)</b> and <b>nonsense.pl</b> all in there. <b>CSS</b> and 
      <b>images</b> best go in their own folders, just make sure the paths in the 
      <b>template</b> or <b>.data</b> files are correct.</p>

      <p>Your page's url will look something like this:<br><br>

      <b>https://your_domain.net/cgi-bin/project/nonsense.pl?template=project.html.template&allfiles=1</b></p>
      
      
      
     
      
  """;


final balderDashFont = GoogleFonts.merriweatherSans().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;
