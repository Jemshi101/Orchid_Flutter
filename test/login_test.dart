

import 'package:flutter_test/flutter_test.dart';
import 'package:Orchid/src/ui/screens/LoginScreen.dart';

main(){
  test("login validate on wrong input", (){
    var loginScreen = new _LoginScreenState();

    const email = "abcde";
    const password = "1234";
    
    expect(loginScreen.validate(email, password), false);

  });
}
