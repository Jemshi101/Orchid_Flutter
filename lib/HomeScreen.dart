import 'dart:developer';

import 'package:Orchid/SearchScreen.dart';
import 'package:Orchid/constants/SharedPrefKeys.dart';
import 'package:Orchid/utils/ColorUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'styles.dart';

void main() => runApp(MyApp());

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
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'Orchid'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  int _counter = 0;

  bool isInit = true;
  bool isLoggedIn = false;
  bool isLogInVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setLoggedInStatus(bool isLoggedIn) {
    setState(() {
      isLogInVisible = !isLoggedIn;
      this.isLoggedIn = isLoggedIn;
      isInit = false;
    });
  }

  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => _checkForLogIn(context));
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      isInit = !isInit;

      if (_counter == 5) {
        isLoggedIn = true;
        isInit = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
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
              isInit
                  ? _getLoadingLayout(context)
                  : !isLoggedIn
                      ? _getLoginLayout(context)
                      : _navigateToSearchPage(),
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

  Flex _getLoadingLayout(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        CircularProgressIndicator(
          backgroundColor: ColorUtil.getColorFromHex('#ff000000'),
          valueColor: new AlwaysStoppedAnimation(ColorUtil('#ffffffff')),
        ),
        Padding(
          padding: EdgeInsets.all(50),
          child: Text(
            'Please Wait...',
            style:
                Styles.getWhiteTextTheme(Theme.of(context).textTheme.display1),
            textAlign: TextAlign.center,
          ),
        ),
      ],
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
              controller: _usernameController,
              style:
                  Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
              decoration: InputDecoration(
                  labelStyle:
                      TextStyle(color: ColorUtil.getColorFromHex("#ffffffff")),
                  filled: true,
                  labelText: 'Username',
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
              controller: _passwordController,
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
            color: Colors.purpleAccent,
            elevation: 5,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30), right: Radius.circular(30)),
            child: InkWell(
                key: Key("login"),
                highlightColor: Colors.amberAccent,
                splashColor: Colors.amber,
                enableFeedback: true,
                onTap: (){
                  _onLoginPressed();
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: Text(
                    "Login",
                    style: Styles.getWhiteTextTheme(
                        Theme.of(context).textTheme.display1),
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
    Route route = MaterialPageRoute(builder: (context) => SearchScreen());
    Navigator.push(context, route);
  }

  _checkForLogIn(BuildContext context) async {
    log("In Check For Login");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().contains(SharedPrefKeys.IS_LOGGED_IN)) {
      _setLoggedInStatus(prefs.getBool(SharedPrefKeys.IS_LOGGED_IN));
    } else {
      _setLoggedInStatus(false);
    }
    /*int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);*/
  }

  _onLoginPressed() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (validate(username, password)) {
      performLogin(username, password);
    }
  }

  bool validate(String username, String password) {
    if (username.isEmpty) {
      return false;
    }
    if (password.isEmpty || password.length < 8) {
      return false;
    }
    return true;
  }

  void performLogin(String username, String password) {
    //todo Login then navigate to Search Page

    _navigateToSearchPage();
  }
}
