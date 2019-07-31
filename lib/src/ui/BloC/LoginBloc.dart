import 'dart:async';

import 'package:Orchid/src/constants/SharedPrefKeys.dart';
import 'package:Orchid/src/models/MessageBean.dart';
import 'package:Orchid/src/ui/BloC/BaseBloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends BaseBloc {
  final firebaseAuth = FirebaseAuth.instance;

  StreamController<bool> isLoggedInController = StreamController();

  bool isLoggedIn = false;

  @override
  void dispose() {
    isLoggedInController.close();
    super.dispose();
  }

  Future<FirebaseUser> getUser() async {
    return await firebaseAuth.currentUser();
  }

  void _saveUser(FirebaseUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.USER_ID, user.uid);
    await prefs.setBool(SharedPrefKeys.IS_LOGGED_IN, true);
  }

  bool validate(String email, String password) {
    if (email.isEmpty) {
      snackBarStream.sink.add(SnackBarBean("Please Enter the Email Address",
          time: Duration(seconds: 5)));
      return false;
    }
    if (password.isEmpty || password.length < 8) {
      snackBarStream.sink.add(SnackBarBean("Please Enter the Password",
          time: Duration(seconds: 5)));
      return false;
    }
    return true;
  }

  _performLogin(String email, String password) async {
    await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) {
      if (authResult != null) {
        _setLoading(false);
        _saveUser(authResult.user);
        _setLoggedIn(true);
        snackBarStream.sink.add(SnackBarBean(
            "Welcome ${authResult.user.email}",
            time: Duration(seconds: 5)));
      }
    }).catchError((e) {
      _setLoading(false);
      notifyListeners();
      print(e);
      if (e.code == "ERROR_USER_NOT_FOUND") {
        _performSignUp(email, password);
      } else {
        snackBarStream.sink
            .add(SnackBarBean(e.message, time: Duration(seconds: 5)));
      }
    });
  }

  _performSignUp(String email, String password) async {
    _setLoading(true);
    notifyListeners();

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((authResult) {
      if (authResult != null && authResult.user != null) {
        _setLoading(false);
        _saveUser(authResult.user);
        snackBarStream.sink.add(SnackBarBean("Welcome ${authResult.user.email}",
            time: Duration(seconds: 5)));
        _setLoggedIn(true);
      } else {
        snackBarStream.sink.add(SnackBarBean(
            "User registration failed. Please try again later!!!!",
            time: Duration(seconds: 5)));
      }
      _setLoggedIn(false);
    }).catchError((e) {
      snackBarStream.sink
          .add(SnackBarBean(e.details, time: Duration(seconds: 5)));
      _setLoggedIn(false);
    });
  }

  void processLogin(String email, String password) {
    _setLoading(true);
    notifyListeners();
    if (validate(email, password)) {
      _performLogin(email, password);
    } else {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool isLoading) {
    this.isProgressVisible = isLoading;
  }

  void _setLoggedIn(bool isLoggedIn) {
    this.isLoggedIn = isLoggedIn;
    notifyListeners();
    isLoggedInController.sink.add(isLoggedIn);
  }
}
