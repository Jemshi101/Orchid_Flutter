import 'package:Orchid/constants/AppConstants.dart';
import 'package:Orchid/constants/Colors.dart';
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
        color: ColorConstant.CARBON,
        child: isLoading
            ? _getLoadingLayout(context)
            : ListView(
                padding: const EdgeInsets.all(16.0),
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

  Widget _getHeaderLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: movieDetailResponse == null
          ? _getErrorHeaderLayout(context)
          : _getHeaderDetailLayout(),
    );
  }

  Widget _getErrorHeaderLayout(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Image.network(widget.movieBean.poster,
          fit: BoxFit.contain, alignment: AlignmentDirectional.topStart),
    );
  }

  Widget _getHeaderDetailLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Image.network(
                movieDetailResponse != null
                    ? movieDetailResponse.poster
                    : widget.movieBean.poster,
                fit: BoxFit.contain,
                alignment: AlignmentDirectional.topStart),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _getYearLayout(),
                _getGenreLayout(),
                _getLanguageLayout(),
                _getIMDBRatingLayout(),
                _getIMDBVotesLayout(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getYearLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Year : ',
          style: Styles.getColoredTextTheme(
              Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
          textAlign: TextAlign.start,
        ),
        Text(
          '${movieDetailResponse != null ? movieDetailResponse.year : widget.movieBean.year}',
          style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
          textAlign: TextAlign.start,
          textScaleFactor: .8,
        ),
      ],
    );
  }

  Widget _getGenreLayout() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Genre : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.genre}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getLanguageLayout() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Language : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.language}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getIMDBRatingLayout() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Rating : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.imdbRating}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getIMDBVotesLayout() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Votes : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.imdbVotes}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getMovieDetailsLayout(BuildContext context) {
    return Column(
      children: [
        _getTitleLayout(context),
        _getPlotSummaryLayout(context),
        _getDirectorLayout(context),
        _getCastLayout(context),
        _getWriterLayout(context),
        _getRuntimeLayout(context),
        _getWebsiteLayout(context),
        _getAwardsLayout(context),
        _getReleasedLayout(context),
        _getBoxOfficeLayout(context),
        _getRatedLayout(context),
        _getCountryLayout(context),
      ],
    );
  }

  Widget _getTitleLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Title : ',
          style: Styles.getColoredTextTheme(
              Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
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

  Widget _getPlotSummaryLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Plot Summary : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.plot}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getDirectorLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Director : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.director}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getCastLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Cast : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.actors}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getWriterLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Writer : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.writer}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getWebsiteLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Website : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.website}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getAwardsLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Awards : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.awards}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getRuntimeLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Runtime : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.runtime}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getReleasedLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Released : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.released}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getBoxOfficeLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Box Office : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.boxOffice}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getProductionLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Production : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.production}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getRatedLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Rated : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.rated}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
    );
  }

  Widget _getCountryLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Country : ',
            style: Styles.getColoredTextTheme(
                Theme.of(context).textTheme.subtitle, ColorConstant.OLAKKA),
            textAlign: TextAlign.start,
          ),
          Text(
            '${movieDetailResponse.country}',
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            textAlign: TextAlign.start,
            textScaleFactor: .8,
          ),
        ],
      ),
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
                backgroundColor: ColorConstant.BLACK,
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
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.asset(
                "assets/images/sloth.jpg",
                fit: BoxFit.scaleDown,
              ),
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
