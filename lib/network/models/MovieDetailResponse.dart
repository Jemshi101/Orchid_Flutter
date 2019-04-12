

import 'package:Orchid/models/Ratings.dart';

class MovieDetailResponse {
  String title = "";
  String year = "";
  String rated = "";
  String released = "";
  String runtime = "";
  String genre = "";
  String director = "";
  String writer = "";
  String actors = "";
  String plot = "";
  String language = "";
  String country = "";
  String awards = "";
  String poster = "";
  List<Ratings> ratings = List();
  String metaScore = "";
  String imdbRating = "";
  String imdbVotes = "";
  String imdbID = "";
  String type = "";
  String DVD = "";
  String boxOffice = "";
  String production = "";
  String website = "";
  String response = "";

  MovieDetailResponse.fromJsonMap(Map<String, dynamic> map)
      : title = map["Title"],
        year = map["Year"],
        rated = map["Rated"],
        released = map["Released"],
        runtime = map["Runtime"],
        genre = map["Genre"],
        director = map["Director"],
        writer = map["Writer"],
        actors = map["Actors"],
        plot = map["Plot"],
        language = map["Language"],
        country = map["Country"],
        awards = map["Awards"],
        poster = map["Poster"],
        ratings = List<Ratings>.from(
            map["Ratings"].map((it) => Ratings.fromJsonMap(it))),
        metaScore = map["Metascore"],
        imdbRating = map["imdbRating"],
        imdbVotes = map["imdbVotes"],
        imdbID = map["imdbID"],
        type = map["Type"],
        DVD = map["DVD"],
        boxOffice = map["BoxOffice"],
        production = map["Production"],
        website = map["Website"],
        response = map["Response"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = title;
    data['Year'] = year;
    data['Rated'] = rated;
    data['Released'] = released;
    data['Runtime'] = runtime;
    data['Genre'] = genre;
    data['Director'] = director;
    data['Writer'] = writer;
    data['Actors'] = actors;
    data['Plot'] = plot;
    data['Language'] = language;
    data['Country'] = country;
    data['Awards'] = awards;
    data['Poster'] = poster;
    data['Ratings'] =
        ratings != null ? this.ratings.map((v) => v.toJson()).toList() : null;
    data['Metascore'] = metaScore;
    data['imdbRating'] = imdbRating;
    data['imdbVotes'] = imdbVotes;
    data['imdbID'] = imdbID;
    data['Type'] = type;
    data['DVD'] = DVD;
    data['BoxOffice'] = boxOffice;
    data['Production'] = production;
    data['Website'] = website;
    data['Response'] = response;
    return data;
  }
}


