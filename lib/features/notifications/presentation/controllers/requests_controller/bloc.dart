import 'package:Attendace/core/api/end_points.dart';
import 'package:Attendace/features/notifications/data/models/requests_model.dart';
import 'package:Attendace/features/notifications/presentation/controllers/requests_controller/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/constants_manager.dart';
import '../../../../../core/utils/strings_manager.dart';

class RequestsBloc extends Cubit<RequestsStates> {
  RequestsBloc() : super(RequestInitState());
  static RequestsBloc get(context) => BlocProvider.of(context);
  RequestsModel requestsModel = RequestsModel();
  List<ResponseModel> pendingRequests = [];
  List<ResponseModel> approvedRequests = [];
  List<ResponseModel> rejectedRequests = [];
  void getRequests() {
    pendingRequests = [];
    approvedRequests = [];
    rejectedRequests = [];
    emit(RequestLoadingState());
    Dio()
        .get(
      EndPoints.getPendingRequests,
      data: {
        "jsonrpc": "2.0",
        "params": {
          "company_id": AppConstants.companyId,
          "user_id": int.parse(CacheHelper.get(key: AppConstants.userId)),
        }
      },
      options: Options(
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20)),
    )
        .then((value) {
      pendingRequests = [];
      approvedRequests = [];
      rejectedRequests = [];
      requestsModel = RequestsModel.fromJson(value.data);
      for (var item in requestsModel.result.responseModel) {
        if (item.state == "Rejected") {
          rejectedRequests.add(item);
        } else if (item.state == "Submitted") {
          if (item.ownStatus == "New" || item.ownStatus == "Submitted") {
            pendingRequests.add(item);
          } else if (item.ownStatus == "Approved") {
            approvedRequests.add(item);
          } else if (item.ownStatus == "Rejected") {
            rejectedRequests.add(item);
          }
        } else if (item.state == "Approved") {
          approvedRequests.add(item);
        }
      }
      emit(RequestSuccessState());
    }).catchError((error) {
      emit(RequestErrorState());
    });
  }

  void approveRequest({
    required int requestId,
    required String type,
    required String reason,
  }) {
    emit(ApproveRequestLoadingState());
    Dio()
        .post(
      EndPoints.approveRequest,
      data: {
        "jsonrpc": 2.0,
        "params": {
          "user_id": int.parse(CacheHelper.get(key: AppConstants.userId)),
          "request_id": requestId,
          "type": type,
          "reason": reason
        }
      },
      options: Options(receiveTimeout: const Duration(seconds: 20)),
    )
        .then((value) {
      emit(ApproveRequestSuccessState(
          message: value.data["result"]["response"]));
    }).catchError((error) {
      emit(ApproveRequestErrorState(
          message: AppStrings.someThingWentWrongTryAgainLater));
    });
  }

  void rejectRequest(
      {required int requestId, required String type, required String reason}) {
    emit(RejectRequestLoadingState());
    Dio()
        .post(
      EndPoints.rejectRequest,
      data: {
        "jsonrpc": 2.0,
        "params": {
          "user_id": int.parse(CacheHelper.get(key: AppConstants.userId)),
          "request_id": requestId,
          "type": type,
          "reason": reason,
        }
      },
      options: Options(receiveTimeout: const Duration(seconds: 20)),
    )
        .then((value) {
      emit(
          RejectRequestSuccessState(message: value.data["result"]["response"]));
    }).catchError((error) {
      emit(RejectRequestErrorState(
          message: AppStrings.someThingWentWrongTryAgainLater));
    });
  }

  bool isBottomSheetShown = false;
  TextEditingController reasonController = TextEditingController();
  void changeBottomSheet({
    required bool isShow,
  }) {
    isBottomSheetShown = isShow;
    emit(AppChangeBottomSheetState());
  }
}
