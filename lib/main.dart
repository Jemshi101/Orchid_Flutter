import 'dart:io';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

import 'screens/SplashScreen.dart';

bool isLoggedIn = false;
bool isInit = true;

void main() {
//  isLoggedIn = await _checkForLogIn();
//  _checkForLogIn();

  _setTargetPlatformForDesktop();
  runApp(MyApp());
}

void _setTargetPlatformForDesktop() {

  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
//    targetPlatform = TargetPlatform.iOS;
    targetPlatform = TargetPlatform.fuchsia;
  } else if (Platform.isLinux || Platform.isWindows) {
//    targetPlatform = TargetPlatform.android;
    targetPlatform = TargetPlatform.fuchsia;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}


/*_checkForLogIn() async {
  getUser().then((user) {
    isLoggedIn = user != null ? true : false;
    isInit = false;
  });
}

Future<FirebaseUser> getUser() async {
  final firebaseAuth = FirebaseAuth.instance;
  return await firebaseAuth.currentUser();
}*/

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orchid',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: SplashScreen(title: 'Orchid'),
    );
  }
}

