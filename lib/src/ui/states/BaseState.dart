import 'dart:async';

import 'package:Orchid/src/models/MessageBean.dart';
import 'package:equatable/equatable.dart';

class BaseState extends Equatable {
  BaseState([List props = const []]) : super(props);

  bool isProgressVisible = false;
  SnackBarBean snackbarBean;
}
