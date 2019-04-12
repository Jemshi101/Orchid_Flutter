

import 'package:Orchid/network/API.dart';
import 'package:chopper/chopper.dart';

class APIClient {
  static ChopperClient instance;

  static ChopperClient getInstance(){
    if(instance == null){
      instance = ChopperClient(
        baseUrl: "http://localhost:8000",
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