import 'dart:async';

import 'package:Orchid/src/ui/events/BaseEvent.dart';
import 'package:Orchid/src/ui/states/BaseState.dart';
import 'package:bloc/bloc.dart';

abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<BaseEvent, BaseState> {
}
