import 'dart:developer';

import 'package:Orchid/LoginScreen.dart';
import 'package:Orchid/SearchScreen.dart';
import 'package:Orchid/utils/ColorUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'styles.dart';

bool isLoggedIn = false;

void main() async {
  isLoggedIn = await _checkForLogIn();

  runApp(MyApp());
}

_checkForLogIn() async {
  getUser().then((user) {
    return user != null ? true : false;
  });
}

Future<FirebaseUser> getUser() async {
  final firebaseAuth = FirebaseAuth.instance;
  return await firebaseAuth.currentUser();
}

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
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) {
              return isLoggedIn != null && isLoggedIn
                  ? SearchScreen()
                  : LoginScreen();
            });
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/browse':
            return MaterialPageRoute(builder: (_) => SearchScreen());
        }
      },
//      home: MyHomePage(title: 'Orchid'),
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
  final firebaseAuth = FirebaseAuth.instance;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _counter = 0;

  bool isInit = true;
  bool isLoggedIn = false;

  void _setLoggedInStatus(bool isLoggedIn) {
    setState(() {
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

  _checkForLogIn(BuildContext context) async {
    Future.delayed(const Duration(seconds: 5), () {
      getUser().then((user) {
        if (user != null) {
          _setLoggedInStatus(true);
        } else {
          _setLoggedInStatus(false);
        }
      });
    });

    log("In Check For Login");
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
      key: _scaffoldKey,
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
              _getLoadingLayout(context),
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

  _navigateToSearchPage() {
    Route route = MaterialPageRoute(builder: (context) => SearchScreen());
    Navigator.pushReplacement(context, route);
  }
}
