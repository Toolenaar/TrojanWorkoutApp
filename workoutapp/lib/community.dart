import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Community extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (_) => CommunityHomePage(),
        //'principles': (_) => PrinciplesPage(),
        //'testimonials': (_) => TestimonialsPage()
      },
    );
  }
}

class CommunityHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CupertinoButton(
          child: Text("Welcome to Community",
              style: TextStyle(fontSize: 20.0, color: Colors.black87)),
          onPressed: () => {}),
      CupertinoButton.filled(
          child: Text("Mental Power Principles",
              style: TextStyle(fontSize: 14.0, color: CupertinoColors.white)),
          onPressed: () => {}),
      CupertinoButton.filled(
          child: Text("Upcoming Events",
              style: TextStyle(fontSize: 14.0, color: CupertinoColors.white)),
          onPressed: () => {}),
      CupertinoButton.filled(
          child: Text("Trojan Workout Website\nMartijn Bos",
              style: TextStyle(fontSize: 14.0, color: CupertinoColors.white)),
          onPressed: () => {}),
      CupertinoButton.filled(
          child: Text("Testimonials",
              style: TextStyle(fontSize: 14.0, color: CupertinoColors.white)),
          onPressed: () => {}),
    ]);
  }
}
