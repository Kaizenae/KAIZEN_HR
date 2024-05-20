// ignore_for_file: unused_local_variable

import 'package:Attendace/core/widgets/error_widget.dart';
import 'package:Attendace/core/widgets/shimmer_custom/shimmer_custom.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:Attendace/features/myLoans/presentation/controller/myLoans_state.dart';
import 'package:Attendace/features/notifications/presentation/controllers/accept_reject_request/accept_reject_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/svg_pic/svg_pic.dart';
import '../controller/myLoans_cubit.dart';
import 'userRequest_widget.dart';

class PendingWidget extends StatelessWidget {
  const PendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyLoansCubit, MyLoansState>(
      listener: (context, state) {
        if (state is CancelMyLoansSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
              message: "Loan Canceled Successfuly", context: context));
        }
      },
      builder: (context, state) {
        var loansCubit = MyLoansCubit.get(context);
        return state is GetMyLoansSuccess
            ? ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(AppPadding.p12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserRequestWidget(
                            iconPath: IconsAssets.emailIcon,
                            text: AppStrings.message,
                            subText: state.myLoansEntity.resultEntity
                                .response[index].employeeId,
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.calenderIcon,
                            text: AppStrings.date,
                            subText: DateFormat('EEE, MMM dd, yyyy').format(
                                DateTime.parse(MyLoansCubit.get(context)
                                    .myLoansPending[index]
                                    .loanDate)),
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.distanceIcon,
                            text: AppStrings.distance,
                            subText:
                                '${MyLoansCubit.get(context).myLoansPending[index].loanAmount} ${MyLoansCubit.get(context).myLoansPending[index].currencyId}',
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.clockIcon,
                            text: AppStrings.status,
                            subText: AcceptRejectRequestCubit.get(context)
                                .stateLoansFun(MyLoansCubit.get(context)
                                    .myLoansPending[index]
                                    .loanState),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Visibility(
                          visible: MyLoansCubit.get(context)
                                  .myLoansPending[index]
                                  .loanState ==
                              'draft',
                          child: Column(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    MyLoansCubit.get(context).loanID =
                                        MyLoansCubit.get(context)
                                            .myLoansPending[index]
                                            .id;
                                    await MyLoansCubit.get(context)
                                        .updatetMyLoansFun(state: 'cancel');
                                  },
                                  child: const SvgPictureCustom(
                                    assetsName: IconsAssets.rejectIcon,
                                    color: ColorManager.skyColor,
                                    height: AppSize.s40,
                                  )),
                              InkWell(
                                  onTap: () async {
                                    MyLoansCubit.get(context).loanID =
                                        MyLoansCubit.get(context)
                                            .myLoansPending[index]
                                            .id;
                                    await MyLoansCubit.get(context)
                                        .updatetMyLoansFun(
                                            state: 'waiting_approval_1');
                                  },
                                  child: const SvgPictureCustom(
                                    assetsName: IconsAssets.acceptIcon,
                                    color: ColorManager.skyColor,
                                    height: AppSize.s40,
                                  )),
                            ],
                          )),
                    ],
                  ),
                ),
                itemCount: MyLoansCubit.get(context).myLoansPending.length,
              )
            : state is GetMyLoansLoading
                ? ShimmerCustom(
                    child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => const Column(
                      children: [
                        UserRequestWidget(
                          iconPath: IconsAssets.emailIcon,
                          text: AppStrings.message,
                          subText: 'Loading.......',
                        ),
                        UserRequestWidget(
                          iconPath: IconsAssets.calenderIcon,
                          text: AppStrings.date,
                          subText: 'Loading.......',
                        ),
                        UserRequestWidget(
                          iconPath: IconsAssets.clockIcon,
                          text: AppStrings.time,
                          subText: 'Loading.......',
                        ),
                        UserRequestWidget(
                          iconPath: IconsAssets.distanceIcon,
                          text: AppStrings.distance,
                          subText: ' Loading.......',
                        ),
                      ],
                    ),
                    itemCount: 2,
                  ))
                : ErrorsWidget(
                    onPress: () {
                      BlocProvider.of<MyLoansCubit>(context).getMyLoansFun();
                    },
                  );
      },
    );
  }
}
