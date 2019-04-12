
class MovieBean {

  String title = "";
  String year = "";
  String imdbID = "";
  String type = "";
  String poster = "";

	MovieBean.fromJsonMap(Map<String, dynamic> map):
		title = map["Title"],
		year = map["Year"],
		imdbID = map["imdbID"],
		type = map["Type"],
		poster = map["Poster"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['Title'] = title;
		data['Year'] = year;
		data['imdbID'] = imdbID;
		data['Type'] = type;
		data['Poster'] = poster;
		return data;
	}
}
