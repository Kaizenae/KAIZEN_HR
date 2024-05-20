// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'package:Attendace/core/utils/values_manager.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:Attendace/features/forget_password/presentation/screens/create_new_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../../../../core/widgets/app_bar/app_bar_custom.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../controller/cubit.dart';
import '../controller/states.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    required this.phoneNumber,
    required this.userID,
  });
  final String phoneNumber;
  final int userID;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  OtpFieldController otpController = OtpFieldController();
  late Timer timer;
  int start = 59;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit()
        ..sendOtp(
          phoneNumber: widget.phoneNumber,
        ),
      child: ScaffoldCustom(
        appBarCustom: const AppBarCustom(
          text: 'OTP',
        ),
        body: BlocBuilder<ForgetPasswordCubit, ForgetPasswordStates>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    fontSize: FontSize.s14,
                    text: AppStrings.otpNumber,
                    textAlign: TextAlign.start,
                    color: ColorManager.textFormLabelColor,
                  ),
                  const SizedBox(
                    height: AppSize.s12,
                  ),
                  OTPTextField(
                    controller: otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: AppSize.s50,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 12,
                    style: Theme.of(context).textTheme.titleMedium!,
                    onCompleted: (pin) {
                      if (start == 0) {
                        if (pin ==
                            BlocProvider.of<ForgetPasswordCubit>(context)
                                .otpNumber
                                .toString()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              snackBarWidget(
                                  message: AppStrings
                                      .thisCodeIsInvalidPleaseEnterValidCode,
                                  context: context));
                        }
                      } else {
                        if (pin !=
                            BlocProvider.of<ForgetPasswordCubit>(context)
                                .otpNumber
                                .toString()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              snackBarWidget(
                                  message: AppStrings.thisCodeIsIncorrect,
                                  context: context));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateNewPasswordScreen(
                                userID: widget.userID,
                                phoneNumber: widget.phoneNumber,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: AppSize.s20,
                  ),
                  start != 0
                      ? TextCustom(
                          fontSize: FontSize.s14,
                          text: "${AppStrings.theCodeWillExpireAfter}:$start",
                          textAlign: TextAlign.start,
                          color: ColorManager.darkGrey,
                        )
                      : Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: GestureDetector(
                            onTap: () {
                              start = 59;
                              BlocProvider.of<ForgetPasswordCubit>(context)
                                  .sendOtp(phoneNumber: widget.phoneNumber);
                              startTimer();
                              setState(() {});
                            },
                            child: TextCustom(
                              fontSize: FontSize.s14,
                              text: AppStrings.resendCode,
                              textAlign: TextAlign.start,
                              color: ColorManager.textFormLabelColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
