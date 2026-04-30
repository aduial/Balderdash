import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

class Prefs extends StatelessWidget {
  const Prefs({super.key});
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
          "User preferences",
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
                          child: Html(
                            anchorKey: staticAnchorKey,
                            data: htmlData,
                            style: {
                              "p": Style(
                                color: ithildin,
                                fontSize: FontSize.medium,
                                lineHeight: const LineHeight(1.5),
                              ),
                              "ul": Style(
                                color: laurelin,
                                fontSize: FontSize.medium,
                                lineHeight: const LineHeight(1.5),
                              ),
                              "a": Style(
                                color: derivedFormColour,
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight(600),
                                textDecoration: TextDecoration.none,
                                lineHeight: const LineHeight(1.5),
                              ),
                              "body": Style(
                                fontFamily: balderDashFont,
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                color: ithildin,
                                fontSize: FontSize.medium,
                                lineHeight: const LineHeight(1.0),
                              ),
                              "table": Style(
                                backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                              ),
                              "th": Style(
                                padding: HtmlPaddings.all(6),
                                backgroundColor: Colors.grey,
                              ),
                              "td": Style(
                                padding: HtmlPaddings.all(6),
                                border: const Border(bottom: BorderSide(color: Colors.grey)),
                              ),
                              'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
                              "span.ylw": Style(
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.bold,
                              ),"span.greentp": Style(
                                color: greenNotePaperColour,
                                fontWeight: FontWeight.w700,
                              ),"span.violntp": Style(
                                color: violetNotePaperColour,
                                fontWeight: FontWeight.w800,
                              ),"span.brigrn": Style(
                                color: brightGreen,
                                fontWeight: FontWeight.bold,
                              ),"span.cyantp": Style(
                                color: cyanNotePaperColour,
                                fontWeight: FontWeight.bold,
                              ),"span.orantp": Style(
                                color: orangeNotePaperColour,
                                fontWeight: FontWeight.bold,
                              ),"span.bluntp": Style(
                                color: blueNotePaperColour,
                                fontWeight: FontWeight.bold,
                              ),"span.yelntp": Style(
                                color: yellowNotePaperColour,
                                fontWeight: FontWeight.bold,
                              ),"span.redntp": Style(
                                color: redNotePaperColour,
                                fontWeight: FontWeight.w700,
                              ),
                            },
                            extensions: [
                              TagWrapExtension(
                                  tagsToWrap: {"table"},
                                  builder: (child) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: child,
                                    );
                                  }),
                              TagExtension.inline(
                                tagsToExtend: {"bird"},
                                child: const TextSpan(text: "🐦"),
                              ),
                              TagExtension(
                                tagsToExtend: {"flutter"},
                                builder: (context) => CssBoxWidget(
                                  style: context.styledElement!.style,
                                  child: FlutterLogo(
                                    style: context.attributes['horizontal'] != null
                                        ? FlutterLogoStyle.horizontal
                                        : FlutterLogoStyle.markOnly,
                                    textColor: context.styledElement!.style.color!,
                                    size: context.styledElement!.style.fontSize!.value,
                                  ),
                                ),
                              ),
                              ImageExtension(
                                handleAssetImages: false,
                                handleDataImages: false,
                                networkDomains: {"flutter.dev"},
                                child: const FlutterLogo(size: 36),
                              ),
                              ImageExtension(
                                handleAssetImages: false,
                                handleDataImages: false,
                                networkDomains: {"mydomain.com"},
                                networkHeaders: {"Custom-Header": "some-value"},
                              ),
                            ],
                            onLinkTap: (url, _, __) {
                              _launchInBrowser(Uri.parse(url!));
                            },
                            onCssParseError: (css, messages) {
                              debugPrint("css that errored: $css");
                              debugPrint("error messages:");
                              for (var element in messages) {
                                debugPrint(element.toString());
                              }
                              return '';
                            },
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
      <h3>Default Project and Category filters</h3>
      <p>Setting the <b>Project</b> and <b>Category</b> filters in the <b>'Run 
      Balderdash'</b> and <b>Vocabularies</b> screen's right-side drawer persists 
      until you leave those screens. If you want the app to remember a filter, you 
      can set it in the <b>User Preferences</b> screen, where it will remain until you 
      change it again. These will then be used as default filter in the 
      <b>'Run Balderdash'</b> and <b>Vocabularies</b> screens.</p>
      <p>You can still change them in the filter drawer, but they will re-appear 
      each time you open these screens until cleared in the preferences screen.</p>
     
      <h3>Other preferences</h3>
      <p>With the switches below the default <b>Project</b> and <b>Category</b> 
      selectors you can enable or disable these functions:</p>
      <ul><li>Marking a vocabulary with an error by <span class="redntp">displaying 
      it in red</span> in the list, after you save it</li>
      <li>Show you a prompt when a vocabulary you save contains an error, allowing to 
      Cancel the save to fix the problem or to continue saving. It also indicates 
      what lines contain errors.</li>
      <li>Include the original demo content from the 2001 Nonsense script (especially 
      useful because it has several examples of RDF / HTML templates)</li>
      </ul>
      
      
      
     
      
  """;


final balderDashFont = GoogleFonts.inter().fontFamily;
final staticAnchorKey = GlobalKey();
