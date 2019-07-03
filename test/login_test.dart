

import 'package:Orchid/src/ui/BloC/LoginBloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Orchid/src/ui/screens/LoginScreen.dart';

main(){
  test("login validate on wrong input", (){
    var loginScreen = new LoginBloc();

    const email = "abcde";
    const password = "1234";
    
    expect(loginScreen.validate(email, password), false);

  });
}
