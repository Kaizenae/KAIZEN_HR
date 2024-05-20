// ignore_for_file: file_names, deprecated_member_use
import 'package:Attendace/core/utils/assets_manager.dart';
import 'package:Attendace/core/utils/font_manager.dart';
import 'package:Attendace/core/utils/media_query_values.dart';
import 'package:Attendace/core/utils/strings_manager.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_bar/app_bar_custom.dart';
import '../../../../core/widgets/elevated_button/elevated_button_custom.dart';
import '../../../../core/widgets/progress_indicator/progress_indicator.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../../../../core/widgets/text_form_field/text_form_field_custom.dart';
import '../../../../injection_container.dart';
import '../controller/create_timeOff_cubit.dart';
import '../controller/create_timeOff_state.dart';
import '../controller/timeOff_controller/timeOff_cubit.dart';
import '../controller/timeOff_controller/timeOff_state.dart';

class CreateTimeOffScreen extends StatefulWidget {
  const CreateTimeOffScreen({super.key});

  @override
  State<CreateTimeOffScreen> createState() => _CreateTimeOffScreenState();
}

class _CreateTimeOffScreenState extends State<CreateTimeOffScreen> {
  final reasonTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateTimeOffCubit(createTimeOffUsecase: sl()),
      child: ScaffoldCustom(
        appBarCustom: const AppBarCustom(text: AppStrings.applyLeaveRequest),
        body: BlocConsumer<CreateTimeOffCubit, CreateTimeOffState>(
          listener: (context, state) {
            if (state is CreateTimeOffSuccess) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message:
                      state.createTimeOffEntity.resultEntity.message.toString(),
                  context: context));
            } else if (state is CreateTimeOffError) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            }
          },
          builder: (context, state) {
            var cubit = CreateTimeOffCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: SafeArea(
                child: Form(
                  key: cubit.formKey,
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                    text: AppStrings.type,
                                    fontSize: FontSize.s14,
                                    color: ColorManager.textFormLabelColor,
                                  ),
                                  const SizedBox(
                                    height: AppSize.s4,
                                  ),
                                  BlocProvider.value(
                                    value:
                                        BlocProvider.of<TimeOffCubit>(context)
                                          ..getTimeOffFun(),
                                    child: BlocConsumer<TimeOffCubit,
                                        TimeOffState>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        return DropdownButtonHideUnderline(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorManager.textFormColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                AppSize.s8,
                                              ),
                                            ),
                                            width: context.width / 1.1,
                                            height: AppSize.s50,
                                            child: state is GetTimeOffSuccess
                                                ? InkWell(
                                                    onTap: () {
                                                      TimeOffCubit.get(context)
                                                          .getTimeOffFun();
                                                      showCupertinoModalPopup<
                                                          void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            height:
                                                                AppSize.s100 *
                                                                    3,
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 6.0,
                                                            ),
                                                            color:
                                                                CupertinoColors
                                                                    .white,
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      DefaultTextStyle(
                                                                    style:
                                                                        const TextStyle(
                                                                      color: CupertinoColors
                                                                          .black,
                                                                      fontSize:
                                                                          22.0,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    child:
                                                                        GestureDetector(
                                                                      // Blocks taps from propagating to the modal sheet and popping.
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          SafeArea(
                                                                        top:
                                                                            false,
                                                                        child:
                                                                            CupertinoPicker(
                                                                          scrollController:
                                                                              FixedExtentScrollController(initialItem: 6),

                                                                          magnification:
                                                                              1.5,
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          itemExtent:
                                                                              35,
                                                                          //height of each item
                                                                          looping:
                                                                              false,

                                                                          children:
                                                                              List.generate(
                                                                            state.getTimeOffEntity.resultEntity.response.length,
                                                                            (index) =>
                                                                                Center(
                                                                              child: TextCustom(
                                                                                color: ColorManager.primary,
                                                                                fontSize: FontSize.s14,
                                                                                textAlign: TextAlign.center,
                                                                                text: state.getTimeOffEntity.resultEntity.response[index].name,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onSelectedItemChanged:
                                                                              (index) {
                                                                            if (state.getTimeOffEntity.resultEntity.response.length ==
                                                                                1) {
                                                                              cubit.selectedValue = state.getTimeOffEntity.resultEntity.response[index].id;
                                                                              cubit.checkType = state.getTimeOffEntity.resultEntity.response[index].name;
                                                                            }
                                                                            cubit.selectedValue =
                                                                                state.getTimeOffEntity.resultEntity.response[index].id;
                                                                            cubit.checkType =
                                                                                state.getTimeOffEntity.resultEntity.response[index].name;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      ElevatedButtonCustom(
                                                                    fontSize:
                                                                        FontSize
                                                                            .s14,
                                                                    text: AppStrings
                                                                        .done,
                                                                    onPressed:
                                                                        () {
                                                                      cubit.getTimeOff(
                                                                          cubit
                                                                              .checkType);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Center(
                                                      child: TextCustom(
                                                        fontSize: FontSize.s14,
                                                        text: cubit.checkType
                                                                .isNotEmpty
                                                            ? cubit.checkType
                                                            : AppStrings
                                                                .selectType,
                                                        color: cubit.checkType
                                                                .isNotEmpty
                                                            ? ColorManager
                                                                .secondary
                                                            : ColorManager
                                                                .textFormIconColor,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  )
                                                : const ProgressIndicatorCustom(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppSize.s16,
                                  ),
                                  TextCustom(
                                    fontSize: FontSize.s14,
                                    text: AppStrings.startDate,
                                    color: ColorManager.textFormLabelColor,
                                  ),
                                  const SizedBox(
                                    height: AppSize.s4,
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
                                        showDatePicker(
                                                context: context,
                                                initialDate: cubit.initDate,
                                                firstDate: DateTime.now()
                                                    .subtract(const Duration(
                                                        days: 1000)),
                                                lastDate: DateTime.now().add(
                                                    const Duration(days: 1000)))
                                            .then(
                                          (value) {
                                            cubit.selectedStartDate =
                                                DateFormat("yyyy-MM-dd").format(
                                                    DateTime.parse(
                                                        value.toString()));

                                            cubit.changeStartDate(
                                                dateTime: value!,
                                                date: DateFormat("dd,MMM,yyyy")
                                                    .format(DateTime.parse(
                                                        value.toString())));
                                            setState(() {});
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextCustom(
                                            text: cubit.selectedStartDateShow!,
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
                                    height: AppSize.s16,
                                  ),
                                  TextCustom(
                                    fontSize: FontSize.s14,
                                    text: AppStrings.endDate,
                                    color: ColorManager.textFormLabelColor,
                                  ),
                                  const SizedBox(
                                    height: AppSize.s4,
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
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: cubit.initDate,
                                                firstDate: DateTime.now()
                                                    .subtract(const Duration(
                                                        days: 1000)),
                                                lastDate: DateTime.now().add(
                                                    const Duration(days: 1000)))
                                            .then(
                                          (value) {
                                            cubit.selectedEndDate =
                                                DateFormat("yyyy-MM-dd").format(
                                                    DateTime.parse(
                                                        value.toString()));

                                            cubit.changeEndDate(
                                                dateTime: value!,
                                                date: DateFormat("dd,MMM,yyyy")
                                                    .format(DateTime.parse(
                                                        value.toString())));
                                            setState(() {});
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextCustom(
                                            text: cubit.selectedEndDateShow!,
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
                                    controller: reasonTextController,
                                    keyboardType: TextInputType.text,
                                    validate: (validate) {
                                      if (validate!.isEmpty) {
                                        return AppStrings
                                            .pleaseEnterTheReasonForLeave;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: AppSize.s16,
                                  ),
                                  TextCustom(
                                    fontSize: FontSize.s14,
                                    text: AppStrings.attachment,
                                    color: ColorManager.textFormLabelColor,
                                  ),
                                  const SizedBox(
                                    height: AppSize.s4,
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
                                            color: const Color(0xff3D8BD3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppSize.s16,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: AppSize.s20,
                            ),
                            SizedBox(
                              child: state is CreateTimeOffLoading
                                  ? const Center(
                                      child: CupertinoActivityIndicator(
                                        color: ColorManager.primary,
                                        radius: AppSize.s16,
                                      ),
                                    )
                                  : ElevatedButtonCustom(
                                      text: AppStrings.save,
                                      fontWeight: FontWeight.w500,
                                      fontSize: FontSize.s18,
                                      onPressed: () async {
                                        if (cubit.formKey.currentState!
                                            .validate()) {
                                          if (cubit.selectedValue != null) {
                                            cubit.createTimeOffFun(
                                              reason: reasonTextController.text,
                                            );
                                            cubit.formKey.currentState!.reset();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBarWidget(
                                                    message: AppStrings
                                                        .youMustChooseALeaveType,
                                                    context: context));
                                          }
                                        }
                                      }),
                            ),
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
