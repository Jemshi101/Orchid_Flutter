import 'package:Orchid/MovieDetailScreen.dart';
import 'package:Orchid/network/DataManager.dart';
import 'package:Orchid/network/models/SearchResponse.dart';
import 'package:Orchid/utils/ColorUtil.dart';
import 'package:flutter/material.dart';

import 'styles.dart';

String _title = "";

class SearchScreen extends StatefulWidget {
  SearchScreen(String title, {Key key}) : super(key: key) {
    _title = title;
  }

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _counter = 0;

  String _lastSearchedQuery = "";

  bool isLoading = false;

  bool isEmptyList = false;

  final _searchController = TextEditingController();

  int _currentPage = 1;

  SearchResponse _currentSearchResponse;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _searchController.dispose();
    super.dispose();
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

      body: Container(
        alignment: AlignmentDirectional.topCenter,
        constraints: BoxConstraints.tightForFinite(),
        color: ColorUtil.getColorFromHex('#ff2a2a2a'),
        child: Column(children: [
          _getSearchBoxLayout(context),
          isLoading
              ? _getLoadingLayout(context)
              : isEmptyList
                  ? _getNoResultLayout(context)
                  : Flexible(child: _getMovieGridLayout(context)),
        ]),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _getSearchBoxLayout(BuildContext context) {
    return Flex(direction: Axis.vertical, children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 5),
        child: Theme(
          data: Styles.getInputBoxTheme(),
          child: TextField(
            textInputAction: TextInputAction.go,
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            controller: _searchController,
            style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
            decoration: InputDecoration(
                labelStyle:
                    TextStyle(color: ColorUtil.getColorFromHex("#ffffffff")),
                filled: true,
                labelText: 'Search',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
            onChanged: (text) {
              _onSearchParamChanged(text);
            },
          ),
        ),
      )
    ]);
  }

  Widget _getLoadingLayout(BuildContext context) {
    return Flex(direction: Axis.vertical, children: [
      CircularProgressIndicator(
        backgroundColor: ColorUtil.getColorFromHex('#ff000000'),
        valueColor: new AlwaysStoppedAnimation(ColorUtil('#ffffffff')),
      ),
      Padding(
        padding: EdgeInsets.all(50),
        child: Text(
          'Please Wait...',
          style: Styles.getWhiteTextTheme(Theme.of(context).textTheme.display1),
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }

  Widget _getNoResultLayout(BuildContext context) {
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
              'No Movies Found!!!',
              style: Styles.getWhiteTextTheme(
                  Theme.of(context).textTheme.display1),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  GridView _getMovieGridLayout(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0,
      // TODO: Build a grid of cards (102)
      children: _buildGridCards(context),
//      children: [],
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
        child: Column(
          // TODO: Center items on the card (103)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                "assets/images/Robot.png",
//                product.assetName,
//                package: product.assetPackage,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  // TODO: Align labels to the bottom and center (103)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // TODO: Change innermost Column (103)
                  children: <Widget>[
                    // TODO: Handle overflowing labels (103)
                    Text(
                      movieBean.title,
                      style: theme.textTheme.title,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "${movieBean.year}",
//                      formatter.format(product.price),
                      style: theme.textTheme.body2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  _navigateToMovieDetailPage() {
    Route route = MaterialPageRoute(builder: (context) => MovieDetailScreen());
    Navigator.push(context, route);
  }

  void _onSearchParamChanged(String query) {
    setState(() {
      isLoading = true;

      if (_lastSearchedQuery.toLowerCase() == query.toLowerCase()) {
        _currentPage += 1;
      } else {
        _currentPage = 1;
      }

      DataManager.searchMovies(query.toLowerCase(), _currentPage).then((value) {
        if (_currentSearchResponse == null) {
          _currentSearchResponse = value.responseBody;
        } else {
          _currentSearchResponse.movieList
              .addAll((value.responseBody as SearchResponse).movieList);
        }

        if (_currentSearchResponse == null ||
            _currentSearchResponse.movieList.isEmpty) {
          isEmptyList = true;
        } else {
          isEmptyList = false;
        }
        isLoading = false;
      }).catchError((error) {
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
