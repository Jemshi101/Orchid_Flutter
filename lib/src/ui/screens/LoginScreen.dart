import 'package:Orchid/src/constants/Colors.dart';
import 'package:Orchid/src/decorations.dart';
import 'package:Orchid/src/styles.dart';
import 'package:Orchid/src/ui/BloC/LoginBloc.dart';
import 'package:Orchid/src/ui/core/BaseWidgetState.dart';
import 'package:Orchid/src/ui/screens/SearchScreen.dart';
import 'package:Orchid/src/ui/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

class _LoginScreenState extends BaseWidgetState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  LoginBloc _bloc;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<LoginBloc>(context);
    _bloc.snackBarStream.stream.listen((snackBarBean) {
      showSnackBar(
          snackBarBean.message, snackBarBean.time, snackBarBean.action);
    });

    return Scaffold(
      key: scaffoldKey,
      /*appBar: AppBar(
        // Here we take the value from the LoginScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/

      body: Container(
        alignment: AlignmentDirectional.topCenter,
        constraints: BoxConstraints.expand(),
        color: ColorConstant.CARBON,
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
              !_bloc.isLoggedIn
                  ? _bloc.isProgressVisible
                      ? LoadingWidget()
//                      _getLoadingLayout(context)
                      : _getLoginLayout(context)
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

  Widget _getLoginLayout(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        _getEmailTextField(context),
        _getPasswordTextField(context),
        _getSubmitButton(context),

        /*Text(
          '$_counter',
          style: Theme.of(context).textTheme.display3,
        ),*/
      ],
    );
  }

  Widget _getEmailTextField(BuildContext context) {
    return Padding(
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
            fieldFocusChange(context, _emailFocus, _passwordFocus);
          },
          style: Styles.getColoredTextTheme(
              Theme.of(context).textTheme.title, ColorConstant.WHITE),
          decoration: Decorations.getOutlineBoxFilled(
              ColorConstant.WHITE, "Email Address"),
        ),
      ),
    );
  }

  Widget _getPasswordTextField(BuildContext context) {
    return Padding(
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
          style: Styles.getColoredTextTheme(
              Theme.of(context).textTheme.title, ColorConstant.WHITE),
          decoration:
              Decorations.getOutlineBoxFilled(ColorConstant.WHITE, "Password"),
          obscureText: true,
        ),
      ),
    );
  }

  Widget _getSubmitButton(BuildContext context) {
    return Padding(
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
                style:
                    Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
              ),
            )),
      ),
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

    _bloc.processLogin(email, password);
  }
}
