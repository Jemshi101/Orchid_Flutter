import 'dart:async';

import 'package:Orchid/src/models/MessageBean.dart';
import 'package:flutter/material.dart';

/*abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<BaseEvent, BaseState> {
}*/
class BaseBloc extends ChangeNotifier {

  bool isProgressVisible = false;

  StreamController<SnackBarBean> snackBarStream = StreamController<SnackBarBean>();

  @override
  void dispose() {
    snackBarStream.close();
    super.dispose();
  }

}
