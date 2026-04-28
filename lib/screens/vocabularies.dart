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
                              "ul": Style(
                                color: laurelin,
                                fontSize: FontSize.medium,
                                lineHeight: const LineHeight(1.3),
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

<ul>
<li>Lines can be any length, and must be separated by a newline (return / linefeed) character.<br></li>
<li>A vocabulary can’t be empty: empty lines and anything below them are ignored 
<i>(useful for testing a line: put it on top and add a return after it).</i><br></li>
<li>A vocabulary title must be unique within a project.<br></li>
<li>Vocabularies can be set active or inactive in the editor: when inactive, 
vocabularies are ignored by Balderdash! and appear greyed out in the 
'Run Balderdash! and vocabulary editor lists.<br></li>
</ul>

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
start playing {[an|the|her} electric wah-wah guitar{[ very menacingly}</p>

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
<p><b>(Mixed Case)</b> returns the case unchanged: <b>'If we don't fix that stereo set,'</b></p>
<p class="fix">{whoknows}</p>
<p><b>(all lowercase)</b> returns the text in lowercase: <b>'maybe'</b></p>

<p class="fix">{WHOKNOWS}</p> 
<p><b>(all UPPERCASE)</b> returns the text in UPPERCASE:<b>'MAYBE'</b></p>

<p class="fix">{^Whoknows}</p> 
<p><b>(prefixed with ^)</b> returns the text with the first letter capitalised:
<b>'If nothing comes between,'</b></p>

<p>The example grammar might result in: </p>
<ul><li>'If nothing comes between, Charles might slap neighbour Todd next week'</li>
<li>'Maybe neighbour Todd could drop by tomorrow'</li>
<li>'If we don't fix that stereo set, auntie Bertha might start playing her 
electric wah-wah guitar very menacingly one of these days'</li></ul>
<p>... or some variation thereof.</p>

<h2>Variables</h2>
<p>To maintain some context amidst the random chaos that contex-free grammars 
are habitually prone to, Balderdash! provides (state) variables that create 
blissful oases of sanity, ready at hand when you need them.</p> 
<p>Variables are created by assigning them a value from either a fixed string, 
or from a {command} (e.g. the output of a vocabulary). Once set, they can be 
recalled as often as needed until Balderdash! reaches the end of the starting 
vocabulary:</p>

<p class="fix">{var1=some text}</p> 
<p>stores <b>'some text'</b>  in variable <b>$var1</b><p>

<p class="fix">{var2:=command}</p>  
<p>stores the result of <b>command</b> in variable <b>$var2</b><p>

<p>Setting state variables does not directly add text to the result.</p>
<p>To add the content of a variable to the result, put it between curly braces 
prefixed with a dollar sign:<p>

<p class="fix">{$var1} {$var2}</p>
<p><i><b>after</b></i> you have set them.</p>

<h3>Pointers</h3>

<p>If a variable is read prefixed by two dollar signs:</p>
<p class="fix">{$$var1}</p>
<p>(a <b>pointer</b>) it's interpreted as a <b>command</b> referring to a 
<b>Vocabulary</b>. This allows creating interesting dynamic behaviour, but be 
warned that it can make things <i>really</i> complex  <i>really</i> fast.</p>
<p>To give a very basic example:</p>

<p class="fix">POINTERDEMO<br>
{Fixpplwords}{$Name} is my {$person}<br>
{Fixpplwords}{$$Name} is {$$person}<br>
<br>
FIXPPLWORDS<br>
{Name:=Malename}{Person:=Maleperson}<br>
{Name:=Femalename}{Person:=Femaleperson}<br>
<br>
MALENAME<br>
John<br>
Robert<br>
Giovanni<br>
<br>
JOHN<br>
Johnny<br>
Jan<br>
Yannis Papadopoulos<br>
<br>
ROBERT<br>
Roberto<br>
Robbie<br>
Rob<br>
<br>
GIOVANNI<br>
Iohan<br>
<br>
MALEPERSON<br>
uncle<br>
nephew<br>
grandpa<br>
<br>
UNCLE<br>
an uncle-of-sorts<br>
actually called Ranucle<br>
my German 'Onkel'<br>
<br>
NEPHEW<br>
my most untrustworthy familymember<br>
my best friend<br>
kind of a German 'Dieter'<br>
<br>
GRANDPA<br>
a blunderbuss-wielding old-timer grandpa<br>
an ancestor<br>
my hero<br>
<br>
FEMALENAME<br>
Petra<br>
Purkje<br>
Eline<br>
<br>
PETRA<br>
Petraya<br>
Pie-traa<br>
Mrs. P<br>
<br>
PURKJE<br>
Pien<br>
Petronella<br>
Plien<br>
<br>
ELINE<br>
Vere<br>
Klapsie<br>
<br>
FEMALEPERSON<br>
aunt<br>
niece<br>
maternal grandma<br>
<br>
AUNT<br>
affectionally called "tantetje"<br>
my mother<br>
really something else<br>
<br>
NIECE<br>
a nice niece<br>
actually my mother's neigbour lady<br>
known by some as "Noes"<br>
<br>
GRANDMA<br>
Mrs.-Grandma-to-you<br>
a true "Grammy Award"
</p>

<p>The first line in <b>POINTERDEMO</b> could produce:</p>
<p><b>Giovanni is my grandpa<br>
Eline is my niece</b> (etcetera)</p>
<p>while the second line might give:</p>
<p><b>Yannis Papadopoulos is my most untrustworthy familymember<br>
Rob is my blunderbuss-wielding old-timer grandpa<br>
Petronella is really something else<br>
Klapsie is my mother's neighbour lady</b> (etcetera)</p>

<p>Just sayin' ... you best understand the above before you start messing around with
it. And this is just one level of pointers: there's nothing stopping you from
using them in, say, <b>MALENAME</b> - but let me stop here, before people get
funny ideas about warping reality or messing with the Noosphere (or what have you) 
- let's leave that to the good folk of the <a href="https://scp-wiki.wikidot.com/">
SCP wiki</a>.</p>

<p>It's best practice to set all variables together in a dedicated one-line 
vocabulary, and call that in the starting vocabulary. Note that case formatting 
also works for variables; it is applied when you read them, eg.</p>

<p class="fix">{$var} {$VAR} {$Var} {$^var}</p>

<p> - see above under <b>Text case</b> for the details.</p>

<h2>Numbers and repetitions</h2>

<p>Balderdash! will replace this command:</p>
<p class="fix">{#number1-number2}</p>
<p><b>(whole numbers only!)</b> with a random whole number between <b>number1</b> 
and <b>number2</b> (inclusive).</p>

<p>When processing a vocabulary, Balderdash! randomly picks one of the lines. 
However, you can influence the odds a line is selected by prefixing the line 
with a weight factor <b>#number#</b> (a whole number), for instance:</p>

<p class="fix">...<br>
random chance being picked<br>
#2#twice as {often}<br>
#7#seven times as {[likely|often}<br>
...</p>

<p>This goes for all lines regardless their content.</p>

<p>You can have Balderdash! evaluate a command multiple times using this format:</p>
<p class="fix">{command#number1-number2}</p>
<p><b>(whole numbers only!)</b> which will repeat it a random whole number between 
<b>number1</b> and <b>number2</b> (inclusive) times.
<br>This is especially useful in starting (bootstrap) vocabularies.</p>


<h2>Special characters & strftime</h2>
<p>A newline (return / linefeed), curly brackets {} and NULL a.k.a. 'nothing' can 
be included in a Vocabulary like this:</p>

<p class="fix">{\n}</p>
<p> = newline (return / linefeed)</p>
<p class="fix">{\\L} {\\R}</p>
<p> = left & right curly braces</p>
<p class="fix">{\\0}</p> 
<p> = nothing, empty string</p>

<p>Last but not least, we pay homage to the good old <b>strftime</b> datetime format 
that was so harshly deprecated in php 8.1.<br>
Hah! With that, Balderdash! may be the only IOS app that supports it.
Use the simple <b>{@strftime format}</b> as in, for instance,</p>

<p class="fix">{@%Y}</p>
<p>to return the current date & time; and together with a numerical range
<b>{@strftime format|number1|number2}</b> e.g.</p>
<p class="fix">{@%H:%M:%S|0|86400}</p> 
<p>(... whole numbers only!) if you want a timestamp between <b>number1</b> and 
<b>number2</b> seconds ago (in this case, between "now" and one day ago), of 
which original Nonsense author James Baughn says it is <i>'actually more useful 
than it might first appear…'</i> though I haven't been able to figure out what 
that was all about.</p> 
<p>A <b>strftime format cheat sheet</b> is available on
<a href="https://strftime.org/"> strftime.org</a>.</p>   
  """;


final balderDashFont = GoogleFonts.inter().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;

final staticAnchorKey = GlobalKey();
