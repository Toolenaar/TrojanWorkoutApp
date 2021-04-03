import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

abstract class BaseAuth {
  // SignIn method
  Future<String> signIn(String email, String password, BuildContext context);
  // SignUp method
  Future<String> signUp(String email, String password, BuildContext context);
  // Reset Password method
  Future<void> resetPassword(String email, BuildContext context);
  // CurrentUser method
  Future<User> getCurrentUser();
  // Email Verification method
  Future<void> sendEmailVerification();
  // SignOut method
  Future<void> signOut();
  // Check Email Verification method
  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user.uid;
    } catch (e) {
      log('///////////////////////////');
      Toast.show(e.toString().substring(30), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print(e.toString());

      return null;
    }
  }

  Future<String> signUp(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user.uid;
    } catch (e) {
      print('/////////////////////');
      Toast.show(e.toString().substring(30), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return null;
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      log('email sent');
    } catch (e) {
      log('/////////////////////');
      Toast.show(e.toString().substring(30), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return null;
    }
  }

  Future<User> getCurrentUser() async {
    User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = await _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = await _firebaseAuth.currentUser;
    return user.emailVerified;
  }
}
