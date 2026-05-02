import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

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
                              'vocab': Style(
                                display: Display.block,
                                fontSize: FontSize(2, Unit.em),
                                fontFamily: balderDashFont,
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


final balderDashFont = GoogleFonts.inter().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;

final staticAnchorKey = GlobalKey();
