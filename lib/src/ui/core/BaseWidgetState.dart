

import 'package:flutter/material.dart';

abstract class BaseWidgetState<T extends StatefulWidget> extends State<T>{

  var scaffoldKey = new GlobalKey<ScaffoldState>();


  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  showSnackBar(String message, Duration time, SnackBarAction action) {
    var snackBar;
    if (action == null) {
      snackBar = SnackBar(
        content: Text(message),
        duration: time,
      );
    } else {
      snackBar = SnackBar(
        content: Text(message),
        action: action,
        duration: time,
      );
    }

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

}