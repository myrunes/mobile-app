import 'package:flutter/cupertino.dart';

class LoginModel {
  bool _loggedIn;

  LoginModel();

  bool get loggedIn => 
    this._loggedIn;

  set loggedIn(bool v) {
    if (this._loggedIn != v) {
      this._loggedIn = v;
      // notifyListeners();
    }
  }
}