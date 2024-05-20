import 'package:Attendace/core/utils/assets_manager.dart';
import 'package:Attendace/core/utils/strings_manager.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:Attendace/features/forget_password/presentation/controller/cubit.dart';
import 'package:Attendace/features/forget_password/presentation/screens/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_bar/app_bar_custom.dart';
import '../../../../core/widgets/elevated_button/elevated_button_custom.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../../../../core/widgets/text_form_field/text_form_field_custom.dart';
import '../controller/states.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
        listener: (context, state) {
          if (state is GetUserIdSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
                snackBarWidget(message: state.message, context: context));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  phoneNumber: phoneNumberController.text,
                  userID: state.userID,
                ),
              ),
            );
          } else if (state is SendOtpErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
                snackBarWidget(message: state.message, context: context));
          } else if (state is GetUserIdErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
                snackBarWidget(message: state.message, context: context));
          }
        },
        builder: (context, state) {
          return ScaffoldCustom(
            appBarCustom: const AppBarCustom(
              text: AppStrings.forgetPassword,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          fontSize: FontSize.s14,
                          text: AppStrings.phone,
                          textAlign: TextAlign.start,
                          color: ColorManager.textFormLabelColor,
                        ),
                        const SizedBox(
                          height: AppSize.s8,
                        ),
                        TextFormFieldCustom(
                          validate: (value) {
                            if (value!.trim().isEmpty || value == ' ') {
                              return AppStrings.phoneTextField;
                            }
                            return null;
                          },
                          prefix: true,
                          isRegister: true,
                          hint: "5x xxx xxxx",
                          keyboardType: TextInputType.phone,
                          suffixIcon: IconsAssets.phoneIcon,
                          suffix: true,
                          controller: phoneNumberController,
                        ),
                        const SizedBox(
                          height: AppSize.s40,
                        ),
                        Center(
                          child: state is GetUserIdLoadingState
                              ? const CupertinoActivityIndicator(
                                  color: ColorManager.primary,
                                  radius: AppSize.s16,
                                )
                              : ElevatedButtonCustom(
                                  fontSize: FontSize.s14,
                                  textColor: ColorManager.white,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      BlocProvider.of<ForgetPasswordCubit>(
                                              context)
                                          .getUserId(
                                              phoneNumber:
                                                  phoneNumberController.text);
                                    }
                                  },
                                  text: AppStrings.submit,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
