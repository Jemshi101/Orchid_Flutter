import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  showSnackBar(String message, Duration time, SnackBarAction action) {
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    scaffoldKey.currentState.showSnackBar(
      action == null
          ? SnackBar(
              content: Text(message),
              duration: time,
            )
          : SnackBar(
              content: Text(message),
              action: action,
              duration: time,
            ),
    );
  }
}
