import 'package:Attendace/features/login/presentation/screens/create_password.dart';
import 'package:Attendace/features/login/presentation/widgets/login_form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/routes_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/component.dart';
import '../../../../core/widgets/elevated_button/elevated_button_custom.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      body: BlocProvider.value(
        value: BlocProvider.of<LoginCubit>(context),
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              if (state.loginEntity.resultEntity.loginBefore == false) {
                SnackBar snackBar = SnackBar(
                  content:
                      Text(state.loginEntity.resultEntity.message.toString()),
                  duration: Duration(
                    seconds: AppConstants.snackBarTime,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePasswordAfterLoginScreen(
                            userID:
                                state.loginEntity.resultEntity.id.toString())));
              } else {
                SnackBar snackBar = SnackBar(
                  content:
                      Text(state.loginEntity.resultEntity.message.toString()),
                  duration: Duration(
                    seconds: AppConstants.snackBarTime,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                CacheHelper.put(
                    key: AppConstants.userId,
                    value: state.loginEntity.resultEntity.id.toString());

                AppConstants.token =
                    CacheHelper.get(key: AppStrings.token) ?? 0;

                AppConstants.admin =
                    CacheHelper.get(key: AppStrings.admin) ?? false;
                navigatorAndRemove(
                    context,
                    AppConstants.admin
                        ? Routes.mainRouteAdmin
                        : Routes.mainRoute);
              }
            } else if (state is LoginErrorState) {
              SnackBar snackBar = SnackBar(
                content: Text(state.message.toString()),
                duration: Duration(
                  seconds: AppConstants.snackBarTime,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            var loginCubit = LoginCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(AppPadding.p20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: 3 / 1.2,
                        child: Image.asset(
                          ImageAssets.logoImg,
                          height: AppSize.s100,
                          width: AppSize.s100,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.s20,
                    ),
                    Center(
                      child: TextCustom(
                        color: ColorManager.primary,
                        text: AppStrings.welcome,
                        fontSize: FontSize.s20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.s30,
                    ),
                    LoginFormWidget(
                      formKey: formKey,
                    ),
                    Center(
                      child: state is LoginLoadingState
                          ? const CupertinoActivityIndicator(
                              color: ColorManager.primary,
                              radius: AppSize.s16,
                            )
                          : ElevatedButtonCustom(
                              fontSize: FontSize.s16,
                              textColor: ColorManager.white,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await loginCubit.loginFun();
                                  formKey.currentState!.reset();
                                }
                              },
                              text: AppStrings.login,
                            ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          navigator(context, Routes.forgetPasswordRoute);
                        },
                        child: TextCustom(
                          color: ColorManager.primary,
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.w600,
                          text: AppStrings.forgetPassword,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextCustom(
                          fontSize: FontSize.s14,
                          text: AppStrings.doNotHaveAccount,
                          color: ColorManager.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        TextButton(
                          onPressed: () {
                            EndPoints.baseUrl;
                            navigator(context, Routes.registerRoute);
                          },
                          child: TextCustom(
                              fontSize: FontSize.s14,
                              text: AppStrings.signup,
                              color: ColorManager.primary,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
