// ignore_for_file: unrelated_type_equality_checks

import 'package:Attendace/core/utils/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../../../../core/widgets/shimmer_custom/shimmer_custom.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../controller/attendance_cubit.dart';
import '../controller/attendance_state.dart';

class OddPunshInScreen extends StatelessWidget {
  const OddPunshInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p12),
          margin: const EdgeInsets.symmetric(
              horizontal: AppPadding.p16, vertical: AppPadding.p12),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(AppSize.s10),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextCustom(
                          text: AppStrings.date,
                          color: ColorManager.black,
                          fontSize: AppSize.s16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextCustom(
                          text: AppStrings.punchIn,
                          color: ColorManager.primary,
                          fontSize: AppSize.s16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextCustom(
                          text: AppStrings.punchOut,
                          color: ColorManager.primary,
                          fontSize: AppSize.s16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                BlocProvider.value(
                  value: BlocProvider.of<AttendanceCubit>(context)
                    ..getOddPunch(),
                  child: BlocConsumer<AttendanceCubit, AttendanceState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return state is GetOddPunchSuccessState
                          ? AttendanceCubit.get(context)
                                  .oddPunchModel
                                  .result
                                  .responseModel
                                  .isEmpty
                              ? const ErrorsWidget()
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppPadding.p12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: TextCustom(
                                              fontSize: FontSize.s14,
                                              text: AttendanceCubit.get(context)
                                                          .oddPunchModel
                                                          .result
                                                          .responseModel[index]
                                                          .checkIn !=
                                                      ""
                                                  ? DateFormat("dd,MMM,yyyy")
                                                      .format(DateTime.parse(
                                                          AttendanceCubit.get(context)
                                                              .oddPunchModel
                                                              .result
                                                              .responseModel[
                                                                  index]
                                                              .checkIn))
                                                  : DateFormat("dd,MMM,yyyy")
                                                      .format(DateTime.parse(
                                                          AttendanceCubit.get(context)
                                                              .oddPunchModel
                                                              .result
                                                              .responseModel[index]
                                                              .checkOut)),
                                              color: ColorManager.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: TextCustom(
                                              fontSize: FontSize.s14,
                                              text: AttendanceCubit.get(context)
                                                          .oddPunchModel
                                                          .result
                                                          .responseModel[index]
                                                          .checkIn !=
                                                      ""
                                                  ? DateFormat('hh: mm a')
                                                      .format(
                                                      DateTime.parse(
                                                              AttendanceCubit.get(
                                                                      context)
                                                                  .oddPunchModel
                                                                  .result
                                                                  .responseModel[
                                                                      index]
                                                                  .checkIn)
                                                          .add(
                                                        const Duration(
                                                          hours: 4,
                                                        ),
                                                      ),
                                                    )
                                                  : '00: 00: 00', // we need add duration about 4 hours to set time in UAE becuse we recive time in UTC time zone
                                              color: ColorManager.primary,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: TextCustom(
                                              fontSize: FontSize.s14,
                                              text: AttendanceCubit.get(context)
                                                          .oddPunchModel
                                                          .result
                                                          .responseModel[index]
                                                          .checkOut !=
                                                      ""
                                                  ? DateFormat('hh: mm a')
                                                      .format(DateTime.parse(
                                                              AttendanceCubit.get(
                                                                      context)
                                                                  .oddPunchModel
                                                                  .result
                                                                  .responseModel[
                                                                      index]
                                                                  .checkOut)
                                                          .add(const Duration(
                                                              hours:
                                                                  4))) // we need add duration about 4 hours to set time in UAE becuse we recive time in UTC time zone
                                                  : '00: 00: 00',
                                              color: ColorManager.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  itemCount: AttendanceCubit.get(context)
                                      .oddPunchModel
                                      .result
                                      .responseModel
                                      .length,
                                )
                          : state is GetOddPunchLoadingState
                              ? ShimmerCustom(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppPadding.p12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextCustom(
                                            fontSize: FontSize.s14,
                                            text: '20 sep',
                                            color: ColorManager.black,
                                          ),
                                          TextCustom(
                                            fontSize: FontSize.s14,
                                            text: '09:00 am',
                                            color: ColorManager.primary,
                                          ),
                                          TextCustom(
                                            fontSize: FontSize.s14,
                                            text: '06:00 pm',
                                            color: ColorManager.error,
                                          ),
                                        ],
                                      ),
                                    ),
                                    itemCount: 10,
                                  ),
                                )
                              : const ErrorsWidget();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
