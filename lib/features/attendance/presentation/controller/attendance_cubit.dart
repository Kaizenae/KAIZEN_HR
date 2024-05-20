import 'package:Attendace/core/api/end_points.dart';
import 'package:Attendace/features/attendance/data/models/odd_punch_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../domain/entities/attendace_entity.dart';
import '../../domain/usecases/attendance_usecase.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceUsecase attendanceUsecase;

  AttendanceCubit({required this.attendanceUsecase})
      : super(AttendanceInitial());

  static AttendanceCubit get(context) => BlocProvider.of(context);

  int? userId;
  Future<void> getAttendanceFun() async {
    emit(GetAttendanceLoading());
    Either<Failure, AttendanceEntity> response = await attendanceUsecase(
        EmployeeParams(
            userId: AppConstants.token, companyId: AppConstants.companyId));

    emit(response.fold((failure) {
      return GetAttendanceError(message: failure.message);
    }, (attendanceEntity) {
      return GetAttendanceSuccess(attendanceEntity: attendanceEntity);
    }));
  }

  Future<void> getEmployeeAttendanceFun() async {
    emit(GetEmployeeAttendanceLoading());
    Either<Failure, AttendanceEntity> response = await attendanceUsecase(
        EmployeeParams(userId: userId, companyId: AppConstants.companyId));

    emit(response.fold((failure) {
      return GetEmployeeAttendanceError(message: failure.message);
    }, (attendanceEntity) {
      // print(attendanceEntity.resultEntity.response.first.checkOut);
      return GetEmployeeAttendanceSuccess(attendanceEntity: attendanceEntity);
    }));
  }

  OddPunchModel oddPunchModel = OddPunchModel();
  void getOddPunch() {
    emit(GetOddPunchLoadingState());
    Dio().get(EndPoints.getOddPunchPath, data: {
      "jsonrpc": 2.0,
      "params": {
        "company_id": AppConstants.companyId,
        "user_id": int.parse(CacheHelper.get(key: AppConstants.userId)),
      }
    }).then((value) {
      oddPunchModel = OddPunchModel.fromJson(value.data);
      emit(const GetOddPunchSuccessState());
    }).catchError((error) {
      emit(const GetOddPunchErrorState());
    });
  }
}
