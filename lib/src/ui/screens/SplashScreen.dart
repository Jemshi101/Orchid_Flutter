import 'package:Orchid/src/constants/Colors.dart';
import 'package:Orchid/src/ui/BloC/SplashBloc.dart';
import 'package:Orchid/src/ui/core/BaseState.dart';
import 'package:Orchid/src/ui/screens/LoginScreen.dart';
import 'package:Orchid/src/ui/screens/SearchScreen.dart';
import 'package:Orchid/src/ui/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  SplashBloc _bloc;

  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => _bloc.checkForLogIn());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = Provider.of<SplashBloc>(context);

//      _bloc.checkForLogIn();

      _bloc.snackBarStream.stream.listen((snackBarBean) {
        showSnackBar(
            snackBarBean.message, snackBarBean.time, snackBarBean.action);
      });
      _bloc.isLoggedInStream.stream.listen((isLoggedIn) {
        _processLogIn(isLoggedIn);
      });
    }
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

      /* initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) {
              return !isInit && isLoggedIn != null && isLoggedIn
                  ? SearchScreen("Olakka")
                  : LoginScreen();
            });
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/browse':
            return MaterialPageRoute(builder: (_) => SearchScreen("olakka2"));
        }
      },
*/
      body: Container(
        alignment: AlignmentDirectional.topCenter,
        constraints: BoxConstraints.expand(),
        color: ColorConstant.CARBON,
        child: ListView(children: [
          _getLogo(),
//          _getLoadingLayout(context)
          LoadingWidget(),
        ]),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Container _getLogo() {
    return Container(
      width: 200,
      height: 200,
      margin: EdgeInsets.all(100),
      child: Image.asset(
        'assets/images/logo.png',
        alignment: AlignmentDirectional.topCenter,
        fit: BoxFit.contain,
      ),
    );
  }

  /*Flex _getLoadingLayout(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        CircularProgressIndicator(
          backgroundColor: ColorConstant.BLACK,
          valueColor: new AlwaysStoppedAnimation(ColorConstant.COLOR_PRIMARY),
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
  }*/

  _navigateToSearchPage(BuildContext context) {
    Route route =
        MaterialPageRoute(builder: (context) => SearchScreen("Orchid"));
    Navigator.pushReplacement(context, route);
  }

  _navigateToLoginPage(BuildContext context) {
    Route route = MaterialPageRoute(builder: (context) => LoginScreen());
    Navigator.pushReplacement(context, route);
  }

  void _processLogIn(isLoggedIn) {
    !_bloc.isInit && isLoggedIn != null && isLoggedIn
        ? _navigateToSearchPage(context)
        : _navigateToLoginPage(context);
  }
}
