import 'package:Orchid/SearchScreen.dart';
import 'package:Orchid/constants/SharedPrefKeys.dart';
import 'package:Orchid/utils/ColorUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'styles.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final firebaseAuth = FirebaseAuth.instance;

  int _counter = 0;

  bool isLoggedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setLoggedInStatus(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  Future<FirebaseUser> getUser() async {
    return await firebaseAuth.currentUser();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;

      if (_counter == 5) {
        isLoggedIn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*appBar: AppBar(
        // Here we take the value from the LoginScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/

      body: Container(
        alignment: AlignmentDirectional.topCenter,
        constraints: BoxConstraints.expand(),
        color: ColorUtil.getColorFromHex('#ff2a2a2a'),
        child: ListView(children: [
          Flex(
            direction: Axis.vertical,
            children: [
              Container(
                width: 200,
                height: 200,
                margin: EdgeInsets.all(100),
                child: Image.asset('assets/images/logo.png',
                    alignment: AlignmentDirectional.topCenter),
              ),
              !isLoggedIn ? _getLoginLayout(context) : _navigateToSearchPage(),
            ],
          )
        ]),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Flex _getLoginLayout(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Theme(
            data: Styles.getInputBoxTheme(),
            child: TextField(
              textInputAction: TextInputAction.next,
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              focusNode: _emailFocus,
              controller: _emailController,
              onSubmitted: (text) {
                _fieldFocusChange(context, _emailFocus, _passwordFocus);
              },
              style:
                  Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
              decoration: InputDecoration(
                  labelStyle:
                      TextStyle(color: ColorUtil.getColorFromHex("#ffffffff")),
                  filled: true,
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Theme(
            data: Styles.getInputBoxTheme(),
            child: TextField(
              textInputAction: TextInputAction.done,
              maxLines: 1,
              autofocus: false,
              focusNode: _passwordFocus,
              controller: _passwordController,
              onSubmitted: (text) {
                _passwordFocus.unfocus();
              },
              style:
                  Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
              decoration: InputDecoration(
                  labelStyle:
                      TextStyle(color: ColorUtil.getColorFromHex("#ffffffff")),
                  filled: true,
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
              obscureText: true,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
          child: Material(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.horizontal(
//                    left: Radius.circular(30), right: Radius.circular(30))),
            color: Colors.purpleAccent,
            elevation: 5,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30), right: Radius.circular(30)),
            child: InkWell(
                radius: 30,
                key: Key("login"),
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30), right: Radius.circular(30)),
                highlightColor: Colors.amberAccent,
                splashColor: Colors.amber,
                enableFeedback: true,
                onTap: () {
                  _onLoginPressed();
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                  child: Text(
                    "Login",
                    style: Styles.getWhiteTextTheme(
                        Theme.of(context).textTheme.title),
                  ),
                )),
          ),
        ),

        /*Text(
          '$_counter',
          style: Theme.of(context).textTheme.display3,
        ),*/
      ],
    );
  }

  _navigateToSearchPage() {
    Route route =
        MaterialPageRoute(builder: (context) => SearchScreen("Orchid"));
    Navigator.pushReplacement(context, route);
  }

  _onLoginPressed() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (validate(email, password)) {
      _performLogin(email, password);
    }
  }

  bool validate(String email, String password) {
    if (email.isEmpty) {
      _showSnackBar(
          "Please Enter the Email Address", Duration(seconds: 5), null);
      return false;
    }
    if (password.isEmpty || password.length < 8) {
      _showSnackBar("Please Enter the Password", Duration(seconds: 5), null);
      return false;
    }
    return true;
  }

  _performLogin(String email, String password) async {
    await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      if (user != null) {
        _saveUser(user);
        _navigateToSearchPage();
      }
    }).catchError((e) {
      print(e);
      if (e.code == "ERROR_USER_NOT_FOUND") {
        _performSignUp(email, password);
      } else {
        _showSnackBar(e.details, Duration(seconds: 10), null);
      }
    });
  }

  void _saveUser(FirebaseUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.USER_ID, user.uid);
    await prefs.setBool(SharedPrefKeys.IS_LOGGED_IN, true);
  }

  _performSignUp(String email, String password) async {
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((user) {
      if (user != null) {
        _saveUser(user);
        _navigateToSearchPage();
      } else {
        _showSnackBar("User registration failed. Please try again later!!!!",
            Duration(seconds: 5), null);
      }
    }).catchError((e) {
      _showSnackBar(e.details, Duration(seconds: 10), null);
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _showSnackBar(String message, Duration time, SnackBarAction action) {
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
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
