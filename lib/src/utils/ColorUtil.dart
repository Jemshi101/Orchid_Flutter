import 'package:flutter/material.dart';

class ColorUtil extends Color {
  static int getColorIntFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static int getColorHexFromStringHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static Color getColorFromHex(String hexColor) {
    return new Color(getColorIntFromHex(hexColor));
  }

  ColorUtil(final String hexColor) : super(getColorIntFromHex(hexColor));
}
