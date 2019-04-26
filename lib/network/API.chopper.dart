// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'API.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$API extends API {
  _$API([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = API;

  Future<Response> searchMovies(String query, int page, String apiKey) {
    final $url = '/';
    final Map<String, dynamic> $params = {
      's': query,
      'page': page,
      'apiKey': apiKey
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getMovieDetails(String imdbID, String plot, String apiKey) {
    final $url = '/';
    final Map<String, dynamic> $params = {
      'i': imdbID,
      'plot': plot,
      'apiKey': apiKey
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
