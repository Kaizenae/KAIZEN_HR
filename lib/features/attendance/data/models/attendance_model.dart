import '../../domain/entities/attendace_entity.dart';

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({
    ResultEntity? resultEntity,
  }) : super(
          resultEntity: resultEntity!,
        );

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        resultEntity: ResultModel.fromJson(json['result']),
      );
}

class ResultModel extends ResultEntity {
  ResultModel({
    int? status,
    List<ResponseEntity>? responseEntity,
  }) : super(
          status: status ?? 400,
          response: responseEntity ?? [],
        );

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
        status: json['status'],
        responseEntity: List<ResponseEntity>.from(
            json['response'].map((e) => ResponseModel.fromJson(e))),
      );
}

class ResponseModel extends ResponseEntity {
  const ResponseModel({
    int? id,
    String? name,
    String? checkOut,
    double? workedHours,
    String? checkIn,
  }) : super(
          id: id ?? 0,
          name: name ?? '',
          checkIn: checkIn ?? '',
          checkOut: checkOut ?? '',
          workedHours: workedHours ?? 0.0,
        );

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        name: json['employee_id'],
        id: json['id'],
        checkIn: json['check_in'] == "" ? '' : json['check_in'],
        checkOut: json['check_out'].toString(),
        workedHours: json['worked_hours'],
      );
}
