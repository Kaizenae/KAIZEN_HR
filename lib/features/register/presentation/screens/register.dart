// ignore_for_file: use_build_context_synchronously

import 'package:Attendace/core/utils/font_manager.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:Attendace/features/register/domain/usecases/register_usecase.dart';
import 'package:Attendace/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/routes_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/component.dart';
import '../../../../core/widgets/elevated_button/elevated_button_custom.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/register_form_widget.dart';
import '../widgets/select_company_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      body: BlocProvider(
        create: (context) =>
            RegisterCubit(registerUsecase: sl<RegisterUsecase>())
              ..getCompaniesData(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.registerEntity.resultEntity.message.toString(),
                  context: context));
              navigatorAndRemove(context, Routes.loginRoute);
            } else if (state is RegisterErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: 3 / 1.2,
                        child: Image.asset(
                          ImageAssets.logoImg,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.s30),
                    SelectCompanyWidget(
                        registerCubit: RegisterCubit.get(context)),
                    const SizedBox(
                      height: AppSize.s30,
                    ),
                    RegisterFormWidget(
                      formKey: formKey,
                    ),
                    const SizedBox(
                      height: AppSize.s40,
                    ),
                    Center(
                      child: state is RegisterLoadingState
                          ? const CupertinoActivityIndicator(
                              color: ColorManager.primary,
                              radius: AppSize.s16,
                            )
                          : ElevatedButtonCustom(
                              fontSize: FontSize.s14,
                              textColor: ColorManager.white,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await RegisterCubit.get(context)
                                      .registerFun();
                                  formKey.currentState!.reset();
                                }
                              },
                              text: AppStrings.register,
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextCustom(
                          fontSize: FontSize.s14,
                          text: AppStrings.haveAccount,
                          color: ColorManager.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        TextButton(
                          onPressed: () {
                            navigatorAndRemove(context, Routes.loginRoute);
                          },
                          child: TextCustom(
                              color: ColorManager.primary,
                              fontSize: FontSize.s14,
                              text: AppStrings.login,
                              decoration: TextDecoration.underline),
                        ),
                        const SizedBox(
                          height: AppSize.s40,
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
