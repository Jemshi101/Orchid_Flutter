import 'package:Orchid/models/MovieBean.dart';
import 'package:Orchid/network/models/MovieDetailResponse.dart';
import 'package:Orchid/utils/ColorUtil.dart';
import 'package:flutter/material.dart';

import 'styles.dart';

class MovieDetailScreen extends StatefulWidget {
  MovieDetailScreen(this.movieBean, {Key key, this.title}) : super(key: key);

  final String title;
  final MovieBean movieBean;
  MovieDetailResponse movieDetailResponse;

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _counter = 0;

  bool isLoading = false;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Container(
        constraints: BoxConstraints.expand(),
        color: ColorUtil.getColorFromHex('#ff2a2a2a'),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Image.network(
                widget.movieDetailResponse != null
                    ? widget.movieDetailResponse.poster
                    : widget.movieBean.poster,
                fit: BoxFit.contain,
                alignment: AlignmentDirectional.topStart),
            isLoading
                ? _getLoadingLayout(context)
                : widget.movieDetailResponse == null
                    ? _getErrorLayout(context)
                    : Flexible(child: _getMovieDetailsLayout(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _getLoadingLayout(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Flex(direction: Axis.vertical, children: [
          CircularProgressIndicator(
            backgroundColor: ColorUtil.getColorFromHex('#ff000000'),
            valueColor: new AlwaysStoppedAnimation(ColorUtil('#ffffffff')),
          ),
          Padding(
            padding: EdgeInsets.all(50),
            child: Text(
              'Please Wait...',
              style: Styles.getWhiteTextTheme(
                  Theme.of(context).textTheme.display1),
              textAlign: TextAlign.center,
            ),
          ),
        ]));
  }

  Widget _getErrorLayout(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
            child: Image.asset(
              "assets/images/sloth.jpg",
              fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            child: Text(
              'Movie Detail Not Found!!!',
              style: Styles.getWhiteTextTheme(
                  Theme.of(context).textTheme.display1),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMovieDetailsLayout(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
            child: Image.asset(
              "assets/images/sloth.jpg",
              fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            child: Text(
              'Movie Detail Not Found!!!',
              style: Styles.getWhiteTextTheme(
                  Theme.of(context).textTheme.display1),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
