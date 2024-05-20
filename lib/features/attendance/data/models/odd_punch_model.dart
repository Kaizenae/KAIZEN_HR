class OddPunchModel {
  ResultsModel result = ResultsModel();
  OddPunchModel();
  OddPunchModel.fromJson(Map<String, dynamic> json) {
    result = ResultsModel.fromJson(json["result"]);
  }
}

class ResultsModel {
  List<ResponseModel> responseModel = [];
  ResultsModel();
  ResultsModel.fromJson(Map<String, dynamic> json) {
    json["response"].forEach((element) {
      responseModel.add(ResponseModel.fromJson(element));
    });
  }
}

class ResponseModel {
  late int id;
  late String employeeId;
  late String checkIn;
  late String checkOut;

  ResponseModel();
  ResponseModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    employeeId = json["employee_id"];
    checkIn = json["check_in"] == "" ? "" : json["check_in"];
    checkOut = json["check_out"] == "" ? "" : json["check_out"];
  }
}
