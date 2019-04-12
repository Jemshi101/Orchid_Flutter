class DataManagerBean {
  bool status = false;
  var responseBody;
  String type = "";

  DataManagerBean(bool status, responseBody, {String type: ""}) {
    this.status = status;
    this.responseBody = responseBody;
    this.type = type;
  }

  bool isErrorResponse() {
    return (status && responseBody != null);
  }
}
