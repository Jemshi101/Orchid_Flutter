import 'package:flutter/material.dart';

class Styles {
  static getWhiteTextTheme(TextStyle textStyle) {
    return textStyle.apply(
      color: Colors.white,
    );
  }

  static getTextTheme() {
    return new TextStyle(
      color: Colors.white,
    );
  }

  static getInputBoxTheme() {
    return new ThemeData(
        primaryColor: Colors.purple,
        primaryColorDark: Colors.deepPurple,
        hintColor: Colors.deepPurpleAccent);
  }
}
