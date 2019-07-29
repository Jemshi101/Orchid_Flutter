import 'package:Orchid/src/constants/Colors.dart';
import 'package:Orchid/src/models/MovieBean.dart';
import 'package:Orchid/src/styles.dart';
import 'package:Orchid/src/ui/BloC/SearchBloc.dart';
import 'package:Orchid/src/ui/core/BaseWidgetState.dart';
import 'package:Orchid/src/ui/screens/MovieDetailScreen.dart';
import 'package:Orchid/src/ui/widgets/LoadingWidget.dart';
import 'package:Orchid/src/utils/ColorUtil.dart';
import 'package:Orchid/src/utils/DisplayUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String _title = "";
double currentScrollOffset = -1;

class SearchScreen extends StatefulWidget {
  SearchScreen(String title, {Key key}) : super(key: key) {
    _title = title;
  }

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseWidgetState<SearchScreen> {
  final _searchController = TextEditingController();
  ScrollController _scrollController;

  SearchBloc _bloc;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _searchController.removeListener(_scrollListener);
    _searchController.dispose();
//    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
//    if (currentScrollOffset > 0) _scrollController.jumpTo(currentScrollOffset);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    currentScrollOffset = _scrollController.offset;

//    if (_scrollController.offset >=
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      /*if (_bloc.currentSearchResponse != null &&
          _bloc.currentSearchResponse.movieList.length <
              num.parse(_bloc.currentSearchResponse.totalResults)) {}
      */
      _bloc.onSearchQueryEntered(_searchController.text, false);
      //          message = "reach the bottom";
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      //          message = "reach the top";
    }
  }

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<SearchBloc>(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_title),
      ),

      body: Stack(
        children: <Widget>[
//          _getMovieGridLayout(context),
          Container(
            constraints: BoxConstraints.expand(),
            color: ColorConstant.CARBON,
          ),
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTapDown: (TapDownDetails details){
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              children: <Widget>[
//              if (isLoading) LinearProgressIndicator(),
                _getSearchBoxLayout(context),
//              _getMovieGridLayout(context),
                _bloc.isProgressVisible
//                    ? _getLoadingLayout(context)
                    ? LoadingWidget()
                    : _bloc.isEmptyList
                        ? _getNoResultLayout(context)
                        : _getMovieGridLayout(context),
              ],
            ),
          ),
        ],
      ), /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _getSearchBoxLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Theme(
                data: Styles.getInputBoxTheme(),
                child: TextField(
                  textInputAction: TextInputAction.go,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: _searchController,
                  style: Styles.getWhiteTextTheme(
                      Theme.of(context).textTheme.title),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: ColorUtil.getColorFromHex("#bbffffff")),
                      filled: true,
                      labelText: 'Search Movies',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onChanged: (text) {
                    _bloc.onSearchQueryEntered(text, true);
                  },
                ),
              )),
        ],
      ),
    );
  }


  Widget _getNoResultLayout(BuildContext context) {
    return Flexible(
      flex: 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset(
                  "assets/images/sloth.jpg",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 50),
              child: Text(
                'No Movies Found!!!',
                style: Styles.getWhiteTextTheme(
                    Theme.of(context).textTheme.display1),
                textAlign: TextAlign.center,
                textScaleFactor: .7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMovieGridLayout(BuildContext context) {
    /*return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid.count(
        childAspectRatio: 8.0 / 9.0,
        crossAxisCount: 2,
        children: _buildGridCards(context),
      ),
    );*/

    return Flexible(
      flex: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (DisplayUtil.getDisplayWidth(context) ~/ 160) > 1
                ? DisplayUtil.getDisplayWidth(context) ~/ 160
                : 1,
            childAspectRatio: 8.0 / 9.0,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: _bloc.currentSearchResponse.movieList.length,
          itemBuilder: (BuildContext context, int index){
            final ThemeData theme = Theme.of(context);
            return _getMovieCard(_bloc.currentSearchResponse.movieList[index], theme);
          },
          padding: EdgeInsets.all(4.0),
//          children: _buildGridCards(context, data),
//      children: [],
          controller: _scrollController,
        ),
      ),
    );
  }

  List<Card> _buildGridCards(BuildContext context) {
    if (_bloc.currentSearchResponse == null ||
        _bloc.currentSearchResponse.movieList.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    /*final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());*/

    return _bloc.currentSearchResponse.movieList.map((movieBean) {
      return _getMovieCard(movieBean, theme);
    }).toList();
  }

  Card _getMovieCard(MovieBean movieBean, ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // TODO: Adjust card heights (103)
      child: Material(
        child: InkWell(
          key: Key("movie"),
          highlightColor: Colors.amberAccent,
          splashColor: Colors.amber,
          enableFeedback: true,
          onTap: () {
            _navigateToMovieDetailPage(movieBean);
          },
          child: Stack(
              // TODO: Center items on the card (103)
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                _getMovieItemImage(movieBean),
                _getMovieItemTitleOverlay(movieBean, theme)
              ]),
        ),
      ),
    );
  }

  Widget _getMovieItemTitleOverlay(MovieBean movieBean, ThemeData theme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: ColorConstant.CARBON_TRANSPARENT_BB,
//                      ColorUtil.getColorFromHex("#bb101010"),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // TODO: Handle overflowing labels (103)
              _getMovieItemTitle(movieBean, theme),
              SizedBox(height: 4.0),
              _getMovieItemYear(movieBean, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMovieItemImage(MovieBean movieBean) {
    return AspectRatio(
      aspectRatio: 8 / 9,
      child: FadeInImage.assetNetwork(
        placeholder: "assets/images/little-dino.jpg",
        image: movieBean.poster,
        fit: BoxFit.cover,
      ),
      /*child: Image.network(
//                "assets/images/Robot.png",
                    movieBean.poster,
//                package: product.assetPackage,
                    fit: BoxFit.cover,
                  ),*/
    );
  }

  Widget _getMovieItemTitle(MovieBean movieBean, ThemeData theme) {
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Text(
        movieBean.title,
        textAlign: TextAlign.center,
        style: Styles.getWhiteTextTheme(theme.textTheme.title),
        textScaleFactor: .65,
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
      ),
    );
  }

  Widget _getMovieItemYear(MovieBean movieBean, ThemeData theme) {
    return Text(
      "${movieBean.year}",
      textAlign: TextAlign.center,
//                      formatter.format(product.price),
      style: Styles.getWhiteTextTheme(theme.textTheme.body2),
      textScaleFactor: .8,
    );
  }

  _navigateToMovieDetailPage(MovieBean movieBean) {
    Route route = MaterialPageRoute(
        builder: (context) => MovieDetailScreen(
              movieBean,
              title: movieBean.title,
            ));
    Navigator.push(context, route);
  }
}
