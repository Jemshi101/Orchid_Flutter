import 'package:Orchid/src/ui/BloC/BaseBloc.dart';
import 'package:Orchid/src/ui/states/BaseState.dart';

class LoginBloc extends BaseBloc {
  @override
  // TODO: implement initialState
  BaseState get initialState => null;


  @override
  Stream<BaseState> mapEventToState(event) async* {
    /*if (event is ShowSnackbarEvent) {
      if (showSnackbarState == null) {
        showSnackbarState = ShowSnackbarState.initial();
      }
      yield showSnackbarState;
    }
*/
    yield null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
