import 'package:flutter/material.dart';
import 'package:workoutapp/main.dart';

PageController _homeController = PageController(
  initialPage: 1,
);

class HomeNavigation extends StatefulWidget {
  HomeNavigation({this.userId, this.logoutCallback, this.requests});

  final String userId;
  final VoidCallback logoutCallback;
  final requests;

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: PageView(
        controller: _homeController,
        physics: ClampingScrollPhysics(),
        children: [
          HomeScreen(
            logoutCallback: widget.logoutCallback,
            requests: widget.requests,
          )
        ],
      ),
    );
  }
}
