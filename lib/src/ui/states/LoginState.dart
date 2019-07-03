import 'package:Orchid/src/ui/states/BaseState.dart';

class LoginState extends BaseState {
  bool isLoggedIn = false;

  LoginState._();

  factory LoginState.initial({isLoggedIn}) {
    return LoginState._()
      ..isLoggedIn = isLoggedIn;
  }
}
