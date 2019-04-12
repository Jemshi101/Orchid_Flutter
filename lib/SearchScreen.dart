import 'package:Orchid/MovieDetailScreen.dart';
import 'package:Orchid/models/Category.dart';
import 'package:Orchid/repository/ProductsRepository.dart';
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

  bool isLoading = false;

  final _searchController = TextEditingController();

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
        constraints: BoxConstraints.tightForFinite(),
        color: ColorUtil.getColorFromHex('#ff2a2a2a'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                  style: Styles.getWhiteTextTheme(
                      Theme.of(context).textTheme.title),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: ColorUtil.getColorFromHex("#ffffffff")),
                      filled: true,
                      labelText: 'Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onChanged: (text) {
                    _onSearchParamChanged(text);
                  },
                ),
              ),
            ),
            isLoading
                ? _getLoadingLayout(context)
                : Flexible(child: _getMovieGridLayout(context)),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Column _getLoadingLayout(BuildContext context) {
    return Column(
      children: [
        CircularProgressIndicator(
          backgroundColor: ColorUtil.getColorFromHex('#ff000000'),
          valueColor: new AlwaysStoppedAnimation(ColorUtil('#ffffffff')),
        ),
        Padding(
          padding: EdgeInsets.all(50),
          child: Text(
            'Please Wait...',
            style:
                Styles.getWhiteTextTheme(Theme.of(context).textTheme.display1),
            textAlign: TextAlign.center,
          ),
        ),
      ],
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
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products == null || products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    /*final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());*/

    return products.map((product) {
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
                "assets/images/Robot.png"
//                product.assetName,
//                package: product.assetPackage,
                // TODO: Adjust the box size (102)
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
                      product.name,
                      style: theme.textTheme.title,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "${product.price}",
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

  void _onSearchParamChanged(String text) {
    setState(() {
      isLoading = true;
    });
  }
}
