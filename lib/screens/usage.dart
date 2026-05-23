import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Usage extends StatelessWidget {
  const Usage({super.key});
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
          "Using the app",
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
                                return {
                                  'color': '#00B8FF',
                                  'font-weight': '700'
                                };
                              } else if (element.classes.contains('yelntp')){
                                return {'color': '#FFEF40'};
                              } else if (element.classes.contains('redntp')){
                                return {
                                  'color': '#FF4C4F',
                                  'font-weight': '900'
                                };
                              } else if (element.classes.contains('pinktp')){
                                return {'color': '#FFA2A4'};
                                // color: pink
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
      <p>We put some effort explaining <span class="brigrn">Vocabularies</span> 
      because they're the most important part of the app. The Vocabularies 
      screen has a few features we didn't mention yet:</p>
      
      <h3>Search for calling and called vocabularies</h3>
      <p>Tap the 🔍(magnifying glass) button left on the row to see show what 
      Vocabularies call the one in the current row, while the ⭐️(star) button 
      (the first of the three icons on the right side on the row) will show all 
      Vocabularies that will be called when running the current one: this could 
      be useful if you want to copy all required Vocabularies into a separate 
      project (more about that below).</p>
      <p>Note that this <i>called</i> search has one limitation: if does not take
      pointer variables <b>{$$var1}</b> into account, listing only their primary 
      assigning vocabulary, like with regular variables. That's because this 
      'called' type of search needs to recursively traverse <b>every</b> line 
      in <b>every</b> Vocabulary it encounters, and when a Vocabulary's output 
      may be parsed (by a pointer variable) as referring to another Vocabulary 
      somewhere downstream, the search may well explode like the TREE(3) function 
      and collapse your device into a black hole 😨. In any case, it became too 
      funky to code.</p>
      
      <h3>Filtering on Project and / or Category</h3>
      <p>The list of <span class="brigrn">Vocabularies</span> in the 
      <span class="redntp">Run Balderdash!</span> and the Vocabularies screens 
      can be narrowed down by typing (part of) the Vocabulary title in the search 
      text field on top of the screen, or by filtering on Project and / or Category.<br>
      To do that, tap the gear icon in the top of the screen (second from the right). 
      This opens a drawer similar to the menu drawer on the right side, where 
      you can select these filters. When one or both filters are active it is 
      indicated underneath the search bar. Note that Vocabularies from the 
      <b>Library</b> project are always listed. When you filter on a project, 
      <b>Library</b> Vocabularies are listed below the Project's own Vocabularies.</p>
      
      <h3>Finding Vocabularies on content</h3>
      <p>So you're working on a sentence that needs an adjective to show how huge,
      tiny, awesome, creepy etc. something is and you're positive you create a 
      vocabulary for that purpose just last week ... <i>but what was its title again?</i><br>
      This happens far too often, really. The included database is probably filled
      with vocabularies containing very similar collections of words, even from way
      back using the original Nonsense! script.<br>
      But those worries are over: the app now has a proper search function that 
      comes to the rescue. In the Vocabulary screen, tap the 🔍(magnifying glass) 
      search icon top right of the screen.</p>
      <p>This activates <span class="yelntp"><b>Word Search Mode</b></span>, indicated 
      by the search icon turning into <span class="yelntp">🅧</span> and the rows
      getting a slight yellow tint. The search textfield is cleared: typing more 
      than two letters in it will get all vocabularies from the database that 
      contain that string. Note that the other two buttons 
      (for <span class="orantp">batch mode</span> and the gear icon) are 
      disabled in <span class="yelntp"><b>Word Search Mode</b></span>.
      Tapping <span class="yelntp">🅧</span> will exit <span class="yelntp">
      <b>Word Search Mode</b></span>; the rows get their original tint and the filter 
      string in the textarea will be restored.</p>
      
      <h3>Batch mode: copying and moving vocabularies</h3>
      <p>If you want to copy or move Vocabularies you'll first have to select 
      them. To do that, tap the 'checkboxes' icon in the top of the screen, the 
      leftmost of the three icons. This activates <span class="orantp">Batch Mode</span>
      , indicated by the rows getting an orange tint. You can select vocabularies 
      with the checkboxes on each row. To copy or move to them to another 
      project, tap the floating button bottom right (which turns <span class="orantp">
      orange</span> in Batch Mode). Tap the orange <span class="orantp">🅧</span> 
      button top right to exit Batch Mode.</p>

      <h3>Templates</h3>
      <p>Next, there are the <span class="violntp">Templates</span> that you 
      can use to show off your Balderdash! to the world, up to an entire website 
      that shows new content on every reload. There's more about that on the 
      CGI deployment help page.</p>

      <h3>Data in Balderdash</h3>
      <p>Because Balderdash! uses a SQLite database instead of text files, 
      it made sense to add some structure so you can find your stuff back, share 
      a project with another Balderdash! user, etcetera. We'll briefly walk you 
      through that below.</p>

      <h3>Categories</h3>
      <p>Vocabularies have a (one) <span class="cyantp">Category</span> (eg. 
      Adjective, Noun, Phrase ...). These are convenience labels that you can 
      use to keep track of your Vocabularies - you can also filter the list on them,
      see further down. A Category has no influence on how Balderdash! works. 
      There's about twenty Categories defined in the database and you can add 
      as many as you like, or delete them. Categories can be nested by 
      specifying a Parent Category in the Category detail screen, so you can 
      refine your Categories as much as you want.</p>
      
      <h3>Filtering on Category 'none' and project 'Library'</h3>     
      <p>Category 'none' means 'No Category', but explicitly so: when selecting 
      'none' in the Category filter, the screen will list Vocabularies of ALL 
      Categories (including 'none'). However, if you assign a Vocabulary to 
      Category 'none', it will NOT show up when filtering on other Categories.
      With regard to filtering, project 'Library' behaves in the same way. Also 
      note that clearing the Category or Project filter in the right-hand drawer 
      sets them to 'none' and 'Library' respectively.</p>
      
      <h3>Projects</h3>
      <p>Next to a Category, Vocabularies also belong 
      to a <span class="orantp">Project</span>. That's not just a label; it 
      defines the scope of a Vocabulary. If you run Balderdash, it can find all 
      Vocabularies under the same Project - <b>AND</b> - those from the Project 
      called <b>Library</b> (#ID=1). There are several demo Projects available 
      in the app and you can add as many as device space permits. Projects, in 
      their turn, have an <span class="bluntp">Author</span> (ie. you), and a 
      <span class="yelntp">Type</span> (Legacy, Examples ...).</p>

      <h3>Screen layout</h3>
      <p>All of that can be managed with the screens listed in the main menu. 
      For the most part, they look very similar: they all have a list view that 
      can be filtered by entering text in the search bar on top. You can edit an 
      entry by tapping the Pencil button on the right side of the row, delete it 
      with the Trash can button next to it, and add a new entry with the floating 
      (+) button bottom right.</p>

      <p>The Edit screens are pretty much self-explanatory. The Vocabulary- and 
      Template-editor use a text editor with custom syntax highlighting, the 
      other screens use simple textfields and drop-down selectors as in any form.</p>

      <h3>'Run Balderdash' vs. the Vocabulary screen</h3>
      <p>The <b>Run Balderdash!</b> screen is very similar to the Vocabularies 
      screen: it has no edit options but a triangular "play" button on the right 
      side of every row. Tapping that opens a screen with a larger textfield and 
      a single button that will run the current vocabulary and display the result.</p>
      
      <h3>Vocabulary error checking</h3>
      <p>Balderdash detects errors when running. It will halt and report any 
      repeating loops en some obvious errors in Vocabularies it finds, like 
      references to non-existing vocabularies.</p>
      
      <p>You can also check vocabularies beforehand: open the right-hand drawer on 
      the Vocabularies screen and tap the "Check current vocabularies" 
      button underneath the Project- and Category filters. This will check the 
      vocabularies that are currently listed and mark those with errors by 
      displaying the <span class="redntp">title in red</span>.</p>
      <p>And lastly, if enabled in the User Settings, Balderdash will check your 
      Vocabulary when you save it, and show in what line or lines it found what 
      errors.</p>
      
      <h3>Selecting & editing text in the detail screens</h3>
      <p>As in other apps, single-tapping puts the cursor on that location in 
      the textarea, double-tapping a word will select it, and triple-tapping 
      selects the entire line. This may take some getting used to.<br>
      Selecting text brings up a popup with (cut|copy|paste) options.</p>
      
      <h3>Jumping to a selected vocabulary</h3>
      <p>Double-tapping a <b>{vocabulary}</b> command will select the vocabulary name
      without the curly brackets; if you tap the "Go to selected" button bottom 
      left, Balderdash tries to open the selected vocabulary for you. What exactly
      happens depends on what it finds:</p>
      <p>
      <ul>
      <li>if it doesn't find a vocabulary with that title, it will tell you</li>
      <li>if it finds the vocabulary in either the current project or in the 
      Library, it will open it right away</li>
      <li>if it finds vocabularies with that title in the current project or in the 
      Library <b>and</b> in other projects, it will offer to open the one in scope 
      (ie. the current project or the library) while mentioning where it found 
      the other one</li>
      <li>if it finds vocabularies with that title in the current project <b>and</b>
      in the Library, it asks which one you want to open; if it finds others with 
      that title elsewhere, it will mention it.</li>
      </ul>
      </p>
      
      <h3>Creating Markov Vocabularies from example text</h3>
      <p>Go to the <span class="pinktp"><b>Markov Chains</b></span> screen in the main menu, tap the "Open File"
      button, find and select a file with example words. Words in the example file 
      must be separated by spaces or returns. Balderdash will use all words in the 
      file, so make sure there's no unwanted text in there that could influence the
      result you want.
      </p>
      <p>When the file is loaded, the four buttons labeled <b>N=2</b> to <b>N=5</b>
      are enabled. Choose <b>N=2</b> if you want results that only loosely resemble
      the example, or one of the higher ones if you want them to be more similar.</p>
      <p>The result will vary depending on how many examples you provide. The analysis 
      will be better when it's based on more examples, but be aware of the fact 
      that the size of the resulting Markov Vocabularies is proportional to the 
      size of the example input and the N-gram size. Start small and work your way 
      up; it will also depend on the capacity of your device how far you can go.</p>
      <p>In the 'Run Balderdash' and Vocabulary screens, Markov vocabularies are
      <span class="bluntp">LISTED IN BLUE</span> instead of dark grey.<br>
      See the "Vocabularies and Markov Chains" page for more about Markov Vocabularies.
      </p>
      
     
      
  """;

final balderDashFont = GoogleFonts.merriweatherSans().fontFamily;
final vocabFont = GoogleFonts.robotoMono().fontFamily;
