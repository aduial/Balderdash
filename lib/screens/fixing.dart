import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Fixing extends StatelessWidget {
  const Fixing({super.key});
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
      <p>We've tested this app with all included examples and as far as we can see 
      they all work, though that's no guarantee there may still be a bug biding 
      its time. If you go write your own grammars (as you should) and things don't 
      work as expected, it's much more likely there's an error lurking somewhere in
      your vocabularies. Using the Perl version of Nonsense it could be hard to 
      pinpoint the cause of a problem because of the large .data files, but with 
      this app it is probably much easier to find the problem, especially now we've
      added the <b>Vocabulary error checking</b> function - see the "Using the 
      app" page.</p>
      
      <h3>Runtime error checking</h3>
      <p>Because recursion so easily leads to endless loops that love draining 
      your battery, we took some effort to catch such errors. When Balderdash 
      detects a repeating loop, it will halt and show <b>ENDLESS_LOOP_ERROR</b>. 
      It will also show an error when it finds double curly braces <b>{{</b> or <b>}}</b>.</p>
      
      <h3>Vocabulary syntax checking</h3>
      <p>You can check the current selection of vocabularies in the <b>Vocabularies
      screen</b> for syntax errors: open the right-hand drawer (⚙️cogwheel top 
      right)️ and tap the "Check current vocabularies" button underneath the 
      Project- and Category filters. This will check the vocabularies that are 
      currently listed and mark those with errors by displaying the 
      <span class="redntp">title in red</span>.</p>
      
      <h3>Vocabulary check on save</h3>
      <p>If it is enabled in the User Settings, the app will check your Vocabulary 
      when you save it, and show what line or lines contain what errors.</p>

      <h3>Tracking down a problem</h3>
      <p>None of that will help you when the vocabulary is technically OK, but doesn't
      produce what you want. In such cases it's best to isolate the problem like 
      this: starting from the bootstrap (start) vocabulary, find the first vocabulary 
      that has multiple lines, and add a return after the first line. The result 
      is that only the first line will be executed - then, by cutting / pasting, 
      put every line as the isolated first line in turn until you identify the one
      that produces the unwanted result. Repeat downstream until you've found the 
      culprit.<br>
      You can also create a test vocabulary and run parts from other vocabularies
      from there. Remember that you can run pretty much all vocabularies by 
      themselves, the only exception being that you can't call variables before they 
      are set. In that case, copy the <b>{FIXVARIABLES}</b> to your test vocabulary
      to ensure they are all initialised.</p>

      <h3>Common issues</h3>
      <ul>
      <li><b>Short-circuiting the app</b> It's perfectly OK to refer to the current 
      vocabulary, but make sure that the app can exit the loop. For instance, say 
      you have a vocabulary called <b>MYQUALITIES</b> and would like Balderdash to
      occasionally add more than just one to the result. You can do that like this:
      <p class="fix"><b>MYQUALITIES</b><br>
      <span class="yelntp">{Myqualities} and</span><br>
      Polyglot<br>
      Polymath<br>
      Humble<br>
      IQ > 170<br>
      Smashingly beautiful<br>
      Caring<br>
      Daring<br>
      Best singing voice of the country<br>
      Trustworthy
      </p> 
      This is safe, because Balderdash randomly picks a line, so the chance that
      it will loop here is 10% (for 1 recursive call in 10 lines) - there's 90% 
      chance that the loop exits every time it recurs - there is a clear exit condition
      for the loop to end. However, if you do this:
      <p class="fix"><b>BETTERNOT</b><br>
      <span class="yelntp">{Betternot} and</span><br>
      <span class="yelntp">{Betternot}, also</span><br><br><br>
      </p> 
      ... there's no exit condition. Balderdash will enter a loop which shows as
      if nothing happens - no text appears, nothing. If this happens, tap the Back
      button top left as quick as possible, save your vocabulary and restart 
      Balderdash. That's because this looping fills up the memory of your device, 
      and it will crash the app after a short time. We're working on a way to trap
      this error, but it's best to avoid it nonetheless: put at least the same
      amount of regular lines in a vocabulary as recursive calls - also consider
      the <b>#3#</b> repetition markers! </li>
      <li><b>Using out-of-scope vocabularies</b> (from another project) - remember 
      that you can only access vocabularies in the same project and those in the 
      Library. Note that Library vocabularies can <i>only</i> access other 
      Library vocabularies.</li>
      <li><b>Mismatched nouns, verbs, adjectives, pronouns...</b> consider yourself 
      lucky that words in English don't have grammatical gender, like German or Dutch.
      But you still need to be careful to avoid creating <i>Word Crimes</i> instead of 
      Balderdash. See the example about <b>pointer variables</b> on the 
      Vocabularies help page for an example of how you can set things up.</li> 
      <li><b>It's not as funny as I hoped ...</b> What can I say? It can turn out
      quite different than expected, though that goes both ways: it can also turn 
      out <i>better</i> than expected. Most of that comes down to finding the right balance 
      between chaos and order - for instance, creating names from a few sets of 
      individual letters vs. sets of syllables. I found that, though in the first 
      case you have the most possibilities, you need to be very careful to avoid 
      creating similar garble. Using larger fragments often works much better.</li>
      <li><b>It's hard to generate interesting / funny words using a grammar</b>
      It's not super easy, indeed. Have you tried playing around with Markov 
      Vocabularies generated from examples you provide? The results of these are 
      less "controlled" than for a context-free grammar, but they are generally very
      good at producing similarly-flavoured words. There's also nothing stopping 
      you from combining CFG- and Markov vocabularies:
      <p class="fix"><b>BESTOFBOTH</b><br>
      {^Markov_firsthalf}{^CFG_lasthalf}<br>
      {^CFG_firstname} {^Markov_lastname}<br>
      {^CFG_person_role} {^Markov_asimov_name}</span><br><br>
      </p> 
      </li> 
      </ul>
      
      
      
     
      
  """;

final balderDashFont = GoogleFonts.merriweatherSans().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;
