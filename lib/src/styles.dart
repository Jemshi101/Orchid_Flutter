import 'package:flutter/material.dart';

class Styles {
  static getWhiteTextTheme(TextStyle textStyle) {
    return textStyle.apply(
      color: Colors.white,
    );
  }

  static getColoredTextTheme(TextStyle textStyle, Color color) {
    return textStyle.apply(
      color: color,
    );
  }

  static getTextTheme() {
    return new TextStyle(
      color: Colors.white,
    );
  }

  static getInputBoxTheme() {
    return new ThemeData(
        primaryColor: Colors.purpleAccent,
        primaryColorDark: Colors.purple[500],
        hintColor: Colors.purple[500]);
  }
}
