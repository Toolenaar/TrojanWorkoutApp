import 'package:flutter/material.dart';
import 'package:workoutapp/auth/baseAuth.dart';

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
}
