// ignore_for_file: deprecated_member_use

import 'package:Attendace/core/widgets/error_widget.dart';
import 'package:Attendace/core/widgets/shimmer_custom/shimmer_custom.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:Attendace/features/myTimeOff/presentation/controller/myTimeOff_cubit.dart';
import 'package:Attendace/features/myTimeOff/presentation/controller/myTimeOff_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/elevated_button/elevated_button_custom.dart';
import 'userRequest_widget.dart';

class PendingTimeWidget extends StatelessWidget {
  const PendingTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MyTimeOffCubit>(context)..getMyTimeOffFun(),
      child: BlocConsumer<MyTimeOffCubit, MyTimeOffState>(
        listener: (context, state) {
          if (state is CancelMyRequestSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                message: state.message.toString(), context: context));
            BlocProvider.of<MyTimeOffCubit>(context).getMyTimeOffFun();
          } else if (state is CancelMyRequestErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                message: state.message.toString(), context: context));
          }
        },
        builder: (context, state) {
          var cubit = MyTimeOffCubit.get(context);

          return cubit.myTimeOffPending.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(AppPadding.p12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserRequestWidget(
                          iconPath: IconsAssets.emailIcon,
                          text: AppStrings.message,
                          subText: cubit.myTimeOffPending[index].holidayStatus,
                        ),
                        UserRequestWidget(
                            iconPath: IconsAssets.calenderIcon,
                            text: AppStrings.date,
                            subText: DateFormat('EEE, MMM dd, yyyy').format(
                                DateTime.parse(
                                    cubit.myTimeOffPending[index].start))),
                        UserRequestWidget(
                            iconPath: IconsAssets.calenderIcon,
                            text: AppStrings.date,
                            subText: DateFormat('EEE, MMM dd, yyyy').format(
                                DateTime.parse(
                                    cubit.myTimeOffPending[index].end))),
                        UserRequestWidget(
                          iconPath: IconsAssets.distanceIcon,
                          text: AppStrings.distance,
                          subText: cubit.myTimeOffPending[index].description,
                        ),
                        UserRequestWidget(
                            iconPath: IconsAssets.clockIcon,
                            text: AppStrings.status,
                            subText: cubit.myTimeOffPending[index].state),
                        const SizedBox(
                          height: 10,
                        ),
                        cubit.myTimeOffPending[index].approvers.isNotEmpty
                            ? Text(
                                AppStrings.approvers,
                                style: TextStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s18,
                                    fontWeight: FontWeight.w600),
                              )
                            : const SizedBox(),
                        cubit.myTimeOffPending[index].approvers.isNotEmpty
                            ? const SizedBox(
                                height: 10,
                              )
                            : const SizedBox(),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, ind) => Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                IconsAssets.personIcon,
                                                height: AppSize.s24,
                                                color: ColorManager.skyColor,
                                              ),
                                              const SizedBox(
                                                width: AppSize.s8,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  cubit.myTimeOffPending[index]
                                                      .approvers[ind].userName,
                                                  style: TextStyle(
                                                    color: ColorManager.primary,
                                                    fontSize: FontSize.s16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                cubit.myTimeOffPending[index]
                                                    .approvers[ind].state,
                                                style: TextStyle(
                                                  color: ColorManager.primary,
                                                  fontSize: FontSize.s14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            cubit.myTimeOffPending[index]
                                                .approvers[ind].reason,
                                            style: TextStyle(
                                              fontSize: FontSize.s14,
                                              color: ColorManager.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            itemCount:
                                cubit.myTimeOffPending[index].approvers.length),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButtonCustom(
                          fontSize: FontSize.s14,
                          colors: ColorManager.error,
                          borderColor: ColorManager.error,
                          fontWeight: FontWeight.w800,
                          width: double.infinity,
                          text: 'Cancel Request',
                          onPressed: () {
                            cubit.cancelMyRequest(
                                requestId: cubit.myTimeOffPending[index].id);
                          },
                        ),
                      ],
                    ),
                  ),
                  itemCount: cubit.myTimeOffPending.length,
                )
              : state is GetMyTimeOffPendingLoading
                  ? ShimmerCustom(
                      child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => const Column(
                        children: [
                          UserRequestWidget(
                            iconPath: IconsAssets.emailIcon,
                            text: AppStrings.message,
                            subText: '',
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.clockIcon,
                            text: AppStrings.status,
                            subText: 'Loading.....',
                          ),
                        ],
                      ),
                      itemCount: 2,
                    ))
                  : ErrorsWidget(
                      onPress: () {
                        cubit.getMyTimeOffFun();
                      },
                    );
        },
      ),
    );
  }
}
