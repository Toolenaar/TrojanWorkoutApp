import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Community extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (_) => CommunityHomePage(),
        'principles': (_) => PrinciplesPage(),
        'reviews': (_) => ReviewsPage()
      },
    );
  }
}

class CommunityHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Welcome to Community!'),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CupertinoButton.filled(
                child: Text("Mental Power Principles",
                    style: TextStyle(
                        fontSize: 14.0, color: CupertinoColors.white)),
                onPressed: () => {
                      Navigator.of(context).pushNamed("principles")
                    }), // goes to new page displaying power principles
            CupertinoButton.filled(
              child: Text(
                "Upcoming Trojan Events",
                style: TextStyle(fontSize: 14.0, color: CupertinoColors.white),
              ),
              onPressed: launchURL,
            ), // goes to events on the external Trojan site
            CupertinoButton.filled(
              child: Text("Trojan Workout Website \nMartijn Bos",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 14.0, color: CupertinoColors.white)),
              onPressed: _launchURL,
            ), // goes to homepage on the external Trojan site
            CupertinoButton.filled(
                child: Text("Reviews",
                    style: TextStyle(
                        fontSize: 14.0, color: CupertinoColors.white)),
                onPressed: () => {
                      Navigator.of(context).pushNamed("reviews")
                    }), // goes to new page with list of reviews
          ],
        ));
  }
}

_launchURL() async {
  const url = "https://trojanworkout.com/";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchURL() async {
  const url = "https://trojanworkout.com/all-events/";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class PrinciplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Mental Power Principles"),
      ),
      child: CupertinoButton(
        child: const Text(""),
        onPressed: () {},
      ),
    );
  }
}

class ReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Reviews"),
      ),
      child: Text(""),
    );
  }
}
