class ShiftAllocationModel {
  ResultsModel result = ResultsModel();
  ShiftAllocationModel();
  ShiftAllocationModel.fromJson(Map<String, dynamic> json) {
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
  late String name;
  late int employeeId;
  late String state;
  late String from;
  late String to;
  ShiftSchemeModel shiftScheme = ShiftSchemeModel();

  ResponseModel();
  ResponseModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    employeeId = json["employee_id"];
    state = json["state"];
    from = json["from"];
    to = json["to"];
    shiftScheme = ShiftSchemeModel.fromJson(json["shift_scheme"]);
  }
}

class ShiftSchemeModel {
  late String name;
  late String type;
  late double form;
  late double to;
  ShiftSchemeModel();
  ShiftSchemeModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    type = json["type"];
    form = json["from"];
    to = json["to"];
  }
}
