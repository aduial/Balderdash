import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

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
                          child: Html(
                            anchorKey: staticAnchorKey,
                            data: htmlData,
                            style: {
                              "p": Style(
                                color: ithildin,
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
                              'flutter': Style(
                                display: Display.block,
                                fontSize: FontSize(5, Unit.em),
                              ),
                              ".second-table": Style(
                                backgroundColor: Colors.transparent,
                              ),
                              ".second-table tr td:first-child": Style(
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.end,
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


final balderDashFont = GoogleFonts.inter().fontFamily;

final staticAnchorKey = GlobalKey();
