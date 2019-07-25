import 'package:Orchid/src/constants/Colors.dart';
import 'package:Orchid/src/styles.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color textColor;

  const LoadingWidget({this.textColor = ColorConstant.WHITE});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: ColorConstant.BLACK,
                valueColor: new AlwaysStoppedAnimation(ColorConstant.WHITE),
              ),
              Padding(
                padding: EdgeInsets.all(50),
                child: Text(
                  'Please Wait...',
                  style: Styles.getColoredTextTheme(
                      Theme.of(context).textTheme.display1, textColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
