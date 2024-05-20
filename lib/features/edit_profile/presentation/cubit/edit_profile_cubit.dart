import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:Attendace/core/api/end_points.dart';
import 'package:Attendace/core/utils/constants_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/usecases/usecase.dart';

import '../../domain/entities/edit_profile_entity.dart';
import '../../domain/usecases/edit_profile_usecase.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  final EditUserNameUsecase editProfileUsecase;
  final EditDepartmentUsecase editDepartmentUsecase;
  final EditNoIdUsecase editNoIdUsecase;

  EditProfileCubit(
      {required this.editProfileUsecase,
      required this.editDepartmentUsecase,
      required this.editNoIdUsecase})
      : super(InitEditProfileState());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? noId = '';

  Future<void> editUserNameFun() async {
    emit(EditProfileLoadingState());
    Either<Failure, EditProfileEntity> response =
        await editProfileUsecase(EditProfileParams(
      userName: userNameController.text,
      userId: AppConstants.token,
    ));

    emit(response.fold(
        (failure) => EditProfileErrorState(message: failure.message),
        (editProfileEntity) =>
            EditProfileSuccessState(editProfileEntity: editProfileEntity)));
  }

  Future<void> editDepartmentFun() async {
    emit(EditProfileLoadingState());
    Either<Failure, EditProfileEntity> response = await editDepartmentUsecase(
        EditProfileParams(
            phoneNumber: phoneNumberController.text,
            userName: AppConstants.employeeName,
            userId: AppConstants.token));

    emit(response.fold(
        (failure) => EditProfileErrorState(message: failure.message),
        (editProfileEntity) =>
            EditProfileSuccessState(editProfileEntity: editProfileEntity)));
  }

  Future<void> editNoIdFun() async {
    emit(EditProfileLoadingState());
    Either<Failure, EditProfileEntity> response =
        await editNoIdUsecase(EditProfileParams(
      noId: noId,
      userId: AppConstants.token,
    ));

    emit(response.fold(
        (failure) => EditProfileErrorState(message: failure.message),
        (editProfileEntity) =>
            EditProfileSuccessState(editProfileEntity: editProfileEntity)));
  }

  io.File? profileImage;
  var picker = ImagePicker();
  String base64string = "";
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = io.File(pickedFile.path);
      Uint8List imagebytes =
          await profileImage!.readAsBytes(); //convert to bytes
      base64string = base64.encode(imagebytes);
      base64string.isNotEmpty ? updatePhoto() : null;
    }
  }

  void updatePhoto() {
    emit(EditUserPhotoLoadingState());
    Dio().post(
      EndPoints.editUserPhotoPath,
      data: {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(CacheHelper.get(key: AppConstants.userId)),
          "photo": base64string,
        }
      },
    ).then((value) {
      emit(EditUserPhotoSuccessState(
          message: value.data["result"]["message"][0].toString()));
    }).catchError((error) {
      emit(EditUserPhotoErrorState());
    });
  }
}
