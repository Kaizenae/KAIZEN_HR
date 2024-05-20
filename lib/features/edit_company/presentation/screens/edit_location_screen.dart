import 'package:Attendace/core/utils/font_manager.dart';
import 'package:Attendace/core/utils/routes_manager.dart';
import 'package:Attendace/core/utils/strings_manager.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/assets_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_bar/app_bar_custom.dart';
import '../../../../core/widgets/component.dart';
import '../../../../core/widgets/elevated_button/elevated_button_custom.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../../../../core/widgets/text_form_field/text_form_field_custom.dart';
import '../../../../injection_container.dart';
import '../cubit/edit_company_cubit.dart';
import '../cubit/edit_company_state.dart';

class EditLocationScreen extends StatelessWidget {
  const EditLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBarCustom: const AppBarCustom(
        text: AppStrings.updateLocation,
      ),
      body: BlocProvider(
        create: (context) => sl<EditCompanyCubit>(),
        child: BlocConsumer<EditCompanyCubit, EditCompanyStates>(
          listener: (context, state) {
            if (state is EditCompanySuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message:
                      state.editCompanyEntity.resultEntity.message.toString(),
                  context: context));
              navigatorAndRemove(context, Routes.mainRouteAdmin);
            } else if (state is EditCompanyErrorState) {
              if (kDebugMode) {
                print(state.message);
              }

              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            }
          },
          builder: (context, state) {
            var editCompanyCubit = EditCompanyCubit.get(context);
            editCompanyCubit.formKey.currentState?.reset();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: Form(
                  key: editCompanyCubit.formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          fontSize: FontSize.s14,
                          text: 'Latitude',
                          textAlign: TextAlign.start,
                          color: ColorManager.textFormLabelColor,
                        ),
                        const SizedBox(
                          height: AppSize.s8,
                        ),
                        TextFormFieldCustom(
                          controller: editCompanyCubit.latController,
                          validate: (value) {
                            if (value!.trim().isEmpty || value == ' ') {
                              return 'Latitude must be not Empty';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.number,
                          suffixIcon: IconsAssets.locationIcon,
                          suffix: true,
                        ),
                        const SizedBox(
                          height: AppSize.s16,
                        ),
                        TextCustom(
                          text: 'Longitude',
                          fontSize: FontSize.s14,
                          textAlign: TextAlign.start,
                          color: ColorManager.textFormLabelColor,
                        ),
                        const SizedBox(
                          height: AppSize.s8,
                        ),
                        TextFormFieldCustom(
                          controller: editCompanyCubit.longController,
                          validate: (value) {
                            if (value!.trim().isEmpty || value == ' ') {
                              return 'Longitude must be not Empty';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.number,
                          suffixIcon: IconsAssets.locationIcon,
                          suffix: true,
                        ),
                        const SizedBox(
                          height: AppSize.s40,
                        ),
                        Center(
                          child: state is EditCompanyLoadingState
                              ? const CupertinoActivityIndicator(
                                  color: ColorManager.primary,
                                  radius: AppSize.s16,
                                )
                              : ElevatedButtonCustom(
                                  fontSize: FontSize.s14,

                                  textColor: ColorManager.white,

                                  // width: 100,
                                  onPressed: () async {
                                    if (editCompanyCubit.formKey.currentState!
                                        .validate()) {
                                      await editCompanyCubit.editLocationFun();

                                      editCompanyCubit.formKey.currentState!
                                          .reset();
                                    }
                                  },
                                  text: AppStrings.update,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
