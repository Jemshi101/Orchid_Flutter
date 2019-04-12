import 'package:Orchid/network/models/BaseResponse.dart';
import 'package:Orchid/models/MovieBean.dart';

class SearchResponse extends BaseResponse {

  List<MovieBean> movieList = new List();
  String totalResults = "0";
  String response = BaseResponse.SUCCESS;
  String error = "";
	int currentPage = 1;

	int getTotal(){
		return int.parse(totalResults);
	}

	int getCurrentTotal(){
		return movieList.length;
	}


	SearchResponse.fromJsonMap(Map<String, dynamic> map):
		movieList = List<MovieBean>.from(map["Search"].map((it) => MovieBean.fromJsonMap(it))),
		totalResults = map["totalResults"],
		response = map["Response"],
		error = map["Error"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['Search'] = movieList != null ?
			this.movieList.map((v) => v.toJson()).toList()
			: null;
		data['totalResults'] = totalResults;
		data['Response'] = response;
		data['Error'] = error;
		return data;
	}
}

