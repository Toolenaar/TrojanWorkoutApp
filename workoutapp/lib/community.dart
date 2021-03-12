import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                child: Text("Upcoming Events",
                    style: TextStyle(
                        fontSize: 14.0, color: CupertinoColors.white)),
                onPressed: () =>
                    {}), // go to events on the external Trojan site
            CupertinoButton.filled(
                child: Text("Trojan Workout Website \nMartijn Bos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.0, color: CupertinoColors.white)),
                onPressed: () =>
                    {}), // go to homepage on the external Trojan site
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
      child: CupertinoButton(
        child: const Text(""),
        onPressed: () {},
      ),
    );
  }
}
