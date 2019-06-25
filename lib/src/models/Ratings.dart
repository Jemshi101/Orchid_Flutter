class Ratings {
  String source = "";
  String value = "";

  Ratings.fromJsonMap(Map<String, dynamic> map)
      : source = map["Source"],
        value = map["Value"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Source'] = source;
    data['Value'] = value;
    return data;
  }
}
