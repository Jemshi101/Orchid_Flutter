import 'package:Orchid/MovieDetailScreen.dart';
import 'package:Orchid/constants/Colors.dart';
import 'package:Orchid/models/MovieBean.dart';
import 'package:Orchid/network/DataManager.dart';
import 'package:Orchid/network/models/SearchResponse.dart';
import 'package:Orchid/utils/ColorUtil.dart';
import 'package:flutter/material.dart';

import 'styles.dart';

String _title = "";
double currentScrollOffset = -1;

class SearchScreen extends StatefulWidget {
  SearchScreen(String title, {Key key}) : super(key: key) {
    _title = title;
  }

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  ScrollController _scrollController;

  int _counter = 0;

  bool isLoading = false;
  bool isEmptyList = false;

  String _lastSearchedQuery = "";
  int _currentPage = 1;
  SearchResponse _currentSearchResponse;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _searchController.removeListener(_scrollListener);
    _searchController.dispose();
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

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_currentSearchResponse != null &&
          _currentSearchResponse.movieList.length <
              num.parse(_currentSearchResponse.totalResults)) {}
      _onSearchParamChanged(_searchController.text, false);
      //          message = "reach the bottom";
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      //          message = "reach the top";
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      isLoading = !isLoading;
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
          Column(
            children: <Widget>[
//              if (isLoading) LinearProgressIndicator(),
              _getSearchBoxLayout(context),
//              _getMovieGridLayout(context),
              isLoading
                  ? _getLoadingLayout(context)
                  : isEmptyList
                      ? _getNoResultLayout(context)
                      : _getMovieGridLayout(context)
            ],
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
                    _onSearchParamChanged(text, true);
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget _getLoadingLayout(BuildContext context) {
    return Flexible(
      flex: 1,
      child: SingleChildScrollView(
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
                      valueColor:
                          new AlwaysStoppedAnimation(ColorUtil('#ffffffff')),
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
                  ]),
            )),
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
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: _buildGridCards(context),
        controller: _scrollController,
//      children: [],
      ),
    );
  }

  List<Card> _buildGridCards(BuildContext context) {
    if (_currentSearchResponse == null ||
        _currentSearchResponse.movieList.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    /*final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());*/

    return _currentSearchResponse.movieList.map((movieBean) {
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
                  AspectRatio(
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
                  ),
                  Align(
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
                            Text(
                              movieBean.title,
                              textAlign: TextAlign.center,
                              style: Styles.getWhiteTextTheme(
                                  theme.textTheme.title),
                              textScaleFactor: .65,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "${movieBean.year}",
                              textAlign: TextAlign.center,
//                      formatter.format(product.price),
                              style: Styles.getWhiteTextTheme(
                                  theme.textTheme.body2),
                              textScaleFactor: .8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ),
      );
    }).toList();
  }

  _navigateToMovieDetailPage(MovieBean movieBean) {
    Route route = MaterialPageRoute(
        builder: (context) => MovieDetailScreen(
              movieBean,
              title: movieBean.title,
            ));
    Navigator.push(context, route);
  }

  void _onSearchParamChanged(String query, bool isLoadingRequired) {
    if (query.length >= 3) {
      if (isLoadingRequired) {
        setState(() {
          isLoading = isLoadingRequired;
        });
      }

      if (_lastSearchedQuery.toLowerCase() == query.toLowerCase()) {
        _currentPage += 1;
      } else {
        _currentPage = 1;
        _currentSearchResponse = null;
        _lastSearchedQuery = query;
      }

      DataManager.searchMovies(query.toLowerCase(), _currentPage).then((value) {
        if (_currentSearchResponse == null) {
          _currentSearchResponse = value.responseBody;
        } else {
          _currentSearchResponse.movieList
              .addAll((value.responseBody as SearchResponse).movieList);
        }

        setState(() {
          if (_currentSearchResponse == null ||
              _currentSearchResponse.movieList.isEmpty) {
            isEmptyList = true;
          } else {
            isEmptyList = false;
          }
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          if (_currentSearchResponse == null ||
              _currentSearchResponse.movieList.isEmpty) {
            isEmptyList = true;
          } else {
            isEmptyList = false;
          }
          isLoading = false;
        });
      });
    }
  }
}
