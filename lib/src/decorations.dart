import 'package:Orchid/src/constants/Colors.dart';
import 'package:flutter/material.dart';

class Decorations {
  static const OUTLINE_BOX_FILLED = InputDecoration(
      labelStyle: TextStyle(color: ColorConstant.WHITE),
      filled: true,
      labelText: 'Password',
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))));

  static InputDecoration getOutlineBoxFilled(Color textColor, String label){
    return InputDecoration(
        labelStyle: TextStyle(color: textColor),
        filled: true,
        labelText: label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))));
  }
}
