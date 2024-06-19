import 'package:Attendace/core/api/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/version_model.dart';
import 'states.dart';

class SplashBloc extends Cubit<SplashStates> {
  SplashBloc() : super(SplashInitState());
  static SplashBloc get(context) => BlocProvider.of(context);

  VersionModel versionModel = VersionModel();
  void getVersion() {
    emit(GetVersionLoadingState());
    Dio().get(
      EndPoints.getVersionCodePath,
      data: {"jsonrpc": 2.0, "params": {}},
    ).then((value) {
      versionModel = VersionModel.fromJson(value.data);
      emit(GetVersionSuccessState(version: versionModel.result.version));
    }).catchError((error) {
      emit(GetVersionErrorState());
    });
  }
}
