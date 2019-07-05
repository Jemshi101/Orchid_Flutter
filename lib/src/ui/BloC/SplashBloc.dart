import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:Orchid/src/ui/BloC/BaseBloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashBloc extends BaseBloc {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  StreamController isLoggedInStream = StreamController<bool>();
  bool isInit = true;

  checkForLogIn() async {
    log("In Check For Login");
//    Future.delayed(const Duration(seconds: 5), () {
    if (Platform.isAndroid || Platform.isIOS) {
      getFirebaseLoggedInStatus();
    } else {
      await Future.delayed(const Duration(seconds: 2), () {});
      _setLoggedInStatus(true);
    }
//    });

    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().contains(SharedPrefKeys.IS_LOGGED_IN)) {
      _setLoggedInStatus(prefs.getBool(SharedPrefKeys.IS_LOGGED_IN));
    } else {
      _setLoggedInStatus(false);
    }*/
    /*int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);*/
  }

  Future<FirebaseUser> getUser() async {
    return await firebaseAuth.currentUser();
  }

  getFirebaseLoggedInStatus() async {
    getUser().then((user) {
      if (user != null) {
        _setLoggedInStatus(true);
      } else {
        _setLoggedInStatus(false);
      }
    });
  }

  _setLoggedInStatus(bool isLoggedIn) {
/*    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
          this.isLoggedIn = isLoggedIn;
          isInit = false;

          Future.delayed(const Duration(seconds: 2), () {
            _processLogIn();
          });
        }));*/

    isInit = false;
    isLoggedInStream.sink.add(isLoggedIn);
  }

  @override
  void dispose() {
    isLoggedInStream.close();
    super.dispose();
  }
}
