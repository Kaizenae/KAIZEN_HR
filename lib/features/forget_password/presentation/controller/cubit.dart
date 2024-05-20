import 'dart:math';
import 'dart:developer' as de;

import 'package:Attendace/core/api/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import 'states.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit() : super(ForgetPasswordInitState());
  int? otpNumber;
  String message = "";
  void createRandomOtp() {
    Random random = Random();

    // Generate a random 4-digit number
    otpNumber = random.nextInt(999999) + 100000;
    message = "Your OTP is $otpNumber It will be invalid after 1 min";
    emit(CreateOtpState());
  }

  void sendOtp({required String phoneNumber}) {
    createRandomOtp();
    if (otpNumber.toString().length == 6) {
      Dio().post(
        EndPoints.otpPath,
        queryParameters: {
          "action": "send-sms",
          "api_key":
              "SWRlYWNyYXRlIFA6JDJ5JDEwJFdXWlYzOTNUYjQ5TmVvU0NmRURmSS53MkNTakYwVWdMNXhQUVV6dlZlVEpEelF4MHp0aWlh",
          "to": "971$phoneNumber",
          "from": "ORANGEWHEEL",
          "sms": message,
          "response": "json",
        },
      ).then((value) {
        emit(SendOtpSuccessState());
      }).catchError((error) {
        emit(SendOtpErrorState(
            message: AppStrings.someThingWentWrongTryAgainLater));
      });
    } else {
      sendOtp(phoneNumber: phoneNumber);
    }
  }

  bool isPassword = true;
  String suffix = IconsAssets.hiddenIcon;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? IconsAssets.hiddenIcon : IconsAssets.hidden2Icon;
    emit(ChangePasswordVisibilityState());
  }

  late int userId;

  void getUserId({required String phoneNumber}) {
    emit(GetUserIdLoadingState());
    Dio().post(
      EndPoints.getUserIDPath,
      data: {
        "jsonrpc": "2.0",
        "params": {
          "phone": "0$phoneNumber",
        }
      },
    ).then((value) {
      userId = value.data["result"]["user_id"] as int;
      emit(GetUserIdSuccessState(
          message: value.data["result"]["message"], userID: userId));
    }).catchError((error) {
      de.log(error.toString());
      emit(GetUserIdErrorState(message: AppStrings.notRegisteredNumber));
    });
  }

  void changePassword(
      {required String phoneNunber,
      required String userId,
      required String newPassword}) {
    emit(ChangePasswordLoadingState());
    Dio().post(EndPoints.forgetPasswordPath, data: {
      "jsonrpc": "2.0",
      "params": {
        "user_id": userId,
        "phone": "0$phoneNunber",
        "new_password": newPassword,
      }
    }).then((value) {
      de.log(value.data.toString());
      if (value.data["result"]["success"] == true) {
        emit(ChangePasswordSuccessState(
            message: value.data["result"]["message"].toString()));
      } else {
        emit(ChangePasswordErrorState(
            message: value.data["result"]["message"].toString()));
      }
    }).catchError((error) {
      emit(ChangePasswordErrorState(
          message: AppStrings.someThingWentWrongTryAgainLater));
    });
  }
}
