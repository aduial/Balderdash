import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

class Vocabularies extends StatelessWidget {
  const Vocabularies({super.key});
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
                                backgroundColor: const Color.fromARGB(0x50, 0x77, 0xff, 0xff),
                              ),
                              "th": Style(
                                padding: HtmlPaddings.all(6),
                                backgroundColor: Colors.grey,
                              ),
                              "td": Style(
                                padding: HtmlPaddings.all(6),
                                border: const Border(bottom: BorderSide(color: Colors.grey)),
                              ),
                              'h5': Style(
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis
                              ),
                              ".second-table": Style(
                                backgroundColor: Colors.transparent,
                              ),
                              ".second-table tr td:first-child": Style(
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.end,
                              ),
                              "p.fix": Style(
                                padding: HtmlPaddings.all(6),
                                fontFamily: vocabFont,
                                color: laurelin,
                                fontSize: FontSize(15, Unit.px),
                                backgroundColor: const Color.fromARGB(0x50, 0x40, 0x80, 0xff),
                                fontWeight: FontWeight.bold,
                              ),
                            },
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
<h2>What is a Vocabulary?</h2>
<p>A Vocabulary is a named group of one to many lines containing plain text and 
{commands} between curly braces. These commands can be references to other 
vocabularies, inline alternatives (anonymous vocabularies), state variables, 
formatted date/time, numbers or special characters. </p>

<p>We'll describe all that here, so just keep a-scrolling until you reach the 
bottom.</p>

<p>Lines can be any length, and must be separated by a newline (return / linefeed) character.</p>

<p>A vocabulary can’t be empty: empty lines and anything below them are ignored 
(useful for testing a line: put it on top and add a return after it).</p>
<p>A vocabulary title must be unique within a project.</p>

<p>Vocabularies can be set active or inactive in the editor: when inactive, 
vocabularies are ignored by Balderdash! and appear greyed out in the 
'Run Balderdash! and vocabulary editor lists.</p>

<h2>Example Vocabulary</h2>

<p>Consider this example:</p>

