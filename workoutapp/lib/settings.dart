import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workoutapp/auth/login/rootPage.dart';

class Settings extends StatefulWidget {
  Settings({this.logoutCallback});

  final VoidCallback logoutCallback;
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text("Are you sure you want to log out?"),
                              content: Text(
                                  "You will be redirected to the home page and have to sign in again in order to use the app"),
                              actions: [
                                Container(
                                  child: TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () =>
                                          Navigator.of(context).pop()),
                                ),
                                Container(
                                  child: TextButton(
                                    child: Text("Log Out"),
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      widget.logoutCallback();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                              ]);
                        });
                  },
                  child: Row(children: <Widget>[
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
                ),
              ))
        ],
      ),
    ));
  }
}
