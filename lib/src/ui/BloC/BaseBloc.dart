import 'dart:async';

import 'package:Orchid/src/models/MessageBean.dart';
import 'package:Orchid/src/ui/events/BaseEvent.dart';
import 'package:bloc/bloc.dart';

class BaseBloc extends Bloc {
  final messageController = StreamController<SnackBarBean>();
  final progressVisibilityController = StreamController<bool>();

  @override
  get initialState => (){
    messageController.add(null);
    progressVisibilityController.add(false);

  };

  @override
  Stream mapEventToState(event) {
    switch (event) {
      case BaseEvent.SHOW_SNACKBAR:
        return messageController.stream;
      case BaseEvent.PROGRESS_VISIBILITY:
        return progressVisibilityController.stream;
    }

    return null;
  }

  @override
  void dispose() {
    messageController.close();
    progressVisibilityController.close();
    super.dispose();
  }
}
