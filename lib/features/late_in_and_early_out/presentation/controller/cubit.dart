// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:Attendace/core/api/end_points.dart';
import 'package:Attendace/core/utils/strings_manager.dart';
import 'package:Attendace/features/late_in_and_early_out/presentation/controller/states.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/local/cache_helper.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../data/late_in_early_out_model.dart';

class EarlyOutLateInCubit extends Cubit<EarlyOutLateInStates> {
  EarlyOutLateInCubit() : super(EarlyOutLateInInitState());
  static EarlyOutLateInCubit get(context) => BlocProvider.of(context);

  TextEditingController reasonController = TextEditingController();
  String? selectedDateShow = DateFormat("dd,MMM,yyyy").format(DateTime.now());
  String? selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String checkType = '';
  int selectedValue = 0;

  String dateCount = '';
  String range = '';
  String rangeCount = '';
  void changeDate(String date) {
    selectedDateShow = date;

    emit(ChangeDateState());
  }

  void earlyOutRequest() {
    emit(EarlyOutLoadingState());
    Dio().post(EndPoints.earlyOutPath, data: {
      "jsonrpc": "2.0",
      "params": {
        "user_id": CacheHelper.get(key: AppConstants.userId).toString(),
        "company_id": AppConstants.companyId.toString().toString(),
        "reason": reasonController.text.toString(),
        "date": selectedDate.toString(),
        "attachment": base64string,
      }
    }).then((value) {
      emit(EarlyOutSuccessState(
          message: value.data["result"]["message"].toString()));
    }).catchError((error) {
      log(error.toString());
      emit(EarlyOutErrorState(
          message: AppStrings.someThingWentWrongTryAgainLater));
    });
  }

  void lateIn() {
    emit(LateInLoadingState());
    Dio().post(EndPoints.lateInPath, data: {
      "jsonrpc": "2.0",
      "params": {
        "user_id": CacheHelper.get(key: AppConstants.userId).toString(),
        "company_id": AppConstants.companyId.toString(),
        "reason": reasonController.text.toString(),
        "date": selectedDate.toString(),
        "attachment": base64string,
      }
    }).then((value) {
      emit(LateInSuccessState(
          message: value.data["result"]["message"].toString()));
    }).catchError((error) {
      emit(LateInErrorState(
          message: AppStrings.someThingWentWrongTryAgainLater));
    });
  }

  String? fileName;
  String base64string = "";
  File? filePath;

  pickFileFromDevice() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    } else {
      final file = result.files.first;
      filePath = File(result.paths.first!);
      fileName = file.name;
      Uint8List filebytes = await filePath!.readAsBytes(); //convert to bytes
      base64string = base64.encode(filebytes);
      emit(ChangeFileNameState());
    }
  }

  List lateInPending = [];
  List lateInRefuse = [];
  List lateInDone = [];
  LateinEarlyOutModel lateinModel = LateinEarlyOutModel();
  void getLateIn() {
    lateInPending = [];
    lateInRefuse = [];
    lateInDone = [];
    emit(GetLateInLoadingState());
    Dio()
        .get(
      EndPoints.getLateInPath,
      data: {
        "jsonrpc": "2.0",
        "params": {
          "company_id": AppConstants.companyId,
          "user_id": CacheHelper.get(key: AppConstants.userId),
        }
      },
      options: Options(receiveTimeout: const Duration(seconds: 20)),
    )
        .then((value) {
      lateinModel = LateinEarlyOutModel.fromJson(value.data);
      for (var element in lateinModel.result.responseModel) {
        if (element.state == 'Approved') {
          lateInDone.add(element);
        } else if (element.state == "Submitted") {
          lateInPending.add(element);
        } else if (element.state == "Rejected") {
          lateInRefuse.add(element);
        }
      }
      emit(GetLateInSuccessState());
    }).catchError((error) {
      log(error.toString());
      emit(GetLateInErrorState());
    });
  }

  List earlyOutPending = [];
  List earlyOutRefuse = [];
  List earlyOutDone = [];

  LateinEarlyOutModel earlyOutModel = LateinEarlyOutModel();
  void getEarlyOut() {
    earlyOutPending = [];
    earlyOutRefuse = [];
    earlyOutDone = [];
    emit(GetEarlyOutLoadingState());
    Dio().get(EndPoints.getEarlyOutPath, data: {
      "jsonrpc": "2.0",
      "params": {
        "company_id": AppConstants.companyId,
        "user_id": CacheHelper.get(key: AppConstants.userId),
      }
    }).then((value) {
      earlyOutModel = LateinEarlyOutModel.fromJson(value.data);
      for (var element in earlyOutModel.result.responseModel) {
        if (element.state == 'Approved') {
          earlyOutDone.add(element);
        } else if (element.state == "Submitted") {
          earlyOutPending.add(element);
        } else if (element.state == "Rejected") {
          earlyOutRefuse.add(element);
        }
      }
      emit(GetEarlyOutSuccessState());
    }).catchError((error) {
      log(error.toString());
      emit(GetEarlyOutErrorState());
    });
  }

  void cancelMyRequest({
    required int requestId,
    required String type,
  }) {
    emit(CancelMyRequestLoadingState());
    Dio().post(EndPoints.cancelMyRequestPath, data: {
      "jsonrpc": 2.0,
      "params": {
        "request_id": requestId,
        "type": type,
        "reason": "",
      }
    }).then((value) {
      emit(CancelMyRequestSuccessState(
          message: value.data["result"]["response"]));
    }).catchError((error) {
      emit(CancelMyRequestErrorState(
          message: AppStrings.someThingWentWrongTryAgainLater));
    });
  }
}