<p class="fix">START<br>
{^Whoknows} {Person} {Dothis} {sometime}<br><br>
WHOKNOWS<br>
Maybe<br>
if nothing comes between, <br>
If we don't fix that stereo set, <br>
<br>
PERSON<br>
Charles<br>
neighbour Todd<br>
auntie Bertha<br>
<br>
SOMETIME<br>
Tomorrow<br>
Next week<br>
One of these days<br>
<br>
DOTHIS<br>
{maybe} {something}<br>
{surely} {somethingelse}<br>
<br>
MAYBE<br>
could<br>
might<br>
<br>
SURELY<br>
will<br>
might{[ instead}<br>
<br>
SOMETHING<br>
start sneezing<br>
drop by<br>
{[slap|hit} {Person}<br>
<br>
SOMETHINGELSE<br>
wait for {[me|you}<br>
start playing {[an|the|her} electric wah-wah guitar{[ very loudly}</p>

<h2>Anonymous Vocabularies</h2>

<p>Maybe you noticed these in the example:</p>

<p class="fix">{[me|you} {[an|the|her} {[ very loudly}</p>

<p>These <b>Anonymous Vocabularies</b> act like inline mini-vocabularies. They start with 
a curly bracket and a left square bracket <b>{[</b>, close with a right curly bracket <b>}</b>, 
with alternatives separated by a pipe <b>|</b> character. Balderdash! randomly picks 
one of the alternatives. When just s single choice is given:</p>
<p class="fix">{[50% chance of me showing up}</p>
<p>... it has a 50% chance of being selected. With more than one choice, chances 
are equally distributed. You can tweak the odds by duplicating words and/or adding empty terms. 
These are not ignored as in regular Vocabularies, so you can use:</p>

<p class="fix">{[|||Tom|Harry|Harry}</p>

<p><b>|||</b> represents three 'empty strings'; and with one <b>Tom</b> and two <b>Harry</b>'s 
there's six choices in total, meaning there's a 50% chance this anonymous vocabulary 
produces <b>''</b> (nothing); one in three of <b>'Harry'</b> and one in six of <b>'Tom'</b>.</p>


<h2>Text case</h2>

<p>Vocabulary START of the example grammar started with: <b>{^Whoknows}</b>, which 
referred to vocabulary <b>WHOKNOWS</b>. </p>
<p>Vocabulary titles are always <b>UPPERCASE</b>, 
but the case of the <b>{commands}</b> referring to them determines the case of the 
text they return:</p>

<p class="fix">{Whoknows}</p>
<p><b>(mixed case)</b> returns the case unchanged: <b>'If we don't fix that stereo set,'</b></p>
<p class="fix">{whoknows}</p>
<p><b>(all lowercase)</b> returns the text in lowercase: <b>'maybe'</b></p>

<p class="fix">{WHOKNOWS}</p> 
<p><b>(all UPPERCASE)</b> returns the text in UPPERCASE:<b>'MAYBE'</b></p>

<p class="fix">{^Whoknows}</p> 
<p><b>(prefixed with ^)</b> returns the text with the first letter capitalised:
<b>'If nothing comes between,'</b></p>

So, the example grammar might result in: 
'If nothing comes between, Charles might slap neighbour Todd next week'
'Maybe neighbour Todd could drop by tomorrow'
'If we don't fix that stereo set, auntie Bertha might start playing her electric wah-wah guitar very loudly one of these days'
... or some variation thereof.


VariablesTo preserve a semblance of context amidst the random chaos, Balderdash! offers variables. These contain either fixed text or the result of a {command} and once set, they can be recalled as often as needed until Balderdash! reaches the end of the starting vocabulary:

{var1=some text} stores 'some text'  in variable \$var1

{var2:=command} stores the result of command in variable \$var2

SETTING state variables does not add text to the result. To GET text from a variable, put it between curly brackets prefixed with a dollar sign: {\$var1} {\$var2} after you have set them.
It's best practice to set all variables together in a dedicated one-line vocabulary, and call that in the starting vocabulary. Note that case formatting also works for variables; it is applied when you read them, eg. {\$var} {\$VAR} {\$Var} {\$^var} - see the previous page.

A variable prefixed with TWO dollar signs: {\$\$var1} {\$\$var2} functions as a pointer: its value is interpreted as a Vocabulary name, allowing for interesting dynamic behaviour.


Numbers and repetitionsBalderdash! will replace this command:
{#number1-number2}(whole numbers only!)
with a random whole number between number1 and number2 (inclusive).

When processing a vocabulary, Balderdash! randomly picks one of the lines. However, you can influence the odds a line is selected by prefixing the line with a weight factor #number# (a whole number), for instance:
...
random chance being picked
#2#twice as {often}
#7#seven times as {[likely|often}
...
This goes for all lines regardless their content.

You can have Balderdash! evaluate a command multiple times using this format:
{command#number1-number2}(whole numbers only!)
which will repeat it a random whole number between number1 and number2 (inclusive) times. This is especially useful in starting (bootstrap) vocabularies.



Special characters & strftimeA \
 newline (return / linefeed), curly brackets {} and NULL a.k.a. 'nothing') can be included in a Vocabulary like this:

{\
} newline (return / linefeed)
{\\L} {\\R} left & right curly braces
{\\0} Null (i.e. nothing)

Last but not least, we pay homage to the good old strftime datetime format that was so harshly deprecated in php 8.1. Hah! With that, Balderdash! may be the only IOS app that supports it. You can use:
{@strftime format} e.g. {@%Y}
that returns the current date & time; or:
{@strftime format|number1|number2} e.g.
{@%H:%M:%S|0|86400} (... whole numbers!)

The latter returning a timestamp between number1 and number2 seconds ago (ie. one day), of which original Nonsense author James Baughn says it is 'actually more useful than it might first appear…' though I haven't been able to discover what that is about. A strftime format cheat sheet is available on
https://strftime.org/.
</p>   
  """;


final balderDashFont = GoogleFonts.inter().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;

final staticAnchorKey = GlobalKey();
