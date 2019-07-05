import 'package:flutter/material.dart';

/*abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<BaseEvent, BaseState> {
}*/
class BaseBloc extends ChangeNotifier {

  bool isProgressVisible = false;

}
