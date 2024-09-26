import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/login_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginModel> login(
      {required String email,
      required String password,
      required String uniqueDeviceId});
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  ApiConsumer apiConsumer;
  LoginRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
    required String uniqueDeviceId,
  }) async {
    final response = await apiConsumer.post(EndPoints.loginUrl, body: {
      "jsonrpc": "2.0",
      "params": {
        // Test DataBase
        // "db": 'ICD_CMTY_TEST',
        // Live DataBase
        "db": 'Orange_Cmty_Live',
        "login": email,
        "password": password,
        "device_id": ""
      }
    });
    return LoginModel.fromJson(response);
  }
}
