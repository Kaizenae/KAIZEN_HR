// ignore_for_file: use_build_context_synchronously
import 'package:Attendace/core/utils/font_manager.dart';
import 'package:Attendace/core/widgets/elevated_button/elevated_button_custom.dart';
import 'package:Attendace/core/widgets/scaffold_custom/scaffold_custom.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:Attendace/core/widgets/text_custom/text_custom.dart';
import 'package:Attendace/core/widgets/text_form_field/text_form_field_custom.dart';
import 'package:Attendace/features/late_in_and_early_out/presentation/controller/cubit.dart';
import 'package:Attendace/features/late_in_and_early_out/presentation/controller/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_bar/app_bar_custom.dart';

class CreateLateInEarlyOutScreen extends StatefulWidget {
  const CreateLateInEarlyOutScreen({super.key, required this.title});
  final String title;

  @override
  State<CreateLateInEarlyOutScreen> createState() =>
      _CreateLateInEarlyOutScreenState();
}

class _CreateLateInEarlyOutScreenState
    extends State<CreateLateInEarlyOutScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBarCustom: AppBarCustom(text: widget.title),
      body: BlocProvider(
        create: (context) => EarlyOutLateInCubit(),
        child: BlocConsumer<EarlyOutLateInCubit, EarlyOutLateInStates>(
          listener: (context, state) {
            if (state is EarlyOutErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            } else if (state is EarlyOutSuccessState) {
              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            } else if (state is LateInSuccessState) {
              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            } else if (state is LateInErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            }
          },
          builder: (context, state) {
            var cubit = BlocProvider.of<EarlyOutLateInCubit>(context);

            return Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: SafeArea(
                child: Form(
                  key: formKey,
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: AppSize.s10,
                                  ),

                                  TextCustom(
                                    fontSize: FontSize.s14,
                                    text: AppStrings.date,
                                    color: ColorManager.textFormLabelColor,
                                  ),
                                  const SizedBox(
                                    height: AppSize.s8,
                                  ),
                                  //Date
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: ColorManager.textFormColor,
                                      border: Border.all(
                                          color: ColorManager.textFormColor,
                                          width: 2),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.title ==
                                            AppStrings.lateInRequest) {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now(),
                                          ).then(
                                            (value) {
                                              cubit.selectedDate =
                                                  DateFormat("yyyy-MM-dd")
                                                      .format(DateTime.parse(
                                                          value.toString()));

                                              EarlyOutLateInCubit.get(context)
                                                  .changeDate(DateFormat(
                                                          "dd-MM-yyyy")
                                                      .format(DateTime.parse(
                                                          value.toString())));
                                            },
                                          );
                                        } else if (widget.title ==
                                            AppStrings.earlyOutRequest) {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(
                                                const Duration(days: 1)),
                                            lastDate: DateTime.now(),
                                          ).then(
                                            (value) {
                                              cubit.selectedDate =
                                                  DateFormat("yyyy-MM-dd")
                                                      .format(DateTime.parse(
                                                          value.toString()));

                                              EarlyOutLateInCubit.get(context)
                                                  .changeDate(DateFormat(
                                                          "dd,MMM,yyyy")
                                                      .format(DateTime.parse(
                                                          value.toString())));
                                            },
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextCustom(
                                            text: cubit.selectedDateShow!,
                                            color: ColorManager.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                          SvgPicture.asset(
                                            IconsAssets.calenderIcon,
                                            width: 24,
                                            height: 24,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppSize.s20,
                                  ),
                                  TextCustom(
                                    fontSize: FontSize.s14,
                                    text: AppStrings.reason,
                                    color: ColorManager.textFormLabelColor,
                                  ),
                                  const SizedBox(
                                    height: AppSize.s8,
                                  ),
                                  TextFormFieldCustom(
                                    controller: cubit.reasonController,
                                    keyboardType: TextInputType.text,
                                    validate: (validate) {
                                      if (validate!.isEmpty) {
                                        return widget.title ==
                                                AppStrings.lateInRequest
                                            ? AppStrings
                                                .pleaseEnterTheReasonForLateIn
                                            : AppStrings
                                                .pleaseEnterTheReasonEarlyOut;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: AppSize.s20,
                                  ),
                                  TextCustom(
                                    fontSize: FontSize.s14,
                                    text: AppStrings.attachment,
                                    color: ColorManager.textFormLabelColor,
                                  ),
                                  const SizedBox(
                                    height: AppSize.s8,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: ColorManager.textFormColor,
                                      border: Border.all(
                                          color: ColorManager.textFormColor,
                                          width: 2),
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        cubit.pickFileFromDevice();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextCustom(
                                            text: cubit.fileName ?? "File Name",
                                            color: ColorManager.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                          SvgPicture.asset(
                                            IconsAssets.attachmentIcon,
                                            width: 24,
                                            height: 24,
                                            // ignore: deprecated_member_use
                                            color: const Color(0xff3D8BD3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: AppSize.s20,
                            ),
                            SizedBox(
                              child: state is EarlyOutLoadingState ||
                                      state is LateInLoadingState
                                  ? const Center(
                                      child: CupertinoActivityIndicator(
                                        color: ColorManager.primary,
                                        radius: AppSize.s16,
                                      ),
                                    )
                                  : ElevatedButtonCustom(
                                      text: AppStrings.submit,
                                      fontWeight: FontWeight.w500,
                                      fontSize: FontSize.s18,
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          if (widget.title ==
                                              AppStrings.lateInRequest) {
                                            cubit.lateIn();
                                          } else if (widget.title ==
                                              AppStrings.earlyOutRequest) {
                                            cubit.earlyOutRequest();
                                          }
                                        }
                                      },
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
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
