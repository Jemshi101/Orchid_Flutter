import 'package:Orchid/constants/AppConstants.dart';
import 'package:Orchid/models/MovieBean.dart';
import 'package:Orchid/network/DataManager.dart';
import 'package:Orchid/network/models/MovieDetailResponse.dart';
import 'package:Orchid/utils/ColorUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'styles.dart';

class MovieDetailScreen extends StatefulWidget {
  MovieDetailScreen(this.movieBean, {Key key, this.title}) : super(key: key);

  final String title;
  final MovieBean movieBean;

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _counter = 0;

  bool isLoading = true;

  MovieDetailResponse movieDetailResponse;

  @override
  void initState() {
//    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _fetchMovieDetails(widget.movieBean));
//    }
    super.initState();
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
        child: isLoading
            ? _getLoadingLayout(context)
            : ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  _getHeaderLayout(),
                  movieDetailResponse == null
                      ? _getErrorLayout(context)
                      : _getMovieDetailsLayout(context),
                ],
              ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), */ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding _getHeaderLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: FractionallySizedBox(
        alignment: Alignment.topLeft,
        widthFactor: .5,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.network(
              movieDetailResponse != null
                  ? movieDetailResponse.poster
                  : widget.movieBean.poster,
              fit: BoxFit.contain,
              alignment: AlignmentDirectional.topStart),
        ),
      ),
    );
  }

  Widget _getMovieDetailsLayout(BuildContext context) {
    return Column(
      children: [
        _getTitleLayout(context),
      ],
    );
  }

  Widget _getLoadingLayout(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
    return Center(
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

  Widget _getTitleLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Title : ',
          style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.subtitle),
          textAlign: TextAlign.start,
        ),
        Text(
          '${movieDetailResponse != null ? movieDetailResponse.title : widget.movieBean.title}',
          style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  _fetchMovieDetails(MovieBean movieBean) async {
    _setLoading(true);

    DataManager.getMovieDetails(movieBean.imdbID, AppConstants.PLOT_TYPE_FULL)
        .then((value) {
      movieDetailResponse = value.responseBody;

      _setLoading(false);
    }).catchError((error) {
      _setLoading(false);
    });
  }

  void _setLoading(isLoadingRequired) {
    setState(() {
      isLoading = isLoadingRequired;
    });
  }
}
