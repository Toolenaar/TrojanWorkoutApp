import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: CupertinoButton(
          onPressed: () => {FirebaseAuth.instance.signOut()},
          child: Row(children: <Widget>[Icon(Icons.logout), Text('Log Out')]),
        ),
      ),
    );
  }
}
