import 'dart:developer';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';
import 'package:workoutapp/auth/baseAuth.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  LoginPage(
      {this.auth, this.loginCallback, this.loginRequestName, this.requests});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback loginRequestName;
  final requests;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading;
  bool _isLoginForm;
  String _email;
  String _password;
  String _errorMessage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _errorMessage = '';
    _isLoading = false;
    _isLoginForm = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Stack(
        children: <Widget>[_showForm()],
      )),
    );
  }

  Widget showProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 1.0,
      width: 5.0,
      child: Text('error'),
    );
  }

  void toggleFormMode() {
    /* TODO: Implement methods below
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
    */
    throw UnimplementedError();
  }

  Widget _showForm() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    // TODO: Add in a logo
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(24.0),
          child: new Form(
              child: Padding(
            padding: EdgeInsets.only(top: height * .2),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, color: Colors.red),
                  ),
                ),
                _googleSignInButton(),
                _emailSignInButton()
              ],
            ),
          )),
        )
      ],
    );
  }

  bool validateAndSave(_key) {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  bool validateEmailAndSave(_key) {
    final form = _key.currentState;
    if (EmailValidator.validate(_email)) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<String> signUpUser(_email, _password, key) async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });
    if (validateAndSave(key)) {
      String userId = '';
      try {
        userId = await widget.auth.signUp(_email, _password, context);
        setState(() {
          _isLoading = false;
        });
        if (userId != null && userId.length > 0 && _isLoginForm) {
          final User user = _auth.currentUser;
          assert(user.uid == userId);
          Navigator.pop(context);
          return '$user';
        }
      } catch (e) {
        log('///////////////////////////');
        Toast.show(e.toString().substring(30), context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print(e.toString());
        try {
          userId = await widget.auth.signIn(_email, _password, context);
          setState(() {
            _isLoading = false;
          });
          if (userId.length > 0 && userId != null && _isLoginForm) {
            final User user = _auth.currentUser;
            assert(user.uid == userId);
            log("account already active with user: " + userId);
            Navigator.pop(context);
            return '$user';
          }
        } catch (e) {
          print(e.toString());
          setState(() {
            _isLoading = false;
            _errorMessage = e?.message;
            _formKey.currentState.reset();
          });
        }
      }
    }
  }

  Future<String> signInUser(_email, _password, key) async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });
    if (validateAndSave(key)) {
      String userId = '';
      try {
        userId = await widget.auth.signIn(_email, _password, context);
        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 && userId != null && _isLoginForm) {
          final User user = _auth.currentUser;
          assert(user.uid == userId);
          Navigator.pop(context);
          return '$user';
        }
      } catch (e) {
        log('///////////////////////////');
        Toast.show(e.toString().substring(30), context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print(e.toString());
        showDialog(
            context: context,
            builder: (BuildContext context) {
              _signInKey.currentState.reset();
              return Dialog(child: Text('Invalid details please try again.'));
            });
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  Future<String> resetPassword(_password, key) async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });
    if (validateEmailAndSave(key)) {
      String userId = '';
      try {
        await widget.auth.resetPassword(_password, context);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        log('///////////////////////////');
        Toast.show(e.toString().substring(30), context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print(e.toString());
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

//------------------------Email Sign In----------------------//
  PageController _emailController = PageController(initialPage: 0);

  void _emailSignInPopup(context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    showModalBottomSheet(
            context: context,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            builder: (BuildContext bc) {
              return Container(
                height: height * .8,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Center(
                  child: Container(
                    child: PageView(
                      controller: _emailController,
                      scrollDirection: Axis.horizontal,
                      children: [_signUpForm(), _signInForm()],
                    ),
                  ),
                ),
              );
            },
            isScrollControlled: true)
        .then((val) {
      if (FirebaseAuth.instance.currentUser != null) {
        widget.loginRequestName();
      }
    });
  }

  final _signInKey = GlobalKey<FormState>();

  Widget _signInForm() {
    return Form(
      key: _signInKey,
      child: Column(
        children: [
          Icon(Icons.mail_outline, size: 70, color: Colors.grey[700]),
          showEmailInputSignIn(),
          showPasswordInputSignIn(),
          showPrimarySignInButton(),
          showSecondarySignInButton(),
          showForgotPasswordButton()
        ],
      ),
    );
  }

  final _signUpKey = GlobalKey<FormState>();
  Widget _signUpForm() {
    return Form(
      key: _signUpKey,
      child: Column(
        children: [
          Icon(Icons.mail_outline, size: 70, color: Colors.grey[700]),
          showEmailInputSignUp(),
          showPasswordInputSignUp(),
          showPrimarySignUpButton(),
          showSecondarySignUpButton()
        ],
      ),
    );
  }

  bool err = true;

  Widget _emailSignInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () => _emailSignInPopup(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.mail_outline,
                size: 30,
                color: Colors.grey[700],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Text('Sign Up with Email',
                    style: TextStyle(fontSize: 20, color: Colors.grey[700])),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showPrimarySignUpButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: SizedBox(
        height: 40,
        child: new FlatButton(
          onPressed: () async {
            try {
              signUpUser(_email, _password, _signUpKey);
            } catch (e) {
              log(e.toString());
            }
          },
          child: new Text('Sign Up',
              style: new TextStyle(fontSize: 20, color: Colors.black)),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget showSecondarySignUpButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Text(
            'Already Have an Account?',
            style: new TextStyle(
                fontSize: 20, fontWeight: FontWeight.w300, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FlatButton(
                child: Text('Sign In',
                    style: new TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300)),
                onPressed: () => _emailController.animateToPage(1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn)),
          )
        ],
      ),
    );
  }

  Widget showEmailInputSignIn() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Padding(
        padding: EdgeInsets.fromLTRB(20, height * 0.05, 20, 0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Email',
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            ),
            validator: (value) =>
                value.isEmpty ? 'Email can\'t be empty' : null,
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
        ));
  }

  Widget showPasswordInputSignIn() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            hintText: "password",
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
          validator: (value) =>
              value.isEmpty ? 'Password can\'t be empty' : null,
          onChanged: (value) {
            setState(() {
              _password = value;
            });
//            print(_email);
          },
        ),
      ),
    );
  }

  Widget showPrimarySignInButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: new Text(
            'Sign In',
            style: new TextStyle(fontSize: 20.0, color: Colors.black),
          ),
          onPressed: () async {
            signInUser(
              _email,
              _password,
              _signInKey,
            );
          },
        ),
      ),
    );
  }

  Widget showSecondarySignInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: new FlatButton(
          child: Row(
            children: [
              Text(
                "New to Trojan? ",
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Text("Sign Up!",
                  style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  )),
            ],
          ),
          onPressed: () => _emailController.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn)),
    );
  }

  Widget showForgotPasswordButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: new FlatButton(
              child: Row(
                children: [
                  Text(
                    "Forgot Password? ",
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  Text("Send Reset Email",
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      )),
                ],
              ),
              onPressed: () async {
                resetPassword(
                  _email,
                  _signInKey,
                );
                Toast.show("sent reset password email", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            )));
  }

  //------------------------------Sign UP-------------------------------------
  Widget showEmailInputSignUp() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, height * .05, 20.0, 0.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: "Email",
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
          onChanged: (value) {
            setState(() {
              _email = value;
            });
//            print(_email);
          },
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value.trim(),
        ),
      ),
    );
  }

  Widget showPasswordInputSignUp() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            hintText: "Password",
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
          onChanged: (value) {
            setState(() {
              _password = value;
            });
            print(_password);
          },
          validator: (value) =>
              value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value.trim(),
        ),
      ),
    );
  }

