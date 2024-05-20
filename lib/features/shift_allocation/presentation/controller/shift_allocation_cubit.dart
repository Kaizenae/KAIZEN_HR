import 'package:Attendace/core/api/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../data/shift_allocation_model.dart';
import 'shift_allocation_states.dart';

class ShiftAllocationCubit extends Cubit<ShiftAllocationStates> {
  ShiftAllocationCubit() : super(ShiftAllocationInitState());
  static ShiftAllocationCubit get(context) => BlocProvider.of(context);

  ShiftAllocationModel shiftAllocationModel = ShiftAllocationModel();
  void getShiftAllocation() {
    emit(ShiftAllocationLoadingState());
    Dio().get(EndPoints.shiftAllocationPath, data: {
      "jsonrpc": "2.0",
      "params": {
        "company_id": AppConstants.companyId,
        "user_id": int.parse(CacheHelper.get(key: AppConstants.userId)),
      }
    }).then((value) {
      shiftAllocationModel = ShiftAllocationModel.fromJson(value.data);

      emit(ShiftAllocationSuccessState());
    }).catchError((error) {
      emit(ShiftAllocationErrorState());
    });
  }
}
