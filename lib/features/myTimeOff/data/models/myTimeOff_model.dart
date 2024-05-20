// ignore_for_file: file_names

import 'package:intl/intl.dart';

import '../../domain/entities/myTimeOff_entity.dart';

class MyTimeOffModel extends MyTimeOffEntity {
  MyTimeOffModel({
    ResultEntity? resultEntity,
  }) : super(
          resultEntity: resultEntity!,
        );

  factory MyTimeOffModel.fromJson(Map<String, dynamic> json) => MyTimeOffModel(
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
  ResponseModel({
    int? id,
    String? employeeName,
    String? holidayStatus,
    String? holidayType,
    String? state,
    String? start,
    String? end,
    String? description,
    List<ApproversEntity>? approvers,
  }) : super(
          id: id ?? 0,
          employeeName: employeeName ?? '',
          holidayStatus: holidayStatus ?? '',
          holidayType: holidayType ?? '',
          state: state ?? '',
          start: start ?? DateFormat.MMMEd().format(DateTime.now()).toString(),
          end: end ?? DateFormat.MMMEd().format(DateTime.now()).toString(),
          description: description ?? '',
          approvers: approvers ?? [],
        );

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
      id: json['id'],
      employeeName: json['employee'],
      holidayStatus: json['holiday_status'],
      holidayType: json['holiday_type'],
      state: json['state'],
      start: json['start'],
      end: json['end'],
      description: json['description'],
      approvers: List<ApproversEntity>.from(
          json["approvers"].map((e) => ApproversModel.fromJson(e))));
}

class ApproversModel extends ApproversEntity {
  ApproversModel({
    required super.id,
    required super.state,
    required super.userName,
    required super.reason,
  });
  factory ApproversModel.fromJson(Map<String, dynamic> json) => ApproversModel(
        id: json["user"],
        state: json["state"],
        userName: json["user_name"],
        reason: json["reason"],
      );
}
