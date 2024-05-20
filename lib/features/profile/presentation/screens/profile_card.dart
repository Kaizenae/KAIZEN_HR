import 'dart:convert';
import 'package:Attendace/core/widgets/error_widget.dart';
import 'package:Attendace/core/widgets/shimmer_custom/shimmer_custom.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/routes_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/widgets/component.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'profile_component.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ProfileCubit>(context)..getEmployeeFun(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is GetEmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                message: state.message.toString(), context: context));
            ProfileCubit.get(context).getEmployeeFun();
          }
          if (state is LogoutState) {
            navigatorAndRemove(context, Routes.loginRoute);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                state is GetEmployeeSuccess
                    ? Column(
                        children: [
                          state.employeeEntity.resultEntity.response[0].photo
                                  .isEmpty
                              ? Container(
                                  width: 65,
                                  height: 65,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        ImageAssets.userPhotoImg,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(
                                        base64Decode(
                                          state.employeeEntity.resultEntity
                                              .response[0].photo,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: AppSize.s16,
                          ),
                          TextCustom(
                            text: state
                                .employeeEntity.resultEntity.response[0].name,
                            fontWeight: FontWeight.w600,
                            fontSize: FontSize.s16,
                            color: ColorManager.primary,
                          ),
                          const SizedBox(
                            height: AppSize.s16,
                          ),
                          state.employeeEntity.resultEntity.response[0].email
                                  .isEmpty
                              ? const SizedBox()
                              : Container(
                                  padding:
                                      const EdgeInsets.all(AppPadding.p8 / 2),
                                  decoration: BoxDecoration(
                                      color: ColorManager.textBackgroundColor,
                                      borderRadius:
                                          BorderRadius.circular(AppSize.s10)),
                                  child: TextCustom(
                                    text: state.employeeEntity.resultEntity
                                        .response[0].email,
                                    fontSize: FontSize.s16,
                                    color: ColorManager.primary,
                                  ),
                                ),
                          const SizedBox(
                            height: AppSize.s16,
                          ),
                          state.employeeEntity.resultEntity.response[0]
                                  .mobilePhone.isEmpty
                              ? const SizedBox()
                              : TextCustom(
                                  text: state.employeeEntity.resultEntity
                                      .response[0].mobilePhone,
                                  fontSize: FontSize.s12,
                                  color: ColorManager.primary,
                                ),
                          state.employeeEntity.resultEntity.response[0]
                                  .mobilePhone.isEmpty
                              ? const SizedBox()
                              : const SizedBox(
                                  height: AppSize.s20,
                                ),
                          state.employeeEntity.resultEntity.response[0]
                                  .companyName.isEmpty
                              ? const SizedBox()
                              : Container(
                                  padding:
                                      const EdgeInsets.all(AppPadding.p8 / 2),
                                  decoration: BoxDecoration(
                                    color: ColorManager.scaffoldColor,
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s10),
                                  ),
                                  child: TextCustom(
                                    text: state.employeeEntity.resultEntity
                                        .response[0].companyName,
                                    fontSize: FontSize.s14,
                                    color: ColorManager.grey,
                                  ),
                                ),
                        ],
                      )
                    : state is GetEmployeeLoading
                        ? ShimmerCustom(
                            child: Column(
                            children: [
                              const CircleAvatar(
                                radius: AppSize.s30,
                                backgroundColor: ColorManager.primary,
                              ),
                              TextCustom(
                                text: 'Kaizen',
                                fontWeight: FontWeight.w600,
                                fontSize: FontSize.s16,
                                color: ColorManager.black,
                              ),
                              const SizedBox(
                                height: AppSize.s16,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.all(AppPadding.p8 / 2),
                                decoration: BoxDecoration(
                                    color: ColorManager.textBackgroundColor,
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s10)),
                                child: TextCustom(
                                  text: 'xxx@xx.com',
                                  fontSize: FontSize.s16,
                                  color: ColorManager.grey2,
                                ),
                              ),
                              const SizedBox(
                                height: AppSize.s20,
                              ),
                              TextCustom(
                                text: '+201000000000',
                                fontSize: FontSize.s12,
                                color: ColorManager.primary,
                              ),
                            ],
                          ))
                        : ErrorsWidget(
                            onPress: () {
                              BlocProvider.of<ProfileCubit>(context)
                                  .getEmployeeFun();
                            },
                          ),
                const SizedBox(
                  height: AppSize.s40,
                ),
                Container(
                  padding: const EdgeInsets.all(AppPadding.p12),
                  decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(AppSize.s10)),
                  child: Column(
                    children: [
                      const ProfileComponent(
                        iconName: IconsAssets.lockIcon,
                        name: AppStrings.changePassword,
                        screen: Routes.changePasswordRoute,
                      ),
                      const Divider(),
                      const ProfileComponent(
                        iconName: IconsAssets.attendIcon,
                        name: AppStrings.termsConditions,
                        screen: '',
                      ),
                      const Divider(),
                      const ProfileComponent(
                        iconName: IconsAssets.messageQuestionIcon,
                        name: AppStrings.helpsFeedback,
                        screen: Routes.helpRoute,
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                      ),
                      TextButton(
                        onPressed: () async {
                          await ProfileCubit.get(context).logout(context);
                        },
                        child: TextCustom(
                          text: AppStrings.logout,
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.error,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
