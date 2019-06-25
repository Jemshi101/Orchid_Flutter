

import 'package:Orchid/src/network/API.dart';
import 'package:Orchid/src/network/APIUrl.dart';
import 'package:chopper/chopper.dart';

class APIClient {
  static ChopperClient instance;

  static ChopperClient getInstance(){
    if(instance == null){
      instance = ChopperClient(
        baseUrl: APIUrl.BASE_URL,
        services: [
          // the generated service
          API.create()
        ],
        converter: JsonConverter(),
      );
    }
    return instance;
  }

}