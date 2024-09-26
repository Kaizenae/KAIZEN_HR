class RequestsModel {
  ResultsModel result = ResultsModel();
  RequestsModel();
  RequestsModel.fromJson(Map<String, dynamic> json) {
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
  late String type;
  late String employeeName;
  late int companyId;
  late int duration;
  late String state;
  late String reason;
  late String ownStatus;
  late String startDate;
  late String endDate;
  late String attachment;

  ResponseModel();
  ResponseModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    type = json["type"];
    companyId = json["company_id"];
    reason = json["reason"];
    employeeName = json["employee_name"];
    duration = json["duration"];
    state = json["state"];
    startDate = json["start_date"];
    ownStatus = json["own_status"];
    endDate = json["end_date"];
    attachment = json["attachment"];
  }
}
