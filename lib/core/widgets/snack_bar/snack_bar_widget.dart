import 'package:flutter/material.dart';

import '../../utils/constants_manager.dart';

SnackBar snackBarWidget({
  required String message,
  required BuildContext context,
}) {
  return SnackBar(
    content: Text(
      message,
    ),
    duration: Duration(
      seconds: AppConstants.snackBarTime,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 180, right: 20, left: 20),
  );
}
