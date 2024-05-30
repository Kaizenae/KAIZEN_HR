class EndPoints {
  static String baseUrl = 'http://156.67.83.227:8070';
  static String loginUrl = '$baseUrl/login_api';
  static String registerUrl = '$baseUrl/register_api';
  static String getEmployeeUrl = '$baseUrl/get_all_employee';
  static String getCompaniesUrl = '$baseUrl/get_all_company';
  static String getEmployeesUrl = '$baseUrl/get_users';
  static String attendance = '$baseUrl/get_all_check';
  static String allRequestsAccepted = '$baseUrl/get_all_request_accepted';
  static String allLoans = '$baseUrl/get_employee_loans';
  static String updateLoansStatus = '$baseUrl/update_employee_loans_status';
  static String allRequestsNotAccepted =
      '$baseUrl/get_all_request_not_accepted';
  static String punchInOut = '$baseUrl/check_in_check_out';
  static String applyRequest = '$baseUrl/create_request';
  static String createLoanEndpoint = '$baseUrl/create_employee_loans';
  static String createTimeOffEndpoint = '$baseUrl/create_employee_leaves';
  static String getCurrency = '$baseUrl/get_currency';
  static String getTimeOff = '$baseUrl/get_time_off';
  static String updateProfile = '$baseUrl/update_employee_profile';
  static String updateCompany = '$baseUrl/set_company_location';
  static String acceptRejectEndpoint = '$baseUrl/get_accept_request';
  static String acceptRejectTimeOffEndpoint =
      '$baseUrl/update_employee_leaves_status';
  static String allTimeOff = '$baseUrl/get_employee_leaves';
  static String changePasswordEndpoint = '$baseUrl/change_customer_password_hr';

  static String getAllUserUrl = '/user/allUsers';
  static String getUserUrl = '$baseUrl/user/profile';
  static String getUserProfileUrl = '$baseUrl/user/get-profile';

  static String checkInUrl = '$baseUrl/time/newCheckIn';
  static String checkOutUrl = '$baseUrl/time/newCheckOut';

  static String checkInRequestsUrl = '$baseUrl/time/allCheckInRequests';
  static String checkOutRequestsUrl = '$baseUrl/time/allCheckOutRequests';

  static String userCheckInRequestsUrl = '$baseUrl/time/allCheckIn';
  static String userCheckOutRequestsUrl = '$baseUrl/time/allCheckOut';

  static String checkInUpdateRequestsUrl = '$baseUrl/time/acceptCheckIn';
  static String checkOutUpdateRequestsUrl = '$baseUrl/time/acceptCheckOut';

  static String checkInDeleteRequestsUrl = '$baseUrl/time/delete-checkIn';
  static String checkOutDeleteRequestsUrl = '$baseUrl/time/delete-checkOut';
  static String getAllTimeOffValuesPath = '$baseUrl/get_employee_timeoff_type';
  static String earlyOutPath = "$baseUrl/early_out";
  static String lateInPath = "$baseUrl/late_in";
  static String hrPoliciesPath = "$baseUrl/get_hr_policy";
  static String getLateInPath = "$baseUrl/get_late_in";
  static String getEarlyOutPath = "$baseUrl/get_early_out";
  static String shiftAllocationPath = "$baseUrl/get_shift_allocation";
  static String editUserPhotoPath = "$baseUrl/update_user_data";
  static String otpPath = "https://ndm-solutions.com/sms/api";
  static String getUserIDPath = "$baseUrl/api/get_user_id";
  static String forgetPasswordPath = "$baseUrl/api/reset_password";
  static String getPendingRequests = "$baseUrl/org/get_my_requests";
  static String approveRequest = "$baseUrl/org/approve_request";
  static String rejectRequest = "$baseUrl/org/refuse_request";
  static String cancelMyRequestPath = "$baseUrl/org/cancel_my_request";
  static String getOddPunchPath = "$baseUrl/org/get_all_odds";
  static String getVersionCodePath = "$baseUrl/org/get_version";
}
