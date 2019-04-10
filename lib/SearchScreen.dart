import 'package:Orchid/MovieDetailScreen.dart';
import 'package:Orchid/utils/ColorUtil.dart';
import 'package:flutter/material.dart';

import 'styles.dart';


class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _counter = 0;

  bool isLoading = true;

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
        title: Text(widget.title),
      ),

      body: Container(
        constraints: BoxConstraints.expand(),
        color: ColorUtil.getColorFromHex('#ff2a2a2a'),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Theme(
                  data: Styles.getInputBoxTheme(),
                  child: TextField(
                    textInputAction: TextInputAction.go,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: _searchController,
                    style:
                    Styles.getWhiteTextTheme(Theme.of(context).textTheme.title),
                    decoration: InputDecoration(
                        labelStyle:
                        TextStyle(color: ColorUtil.getColorFromHex("#ffffffff")),
                        filled: true,
                        labelText: 'Email Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)))),
                  ),
                ),
              ),
              isLoading
                  ? Column(
                children: [
                  CircularProgressIndicator(
                    backgroundColor:
                    ColorUtil.getColorFromHex('#ff000000'),
                    valueColor: new AlwaysStoppedAnimation(
                        ColorUtil('#ffffffff')),
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
                ],
              )
                  : Column(
                children: <Widget>[
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.display3,
                  ),
                ],
              ) ,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _navigateToMovieDetailPage() {
    Route route = MaterialPageRoute(builder: (context) => MovieDetailScreen());
    Navigator.push(context, route);
  }
}