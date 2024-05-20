// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:Attendace/core/utils/routes_manager.dart';
import 'package:Attendace/core/utils/strings_manager.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:Attendace/features/late_in_and_early_out/presentation/screens/late_in_and_early_out_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_home_item/custom_home_item.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_state.dart';
import '../controller/home_cubit.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../controller/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      body: BlocProvider.value(
        value: BlocProvider.of<HomeCubit>(context),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is CheckInAndOutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message:
                      state.punchInOutEntity.resultEntity.message.toString(),
                  context: context));
            } else if (state is CheckInAndOutError) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            }
          },
          builder: (context, state) {
            var homeCubit = HomeCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          ImageAssets.homeIconImg,
                          height: AppSize.s100,
                          width: AppSize.s150,
                        ),
                        BlocProvider.value(
                          value: BlocProvider.of<ProfileCubit>(context)
                            ..getEmployeeFun(),
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              return state is GetEmployeeSuccess
                                  ? state.employeeEntity.resultEntity
                                          .response[0].photo.isEmpty
                                      ? Container(
                                          width: 65,
                                          height: 65,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  ImageAssets.userPhotoImg,
                                                ),
                                              )),
                                        )
                                      : Container(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          width: 65,
                                          height: 65,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(
                                                base64Decode(
                                                  state
                                                      .employeeEntity
                                                      .resultEntity
                                                      .response[0]
                                                      .photo,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                  : Container(
                                      width: 65,
                                      height: 65,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            ImageAssets.userPhotoImg,
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //

                    ////////////////////////////////////// PUNCH IN PUNCH OUT item ///////////////////////////////

                    //  StreamBuilder(
                    //                           stream: Stream.periodic(const Duration(seconds: 1)),
                    //                           builder: (context, snapshot) {
                    //                             return Column(
                    //                               crossAxisAlignment: CrossAxisAlignment.center,
                    //                               children: [
                    //                                 Row(
                    //                                   mainAxisAlignment: MainAxisAlignment.center,
                    //                                   crossAxisAlignment: CrossAxisAlignment.end,
                    //                                   children: [
                    //                                     TextCustom(
                    //                                       text: DateFormat('hh: mm')
                    //                                           .format(DateTime.now()),
                    //                                       fontSize: FontSize.s32.sp,
                    //                                       color: ColorManager.black,
                    //                                     ),
                    //                                     SizedBox(
                    //                                       width: AppSize.s4.w,
                    //                                     ),
                    //                                     TextCustom(
                    //                                       text: DateFormat('ss')
                    //                                           .format(DateTime.now()),
                    //                                       fontSize: FontSize.s22,
                    //                                       color: ColorManager.black,
                    //                                     ),
                    //                                     SizedBox(
                    //                                       width: AppSize.s4.w,
                    //                                     ),
                    //                                     TextCustom(
                    //                                       text: DateFormat('a')
                    //                                           .format(DateTime.now()),
                    //                                       fontSize: FontSize.s22.sp,
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                                 TextCustom(
                    //                                   text: DateFormat('EEE, MMM dd, yyyy')
                    //                                       .format(DateTime.now()),
                    //                                   fontSize: FontSize.s20.sp,
                    //                                   color: ColorManager.black,
                    //                                 ),
                    //                               ],
                    //                             );
                    //                           },
                    //                         ),
                    //                         SizedBox(
                    //                           height: AppSize.s80.h,
                    //                         ),

                    //                         state is CheckInAndOutLoading
                    //                             ? const Center(
                    //                                 child: ProgressIndicatorCustom(),
                    //                               )
                    //                             : BlocProvider.value(
                    //                                 value: BlocProvider.of<CompaniesCubit>(context)
                    //                                   ..getCompanyFun(),
                    //                                 child: BlocConsumer<CompaniesCubit,
                    //                                     CompaniesState>(
                    //                                   listener: (context, state) {},
                    //                                   builder: (context, state) {
                    //                                     return state is GetCompanySuccess
                    //                                         ? InkWell(
                    //                                             onTap: () async {
                    //                                               // await homeCubit.punchInOutFun();
                    //                                               homeCubit.lat = double.parse(state
                    //                                                   .companiesEntity
                    //                                                   .resultEntity
                    //                                                   .response[0]
                    //                                                   .lat);
                    //                                               homeCubit.long = double.parse(
                    //                                                   state
                    //                                                       .companiesEntity
                    //                                                       .resultEntity
                    //                                                       .response[0]
                    //                                                       .long);

                    //                                               await homeCubit.checkDistance();

                    //                                               if (homeCubit.checked) {
                    //                                                 await homeCubit.punchInOutFun();
                    //                                                 Future.delayed(
                    //                                                   const Duration(
                    //                                                       milliseconds: 100),
                    //                                                   () async => await BlocProvider
                    //                                                           .of<AttendanceCubit>(
                    //                                                               context)
                    //                                                       .getAttendanceFun(),
                    //                                                 );
                    //                                               } else {
                    //                                                 Future.delayed(
                    //                                                     const Duration(
                    //                                                         milliseconds: 100),
                    //                                                     () async => navigator(
                    //                                                         context,
                    //                                                         Routes
                    //                                                             .createRequestRoute));
                    //                                               }
                    //                                             },
                    //                                             child: state is CheckInAndOutLoading
                    //                                                 ? ShimmerCustom(
                    //                                                     child: SvgPicture.asset(
                    //                                                       IconsAssets.punchinIcon,
                    //                                                     ),
                    //                                                   )
                    //                                                 : FadeIn(
                    //                                                     child: BlocProvider.value(
                    //                                                       value: BlocProvider.of<
                    //                                                               AttendanceCubit>(
                    //                                                           context)
                    //                                                         ..getAttendanceFun(),
                    //                                                       child: BlocBuilder<
                    //                                                           AttendanceCubit,
                    //                                                           AttendanceState>(
                    //                                                         builder:
                    //                                                             (context, state) {
                    //                                                           return state
                    //                                                                   is GetAttendanceLoading
                    //                                                               ? const Center(
                    //                                                                   child:
                    //                                                                       ProgressIndicatorCustom(),
                    //                                                                 )
                    //                                                               : state
                    //                                                                       is GetAttendanceSuccess
                    //                                                                   ? SvgPicture
                    //                                                                       .asset(
                    //                                                                       state.attendanceEntity.resultEntity.response.isEmpty ||
                    //                                                                               state.attendanceEntity.resultEntity.response.first.checkOut !=
                    //                                                                                   'false'
                    //                                                                           ? IconsAssets
                    //                                                                               .punchinIcon
                    //                                                                           : IconsAssets
                    //                                                                               .punchOutIcon,
                    //                                                                     )
                    //                                                                   : SvgPicture
                    //                                                                       .asset(
                    //                                                                       AppConstants.punchIn !=
                    //                                                                               "false"
                    //                                                                           ? IconsAssets
                    //                                                                               .punchinIcon
                    //                                                                           : IconsAssets
                    //                                                                               .punchOutIcon,
                    //                                                                     );
                    //                                                         },
                    //                                                       ),
                    //                                                     ),
                    //                                                   ),
                    //                                           )
                    //                                         : state is GetCompanySuccess
                    //                                             ? const Center(
                    //                                                 child:
                    //                                                     ProgressIndicatorCustom(),
                    //                                               )
                    //                                             : ElevatedButtonCustom(
                    //                                                 width: AppSize.s100.w,
                    //                                                 text: 'Reload',
                    //                                                 onPressed: () async {
                    //                                                   await BlocProvider.of<
                    //                                                               CompaniesCubit>(
                    //                                                           context)
                    //                                                       .getCompanyFun();
                    //                                                 },
                    //                                               );
                    //                                   },
                    //                                 ),
                    //                               ),

                    Expanded(
                      child: Row(
                        children: [
                          CustomHomeItem(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.myTimeOffRoute,
                              );
                            },
                            icon: ImageAssets.timeOffImg,
                            label: AppStrings.myLeave,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          CustomHomeItem(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LateInAndEarlyOutScreen(
                                    title: AppStrings.lateInRequest,
                                  ),
                                ),
                              );
                            },
                            icon: ImageAssets.lateInImg,
                            label: AppStrings.myLateIn,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          CustomHomeItem(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LateInAndEarlyOutScreen(
                                      title: AppStrings.earlyOutRequest,
                                    ),
                                  ));
                            },
                            icon: ImageAssets.checkOut,
                            label: AppStrings.myEarlyOut,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          CustomHomeItem(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.hrPoliciesRoute,
                              );
                            },
                            icon: ImageAssets.policyImg,
                            label: AppStrings.hrPolicy,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomHomeItem(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.shiftAllocationRoute,
                              );
                            },
                            icon: ImageAssets.shiftAllocationImg,
                            label: AppStrings.myShiftAllocation,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          CustomHomeItem(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.attendanceRoute,
                              );
                            },
                            icon: ImageAssets.attendanceImg,
                            label: AppStrings.myAttendance,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
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
