import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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
          "About Vocabularies",
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
                              } else if (element.classes.contains('title')){
                                return {
                                  'color': '#FFFFFF',
                                  // 'padding': '6px',
                                  // 'font-family' : '"Lucida Console", "Courier New", monospace',
                                  // 'font-size': '12px',
                                  'font-weight': '800'
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

const htmlData = """<h2>What is a Vocabulary?</h2>
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

<h2>Example Vocabularies</h2>

<p>Take a look at these example vocabularies:</p>

<p class='fix'><span class='title'>START</span><br>
$lc^Whoknows$rc ${lc}Person$rc ${lc}Dothis$rc ${lc}sometime${rc}</p>

<p class='fix'><span class='title'>WHOKNOWS</span><br>
Maybe<br>
if nothing comes between, <br>
If we don't fix that stereo set,</p>

<p class='fix'><span class='title'>PERSON</span><br>
Charles<br>
neighbour Todd<br>
auntie Bertha</p>

<p class='fix'><span class='title'>SOMETIME</span><br>
Tomorrow<br>
Next week<br>
One of these days</p>

<p class='fix'><span class='title'>DOTHIS</span><br>
${lc}maybe$rc ${lc}something$rc<br>
${lc}surely$rc ${lc}somethingelse$rc</p>

<p class='fix'><span class='title'>SOMETIME</span><br>
Tomorrow<br>
Next week<br>
One of these days</p>

<p class='fix'><span class='title'>MAYBE</span><br>
could<br>
might</p>

<p class='fix'><span class='title'>SURELY</span><br>
will<br>
might${lan} instead$rc</p>

<p class='fix'><span class='title'>SOMETHING</span><br>
start sneezing<br>
drop by<br>
${lan}slap${p}hit$rc ${lc}Person$rc</p>

<p class='fix'><span class='title'>SOMETHINGELSE</span><br>
wait for {[me|you}<br>
start playing ${lan}a${p}the${p}her$rc wah-wah guitar${lan}, and what's next?$rc</p>

<h2>Regular Vocabulary commands</h2>

<p>The first command in the <span class='title'>START</span> vocabulary is <b>$lc^Whoknows$rc</b>:
a word put between curly brackets refers to a vocabulary with that title (for the <b>^</b>
see <b>Text Case</b> below). If that vocabulary does not exist, Balderdash will throw
an error. Text <b>not</b> between curly brackets (either HTML or plain text) is added
to the result of the vocabulary when Balderdash works its way through it.</p>
<p>You can refer to any vocabulary from the current vocabulary's own project or
from the <b>Library</b>. You can even refer to the vocabulary itself, but make sure
that that's not the only possible line that Balderdash can choose, because this 
will quickly crash the app - please read the <i>common errors</i> paragraph in the 
<b>"It doesn't work!"</b> help screen before you try recursive (self-referring) 
calls.</p>

<h2>Anonymous Vocabularies</h2>

<p>Maybe you noticed these in the example? The colors are just to help keeping those
pesky <b>${lan}${pp}${rc}</b> brackets apart:</p>

<p class="fix">${lan}me${p}you$rc ${lan}a${p}the${p}her$rc $lan, and what's next?$rc</p>

<p>These <b>Anonymous Vocabularies</b> act like inline mini-vocabularies. They start with 
a curly bracket and a left square bracket <b>${lan}</b>, close with a right curly bracket <b>$rc</b>, 
with alternatives separated by a pipe <b>$p</b> character. Balderdash! randomly picks one of the alternatives. When just 
s single choice is given:</p>
<p class="fix">${lan}50% chance of me showing up$rc</p>
<p>... it has a 50% chance of being selected. With more than one choice, chances 
are equally distributed. You can tweak the odds by duplicating words and/or adding empty terms. 
These are not ignored as in regular Vocabularies, so you can use:</p>

<p class="fix">${lan}${ppp}Tom${p}Harry${p}Harry$rc</p>

<p><b>${ppp}</b> represents three 'empty strings', so with one <b>Tom</b> 
and two <b>Harry</b>'s there's six choices in total, meaning there's a 50% chance 
this anonymous vocabulary produces <b>''</b> (nothing); one in three of 
<b>'Harry'</b> and one in six of <b>'Tom'</b>.</p>


<h2>Text case</h2>

<p>Vocabulary <b>START</b> of the example grammar started with: <b>{^Whoknows}</b>, 
which referred to vocabulary <b>WHOKNOWS</b>. </p>
<p>Vocabulary titles are always <b>UPPERCASE</b>, but the case of the <b>{commands}</b> 
referring to them determines the case of the text they return:</p>

<p class="fix">${lc}Whoknows$rc</p>
<p><b>(Mixed Case)</b> returns the case unchanged: <b>'If we don't fix that stereo set,'</b></p>
<p class="fix">${lc}whoknows$rc</p>
<p><b>(all lowercase)</b> returns the text in lowercase: <b>'maybe'</b></p>

<p class="fix">${lc}WHOKNOWS$rc</p> 
<p><b>(all UPPERCASE)</b> returns the text in UPPERCASE: <b>'MAYBE'</b></p>

<p class="fix">${lc}^Whoknows$rc</p> 
<p><b>(prefixed with ^)</b> returns the text with the first letter capitalised:
<b>'If nothing comes between,'</b></p>

<p>The example grammar might result in: </p>
<ul><li><i>If nothing comes between, Charles might slap neighbour Todd next week</i></li>
<li><i>Maybe neighbour Todd could drop by tomorrow</i></li>
<li><i>If we don't fix that stereo set, auntie Bertha might start playing her 
wah-wah guitar, and what's next?</i></li></ul>
<p>... or some variation thereof.</p>

<h2>Variables</h2>
<p>To maintain some context amidst the random chaos that contex-free grammars 
tend to produce, Balderdash! provides (state) variables that create 
blissful oases of sanity, ready at hand when you need them.</p> 
<p>Variables are created by assigning them a value from either a fixed string, 
or from a {command} (e.g. the output of a vocabulary). Once set, they can be 
recalled as often as needed until Balderdash! reaches the end of the starting 
vocabulary:</p>

<p class="fix">${lc}var1${as}some text$rc</p> 
<p>stores <b>'some text'</b>  in variable <b>\$var1</b>.<p>

<p class="fix">${lc}var2${av}command$rc</p>  
<p>stores the result of <b>command</b> in variable <b>\$var2</b>.<p>

<p>Setting state variables does not directly add text to the result. To add the 
content of a variable to the result, put it between curly braces 
prefixed with a dollar sign:<p>

<p class="fix">$lc${dl}var1$rc $lc${dl}var2$rc</p>
<p><i><b>after</b></i> you have set them.</p>

<h3>Pointers</h3>

<p>If a variable is read prefixed by two dollar signs:</p>
<p class="fix">$lc$dl${dl}var1$rc</p>
<p>(a <b>pointer</b>) it's interpreted as a <b>command</b> referring to a 
<b>Vocabulary</b>. This allows creating interesting dynamic behaviour, but be 
warned that it can make things <i>really</i> complex  <i>really</i> fast.</p>
<p>To give a very basic example:</p>

<p class="fix">POINTERDEMO<br>
${lc}Fixpplwords$rc$lc${dl}Name$rc is my $lc${dl}person$rc<br>
${lc}Fixpplwords$rc$lc$dl${dl}Name$rc is $lc$dl${dl}person$rc<br>
<br>
FIXPPLWORDS<br>
${lc}Name${av}Femname$rc${lc}Person${av}Femperson}<br>
${lc}Name${av}Malename$rc${lc}Person${av}Maleperson}<br>
<br>
FEMNAME<br>
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
MALENAME<br>
John<br>
Robert<br>
Giovanni<br>
<br>
JOHN<br>
Johnny<br>
Jan<br>
Sjon 'the Knife'<br>
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
actually quite a good guitar-player<br>
my best friend<br>
kind of a German 'Dieter'<br>
<br>
GRANDPA<br>
a blunderbuss-wielding old-timer grandpa<br>
an ancestor<br>
my hero<br>
<br>
FEMPERSON<br>
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
<ul>
<li><b>Giovanni is my grandpa</b></li>
<li><b>Eline is my niece</b> ... etcetera.</li></ul>
<p>while the second line might give:</p>
<ul><li><b>Sjon 'the Knife' is actually quite a good guitar-player</b></li>
<li><b>Rob is my blunderbuss-wielding old-timer grandpa</b></li>
<li><b>Petronella is really something else</b></li>
<li><b>Klapsie is my mother's neighbour lady</b> ... etcetera.</li></ul>

<p>Just sayin' ... you best understand the above before you start messing around with
it. And this is just one level of pointers: there's nothing stopping you from
using them in, say, <b>MALENAME</b> - but let me stop here, before people get
funny ideas about warping reality or messing with the Noosphere, which is best 
left to the good folk at the <a href="https://scp-wiki.wikidot.com/">
SCP wiki</a>.</p>

<p>It's probably best to set all variables together in a dedicated one-line 
vocabulary titled <b>{SETVARIABLES}</b> (set it to the 'set variables' category), 
and call it first thing in the starting vocabulary. Don't forget that any regular
text and white-spaces between variable assignments <b>will be</b> 
added to the result! I once spent way too much time figuring out where some pesky
extra whitespace came from, and finally found that it was hiding between variable 
assignments:</p>

<p class="fix">${lc}var1${av}bon$rc${lc}var2${av}bam$rc${lc}var3${av}ips$rc ${lc}var4${av}kip$rc</p>

<p>Note that case formatting also works for variables; it is applied when you 
read them, eg.</p>

<p class="fix">$lc${dl}var$rc $lc${dl}VAR$rc $lc${dl}Var$rc $lc$dl^var$rc</p>

<p> - see above under <b>Text case</b> for the details.</p>

<h2>Numbers and repetitions</h2>

<p>Balderdash! will replace this command:</p>
<p class="fix">$lc$spr#$cs${spg}number1$cs$spr-$cs${spb}number1$cs$rc</p>
<p><b>(whole numbers only!)</b> with a random whole number between $spg<b>number1</b>$cs 
and $spb<b>number2</b>$cs (inclusive).</p>

<p>When processing a vocabulary, Balderdash! randomly picks one of the lines. 
However, you can influence the odds a line is selected by prefixing the line 
with a weight factor <b>$spr#${cs}number$spr#$cs</b> (a whole number), for instance:</p>

<p class="fix">...<br>
random chance being picked<br>
$spr#${cs}${spg}2$cs$spr#${cs}twice as ${lc}often$rc<br>
$spr#${cs}${spg}7$cs$spr#${cs}seven times as ${lan}likely$spr|${cs}often$rc<br>
...</p>

<p>This goes for all lines regardless their content.</p>

<p>You can have Balderdash! evaluate a command multiple times using this format:</p>
<p class="fix">$spc{${cs}command$cs$spr#$cs${spg}number1$cs$spr-$cs${spb}number2$cs$spc}$cs</p>
<p><b>(whole numbers only!)</b> which will repeat it a random whole number between 
$spg<b>number1</b>$cs and $spb<b>number2</b>$cs (inclusive) times. This is especially useful 
in starting (bootstrap) vocabularies.</p>


<h2>HTML, special characters & strftime</h2>
<p>You can use most (or maybe all) regular <b>HTML</b> in your vocabularies to make 
text <b>bold</b> or <i>italic</i> or <b>${spc}ha$cs${spr}v${cs}i${spg}n$cs${spc}g$cs 
${spr}fu$cs${spc}n$cs${spg}ny$cs ${spg}c$cs${spr}o${cs}l${spc}o$cs${spg}u$cs${spr}r$cs${spc}s$cs</b>
(see <a href='https://demo.fwfh.dev/supported/tags.html'>here</a> for the full list
of supported html elements.</p>


<p>A newline (return / linefeed), curly brackets {} and NULL a.k.a. 'nothing' can 
be included in a Vocabulary like this:</p>

<p class="fix">$spc{$cs\\n$spc}$cs</p>
<p> = newline (return / linefeed). This is converted into a $br HTML tag for display,
so you can use either one.</p>
<p class="fix">$spc{$cs\\L$spc}$cs $spc{$cs\\R$spc}$cs</p>
<p> = left & right curly braces</p>
<p class="fix">$spc{$cs\\0$spc}$cs</p> 
<p> = nothing, empty string</p>

<p>Last but not least, we pay homage to the good old <b>strftime</b> datetime format 
that was so harshly deprecated in php 8.1.<br>
Hah! With that, Balderdash! may be the only IOS app that supports it.
Use the simple <b>$lc$spc@${cs}strftime format$rc</b> as in, for instance,</p>

<p class="fix">$lc$spc@$cs%Y$rc</p>
<p>to return the current date & time; or, together with a numerical range
<b>$lc$spc@${cs}strftime format$spr|$cs${spg}number1$cs$spr|$cs${spb}number1$cs$rc</b> e.g.</p>
<p class="fix">$lc$spc@${cs}%H:%M:%S$spr|$cs${spg}0$cs$spr|$cs${spb}86400$cs$rc</p>


<p>(... whole numbers only!) if you want a timestamp between $spg<b>number1</b>$cs 
and $spb<b>number2</b>$cs seconds ago (in this case, between "now" and one day ago), of 
which original Nonsense author James Baughn says it is <i>'actually more useful 
than it might first appear…'</i> though I haven't been able to figure out what 
that was all about.</p> 
<p>A <b>strftime format cheat sheet</b> is available on
<a href="https://strftime.org/"> strftime.org</a>.</p>   

  """;


const String spg = "<span class='brigrn'>";
const String spr = "<span class='redntp'>";
const String spc = "<span class='cyantp'>";
const String spb = "<span class='bluntp'>";
const String cs = "</span>";
const String lc = "$spc{$cs";
const String lb = "$spg[$cs";
const String lan = "$lc$lb";
const String rc = "$spc}$cs";
const String p = "$spr|$cs";
const String pp = "$spr||$cs";
const String ppp = "$spr|||$cs";
const String as = "$spr=$cs";
const String av = "$spr:=$cs";
const String dl = "$spg\$$cs";
const String br = "&lt;br&gt;";