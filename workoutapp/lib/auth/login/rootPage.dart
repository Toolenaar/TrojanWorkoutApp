import 'package:workoutapp/auth/baseAuth.dart';
import 'package:flutter/material.dart';
import 'package:workoutapp/auth/login.dart';
import 'package:workoutapp/auth/login/homeNavigation.dart';
import 'package:workoutapp/auth/usernameForm.dart';

enum AuthStatus { NOT_DETERMINED, NOT_LOGGED_IN, LOGGED_IN, REQUESTING_NAME }

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) => {
          setState(() {
            if (user != null) {
              _userId = user?.uid;
            }
            authStatus = user?.uid == null
                ? AuthStatus.NOT_LOGGED_IN
                : AuthStatus.LOGGED_IN;
          })
        });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void loginRequestName() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.REQUESTING_NAME;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
        case AuthStatus.LOGGED_IN:
          if (_userId.length > 0 && _userId != null) {
            // TODO: Add Firebase Analytics successful signin here
            return new HomeNavigation(
              userId: _userId,
              logoutCallback: logoutCallback,
            );
          } else {
            // TODO: Add Firebase Analytics signin failure here
            return Container(
              child: Text('Issue with login, please contact the developer or try again.'),
            );
          }
          break;
        case AuthStatus.NOT_LOGGED_IN:
          return new LoginPage(
            auth: widget.auth,
            loginCallback: loginCallback,
            loginRequestName: loginRequestName,
          );
          break;
        case AuthStatus.REQUESTING_NAME:
          return new askUserForNamePage(
            auth: widget.auth,
            loginCallback: loginCallback,
          );
          break;
    }
  }
}
