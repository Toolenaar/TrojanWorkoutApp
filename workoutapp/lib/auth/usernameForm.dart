import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'baseAuth.dart';

class askUserForNamePage extends StatefulWidget {
  askUserForNamePage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _askUserForNamePageState createState() => _askUserForNamePageState();
}

class _askUserForNamePageState extends State<askUserForNamePage> {
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  bool agreedToEmail = false;
  bool agreedToPolicy = false;
  final _userNameKey = GlobalKey<FormState>();
  var userName;
  var snackBar;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/fonzIcons/backgroundMountain.png'),
            alignment: Alignment.bottomCenter,
          )),
          height: height,
          padding: EdgeInsets.fromLTRB(20, height * .4, 20, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(
                  "what's your name?",
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
              Form(
                key: _userNameKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                          maxLines: 1,
                          //                obscureText: true,
                          autofocus: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                          ),
                          validator: (value) =>
                              value.isEmpty ? 'Name can\'t be empty' : null,
                          onSaved: (value) => userName = value.trim(),
                          onChanged: (value) {
                            setState(() {
                              userName = value;
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          Container(
                            child: Row(children: [
                              Checkbox(
                                value: agreedToEmail,
                                onChanged: (value) {
                                  setState(() {
                                    agreedToEmail = !agreedToEmail;
                                  });
                                },
                              ),
                              Text(
                                "i want to stay updated on "
                                "\nFonz Music's growth via email",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            child: Row(children: [
                              Checkbox(
                                value: agreedToPolicy,
                                onChanged: (value) {
                                  setState(() {
                                    agreedToPolicy = !agreedToPolicy;
                                  });
                                },
                                activeColor: Colors.blue[700],
                              ),
                              Text(
                                "i agree to the privacy policy",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                          ),
                          Center(
                            child: FlatButton(
                              onPressed: () async {
                                await updateUserName(userName);
                                if (FirebaseAuth
                                        .instance.currentUser.displayName !=
                                    null) {
                                  dev.log("displayname: " +
                                      FirebaseAuth
                                          .instance.currentUser.displayName);
                                }
                                // Validate returns true if the form is valid, or false
                                // otherwise.
                                if (_userNameKey.currentState.validate()) {
                                  // tells firebase that the user gave a name
                                  FirebaseAnalytics()
                                      .logEvent(name: "UserGaveName");
                                  // If the form is valid, display a Snackbar.
//                              Scaffold.of(context)
//                                  .showSnackBar(

                                  snackBar = SnackBar(
                                    content: Text(
                                      'nice to meet you, '
                                      '${FirebaseAuth.instance.currentUser.displayName}'
                                      '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.red[600],
                                  );
                                }
                                Timer(Duration(seconds: 1),
                                    () => widget.loginCallback());
                              },
                              child: Text(
                                'submit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.red[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future updateUserName(newName) async {
    User user = await FirebaseAuth.instance.currentUser;
    user.updateProfile(displayName: newName);
    await user.reload();
  }
}
