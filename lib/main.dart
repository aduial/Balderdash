import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/config/user_preferences.dart';
import 'package:balderdash/screens/author_page.dart';
import 'package:balderdash/screens/category_page.dart';
import 'package:balderdash/screens/help.dart';
import 'package:balderdash/screens/im_export.dart';
import 'package:balderdash/screens/project_page.dart';
import 'package:balderdash/screens/select_voc_page.dart';
import 'package:balderdash/screens/template_page.dart';
import 'package:balderdash/screens/type_page.dart';
import 'package:balderdash/screens/vocabulary_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // print("koeoia");
  runApp(MyApp());

  // final cron = Cron();
  // cron.schedule(Schedule.parse('0 * * * *'), () async {
    // print('backup DB');
    // print(DateTime.now());
  //   DatabaseHelper().makeBackup(false);
  // });
  // cron.schedule(Schedule.parse('1 * * * *'), () async {
  //   print("backup DB");
  //   print(DateTime.now());
  //   DatabaseHelper().makeBackup(true);
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    setMenuImg();
    setHelpImg();
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      navigatorKey: UserPreferences.navigatorKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    scaling = displayHeight / refHeight;
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tanteRia, blueGrey],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: ithildin,
            iconColor: ithildin,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 24.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    getMenuImg(),
                    // 'assets/images/eend.png',
                  ),
                ),
                ListTile(
                  onTap: () {
                    setDrawerImg();
                    setRBDImg();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectVocPage()),
                    );
                  },
                  leading: Icon(Icons.auto_awesome_rounded,
                      color: redNotePaperColour),
                  title: Text('Create Balderdash!'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProjectPage()),
                    );
                  },
                  leading: Icon(Icons.my_library_books_rounded,
                      color: orangeNotePaperColour),
                  title: Text('Projects'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TypePage()),
                    );
                  },
                  leading: Icon(Icons.theater_comedy_rounded,
                      color: yellowNotePaperColour),
                  title: Text('Project types'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VocabularyPage()),
                    );
                  },
                  leading:
                      Icon(Icons.article_rounded, color: greenNotePaperColour),
                  title: Text('Vocabularies'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoryPage()),
                    );
                  },
                  leading:
                      Icon(Icons.category_rounded, color: cyanNotePaperColour),
                  title: Text('Categories'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthorPage()),
                    );
                  },
                  leading:
                      Icon(Icons.people_rounded, color: blueNotePaperColour),
                  title: Text('Authors'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TemplatePage()),
                    );
                  },
                  leading:
                      Icon(Icons.web_rounded, color: violetNotePaperColour),
                  title: Text('HTML Templates'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          // builder: (context) => const FileDemo()),
                          builder: (context) => const ImExport()),
                    );
                  },
                  leading: Icon(Icons.drive_folder_upload_rounded),
                  title: Text('Export / import project'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserPreferences()),
                    );
                  },
                  leading: Icon(Icons.settings),
                  title: Text('User Preferences'),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
      // this is the start screen
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: blueTop,
          // title: const Text('Balderdash!'),
          leading: IconButton(
            color: ithildin,
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Semantics(
                    label: 'Menu',
                    onTapHint: 'go forth and create balderdash!',
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        backgroundColor: blueTop,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Balderdash!",
                style: GoogleFonts.playfairDisplay(
                  color: ithildin,
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontWeight: FontWeight.w200,
                  fontSize: 60 * scaling,
                ),
              ),
              Text(
                "a context-free grammar engine",
                style: GoogleFonts.rosario(
                    color: ithildin,
                    fontWeight: FontWeight.w300,
                    // fontStyle: FontStyle.italic,
                    fontSize: 22 * scaling),
              ),
              SizedBox(
                width: double.infinity,
                height: 30.0 * scaling,
              ),
              SizedBox(
                width: double.infinity,
                height: 50.0 * scaling,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: yellowGrey,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 20.0 * scaling,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: sortOfRed,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 35.0 * scaling,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: iceBlue,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [iceBlue, iceMountainBlue],
                    ),
                  ),
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  // color: mountainBlue,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        20 * scaling, 0 * scaling, 20 * scaling, 0 * scaling),
                    child: Text(
                      "A million monkeys with typewriters in your pocket "
                      "without the bananas and ink ribbons.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ithildin,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          fontSize: 15 * scaling),
                    ),
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
                      // colors: [iceMountainBlue, tanteMountainRia],
                      colors: [iceMountainBlue, mountainBlue],
                    ),
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  // color: mountainBlue,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        20 * scaling, 0, 20 * scaling, 0),
                    child: Text(
                      "Balderdash! is a re-implementation of the 2001 context-free-grammar text generator 'Nonsense' by James Baughn, Fred Hirsch and Peter Suschlik "
                      "(nonsense.sourceforge.net) and is dedicated to the memory of James Baughn (†2020)",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ithildin,
                          fontWeight: FontWeight.w300,
                          fontSize: 13 * scaling),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [mountainBlue, mountainBlue],
                  ),
                ),
                height: 80.0 * scaling,
                // color: mountainBlue,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sortOfRed,
                            surfaceTintColor: pink,
                            // padding: const EdgeInsets.symmetric(horizontal: 6),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            elevation: 5 * scaling,
                            iconAlignment: IconAlignment.end,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Help()),
                            );
                          },
                          child: const Icon(
                            Icons.question_mark_rounded,
                            color: ithildin,
                          ))
                    ]),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [mountainBlue, blueBottom],
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        20 * scaling, 0, 20 * scaling, 0),
                    child: Text(
                      "Tap the menu icon top left to start creating balderdash. For instructions "
                      "how to use the app and write a context-free grammar, tap the help (?) button.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ithildin,
                          fontWeight: FontWeight.w300,
                          fontSize: 13 * scaling),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  color: blueBottom,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        30 * scaling, 10 * scaling, 30 * scaling, 10 * scaling),
                    child: Text(
                      "Balderdash! was built by Lúthien Dulk\n(https://animatrice.nl)",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ithildin,
                          fontWeight: FontWeight.w300,
                          fontSize: 12 * scaling),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}

abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Using FlexColorScheme built-in FlexScheme enum based colors
    scheme: FlexScheme.pinkM3,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Using FlexColorScheme built-in FlexScheme enum based colors.
    scheme: FlexScheme.pinkM3,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
