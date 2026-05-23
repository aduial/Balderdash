import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/main.dart';
import 'package:balderdash/screens/cgi.dart';
import 'package:balderdash/screens/fixing.dart';
import 'package:balderdash/screens/intro.dart';
import 'package:balderdash/screens/prefs.dart';
import 'package:balderdash/screens/usage.dart';
import 'package:balderdash/screens/quick.dart';
import 'package:balderdash/screens/how.dart';
import 'package:balderdash/screens/vocabularies.dart';
import 'package:balderdash/screens/imexport.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home_rounded),
          color: ithildin,
          onPressed: () {
            Navigator.of(context).push(_goHome());
          },
        ),
        backgroundColor: mountainBlue,
        title: Text(
          "Help",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: ithildin,
              fontWeight: FontWeight.w500,
              fontSize: 18 * scaling),
        ),
      ),
      backgroundColor: mountainBlue,
      body: SafeArea(
        child: ListTileTheme(
          dense: false,
          textColor: ithildin,
          iconColor: ithildin,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0 * scaling,
                height: 128.0 * scaling,
                margin: EdgeInsets.only(
                  top: 6.0 * scaling,
                  bottom: 10.0 * scaling,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  // color: Colors.black12,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  getHelpImg(),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Intro()),
                  );
                },
                leading: Icon(Icons.auto_awesome_rounded),
                title: Text('About this app'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Quick()),
                  );
                },
                leading: Icon(Icons.rocket_launch_rounded),
                title: Text('Quickstart'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => How()),
                  );
                },
                leading: Icon(Icons.question_answer_rounded),
                title: Text('How does it work?'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Vocabularies()),
                  );
                },
                leading: Icon(Icons.article_rounded),
                title: Text('Vocabularies and Markov Chains'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Usage()),
                  );
                },
                leading: Icon(Icons.category_rounded),
                title: Text('Using the app'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Prefs()),
                  );
                },
                leading: Icon(Icons.settings_applications_rounded),
                title: Text('Preferences'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cgi()),
                  );
                },
                leading: Icon(Icons.web_rounded),
                title: Text('CGI deployment'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Fixing()),
                  );
                },
                leading: Icon(Icons.heart_broken_rounded),
                title: Text("It doesn't work!"),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Imexport()),
                  );
                },
                leading: Icon(Icons.drive_folder_upload),
                title: Text("Import & Export"),
              ),
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12 * scaling,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 16.0 * scaling,
                  ),
                  child: Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route _goHome() {
  return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuad;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      });
}
