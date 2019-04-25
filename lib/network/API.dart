import "dart:async";

import 'package:Orchid/network/APIUrl.dart';
import 'package:Orchid/network/models/MovieDetailResponse.dart';
import 'package:Orchid/network/models/SearchResponse.dart';
import 'package:chopper/chopper.dart';

part "API.chopper.dart";

@ChopperApi(baseUrl: "")
abstract class API extends ChopperService {
  static API create([ChopperClient client]) => _$API(client);

// SEARCH MOVIES
// http://www.omdbapi.com/?s=Bat&page=2&apiKey=75a9f74

// MOVIE DETAILS
// http://www.omdbapi.com/?i=tt0038399&plot=full&apiKey=75a9f74

  @Get(path: APIUrl.SEARCH_MOVIES)
  Future<Response> searchMovies(
    @Query("s") String query,
    @Query("page") int page,
    @Query("apiKey") String apiKey,
  );

  @Get(path: APIUrl.MOVIE_DETAILS)
  Future<Response> getMovieDetails(
    @Query("i") String imdbID,
    @Query("plot") String plot,
    @Query("apiKey") String apiKey,
  );

/*@Get(url: "{id}")
  Future<Response> getResource(@Path() String id);

  @Get(headers: const {"foo": "bar"})
  Future<Response<Map>> getMapResource(@Query() String id);

  @Post(url: 'multi')
  @multipart
  Future<Response> postResources(
    @Part('1') Map a,
    @Part('2') Map b,
    @Part('3') String c,
  );

  @Post(url: 'file')
  @multipart
  Future<Response> postFile(
    @FileField('file') List<int> bytes,
  );*/
}
