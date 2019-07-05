import 'package:flutter/material.dart';

class SnackBarBean {
  static const DEFAULT_TIME = Duration(seconds: 1);

  String message = "";
  Duration time = Duration(seconds: 1);
  SnackBarAction action;

  SnackBarBean(this.message, {this.time = DEFAULT_TIME, this.action});
}
