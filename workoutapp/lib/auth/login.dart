import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:workoutapp/auth/baseAuth.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback, this.loginRequestName});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback loginRequestName;

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

  Widget _showForm() {}

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
                    'Sign In',
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
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
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
          assert(user.uid = userId);
          Navigator.pop(context);
          return '$user';
        }
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

  
}
