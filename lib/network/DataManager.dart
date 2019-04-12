import 'package:Orchid/network/API.dart';
import 'package:Orchid/network/APIClient.dart';
import 'package:Orchid/network/APIUrl.dart';
import 'package:Orchid/network/models/BaseResponse.dart';
import 'package:Orchid/network/models/DataManagerBean.dart';

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
    getAPI().searchMovies(query, page, getApiKey()).then((response) {
      if (response == null ||
          response.body == null ||
          response.body.response == BaseResponse.ERROR) {
        dataManagerBean = DataManagerBean(false, response.body);
      } else {
        dataManagerBean = DataManagerBean(true, response.body);
      }
    }).catchError((error) {
      dataManagerBean = DataManagerBean(false, null);
    });

    return await new Future<DataManagerBean>.value(dataManagerBean);
  }
}
