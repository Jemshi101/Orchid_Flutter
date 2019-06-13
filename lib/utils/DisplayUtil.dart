
import 'package:flutter/material.dart';

class DisplayUtil {
  static double getDisplayWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getDisplayHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
