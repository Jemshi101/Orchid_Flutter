import 'package:Orchid/network/API.dart';
import 'package:Orchid/network/APIClient.dart';
import 'package:Orchid/network/APIUrl.dart';
import 'package:Orchid/network/models/BaseResponse.dart';
import 'package:Orchid/network/models/DataManagerBean.dart';
import 'package:Orchid/network/models/MovieDetailResponse.dart';
import 'package:Orchid/network/models/SearchResponse.dart';

class DataManager {
  static API apiInstance;

  static API getAPI() {
    if (apiInstance == null) {
      apiInstance = API.create(APIClient.getInstance());
    }
    return apiInstance;
  }

  static getApiKey() {
    return APIUrl.API_KEY;
  }

  static Future<DataManagerBean> searchMovies(String query, int page) async {
    DataManagerBean dataManagerBean;
    await getAPI().searchMovies(query, page, getApiKey()).then((response) {
      if (response == null || response.body == null) {
        dataManagerBean = DataManagerBean(false, response.body);
      } else {
        SearchResponse searchResponse =
            SearchResponse.fromJsonMap(response.body);
        dataManagerBean = DataManagerBean(
            searchResponse.response != BaseResponse.ERROR, searchResponse);
      }
    }).catchError((error) {
      dataManagerBean = DataManagerBean(false, null);
    });
    return await new Future<DataManagerBean>.value(dataManagerBean);
  }

  static Future<DataManagerBean> getMovieDetails(
      String imdbID, String plotType) async {
    DataManagerBean dataManagerBean;
    await getAPI()
        .getMovieDetails(imdbID, plotType, getApiKey())
        .then((response) {
      if (response == null || response.body == null) {
        dataManagerBean = DataManagerBean(false, response.body);
      } else {
        MovieDetailResponse movieDetailResponse =
            MovieDetailResponse.fromJsonMap(response.body);
        dataManagerBean = DataManagerBean(
            movieDetailResponse.response != BaseResponse.ERROR,
            movieDetailResponse);
      }
    }).catchError((error) {
      dataManagerBean = DataManagerBean(false, null);
    });
    return await new Future<DataManagerBean>.value(dataManagerBean);
  }
}
