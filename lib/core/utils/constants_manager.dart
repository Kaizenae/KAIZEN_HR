import '../local/cache_helper.dart';
import 'strings_manager.dart';

class AppConstants {
  static String appVersion = "6.3.0";
  static int token = CacheHelper.get(key: AppStrings.token) ?? 0;
  static int companyId = CacheHelper.get(key: AppStrings.company) ?? 0;
  static bool isPunched = CacheHelper.get(key: AppStrings.punched) ?? false;
  static bool admin = CacheHelper.get(key: AppStrings.admin) ?? false;
  static List<String> admins = [];

  static String userId = '';
  static String employeeName = '';
  static bool connected = true;
  static String punchIn = '';
  static int snackBarTime = 5;
}
