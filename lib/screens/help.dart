import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/main.dart';
import 'package:balderdash/screens/about_voc1.dart';
import 'package:balderdash/screens/cgi.dart';
import 'package:balderdash/screens/fixing.dart';
import 'package:balderdash/screens/how1.dart';
import 'package:balderdash/screens/intro.dart';
import 'package:balderdash/screens/prefs.dart';
import 'package:balderdash/screens/quick.dart';
import 'package:balderdash/screens/usage1.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double toScale = refHeight / displayHeight;
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
              fontSize: 18 * toScale),
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
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 6.0,
                  bottom: 10.0,
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
                    MaterialPageRoute(builder: (context) => Quick()),
                  );
                },
                leading: Icon(Icons.rocket_launch_rounded),
                title: Text('Quickstart'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const How1()),
                  );
                },
                leading: Icon(Icons.question_answer_rounded),
                title: Text('How does it work?'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutVoc1()),
                  );
                },
                leading: Icon(Icons.article_rounded),
                title: Text('Vocabularies'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Usage1()),
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
                leading: Icon(Icons.category_rounded),
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
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
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