// ----------------------------Google sign in---------------------------------

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    log(googleSignInAccount.displayName);
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    if (user.displayName != null) {
      log(user.displayName);
    }

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = await widget.auth.getCurrentUser();
//      widget.loginCallback();
      widget.loginRequestName();
      assert(user.uid == currentUser.uid);

      return '$user';
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }

  Widget _googleSignInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          signInWithGoogle();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: <Widget>[
              Image(
                  image: AssetImage("assets/thirdParties/googleLogo.png"),
                  height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// ------------------------------Apple Sign in----------------------------

  Widget _appleSignInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          log('pressed');
          signInWithApple().catchError((e) => showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                builder: (context) => Container(
                  child: Text('Error with Apple Sign In'),
                ),
              ));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
//          mainAxisSize: MainAxisSize.min,
//          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/thirdParties/appleLogo.png"),
                  height: 32.0),
              Padding(
                padding: const EdgeInsets.only(left: 53),
                child: Text(
                  'Sign In with Apple',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> signInWithApple() async {
    if (!await AppleSignIn.isAvailable()) {
      throw Exception(
          "Your Device Does Not Currently Support Apple Sign In"); //Break from the program
    }
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
      // here we're going to sign in the user within firebase   break;
      case AuthorizationStatus.error:
        // do something
        break;

      case AuthorizationStatus.cancelled:
        break;
    }
    final AppleIdCredential appleIdCredential = result.credential;

    OAuthProvider oAuthProvider = new OAuthProvider("apple.com");
    final AuthCredential credential = oAuthProvider.credential(
      idToken: String.fromCharCodes(appleIdCredential.identityToken),
      accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = await widget.auth.getCurrentUser();
//      widget.loginCallback();
      widget.loginRequestName();
      assert(user.uid == currentUser.uid);

      return '$user';
    }

    return null;
  }
}
