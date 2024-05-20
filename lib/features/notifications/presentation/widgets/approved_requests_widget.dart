// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:Attendace/core/widgets/error_widget.dart';
import 'package:Attendace/core/widgets/shimmer_custom/shimmer_custom.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
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
import '../controllers/requests_controller/bloc.dart';
import '../controllers/requests_controller/states.dart';
import 'userRequest_widget.dart';

class ApprovedRequestsWidget extends StatelessWidget {
  ApprovedRequestsWidget({super.key});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: BlocProvider.value(
        value: BlocProvider.of<RequestsBloc>(context)..getRequests(),
        child: BlocConsumer<RequestsBloc, RequestsStates>(
          listener: (context, state) {
            if (state is RejectRequestSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
              RequestsBloc.get(context).getRequests();
            } else if (state is RejectRequestErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
              RequestsBloc.get(context).getRequests();
            } else if (state is CannotOpenFileState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            }
          },
          builder: (context, state) {
            return RequestsBloc.get(context).approvedRequests.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(AppPadding.p12),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                IconsAssets.personIcon,
                                height: AppSize.s24,
                                color: ColorManager.primary,
                              ),
                              const SizedBox(
                                width: AppSize.s8,
                              ),
                              Expanded(
                                child: Text(
                                  RequestsBloc.get(context)
                                      .approvedRequests[index]
                                      .employeeName,
                                  style: TextStyle(
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s16,
                                  ),
                                ),
                              ),
                              RequestsBloc.get(context)
                                      .approvedRequests[index]
                                      .attachment
                                      .isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        RequestsBloc.get(context).convertToFile(
                                          name: RequestsBloc.get(context)
                                              .approvedRequests[index]
                                              .employeeName
                                              .replaceAll(" ", "_"),
                                          extension: RequestsBloc.get(context)
                                              .approvedRequests[index]
                                              .attachmentExtension
                                              .toString(),
                                          base64String:
                                              RequestsBloc.get(context)
                                                  .approvedRequests[index]
                                                  .attachment,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.download,
                                        size: 28,
                                        color: ColorManager.primary,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.emailIcon,
                            text: AppStrings.message,
                            subText: RequestsBloc.get(context)
                                .approvedRequests[index]
                                .type,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                IconsAssets.messageQuestionIcon,
                                height: AppSize.s24,
                                color: ColorManager.primary,
                              ),
                              const SizedBox(
                                width: AppSize.s8,
                              ),
                              Expanded(
                                child: Text(
                                  RequestsBloc.get(context)
                                      .approvedRequests[index]
                                      .reason,
                                  style: TextStyle(
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s16,
                                  ),
                                ),
                              )
                            ],
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.calenderIcon,
                            text: AppStrings.date,
                            subText: DateFormat('EEE, MMM dd, yyyy').format(
                              DateTime.parse(
                                RequestsBloc.get(context)
                                    .approvedRequests[index]
                                    .startDate,
                              ),
                            ),
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.calenderIcon,
                            text: AppStrings.date,
                            subText: DateFormat('EEE, MMM dd, yyyy').format(
                              DateTime.parse(
                                RequestsBloc.get(context)
                                    .approvedRequests[index]
                                    .endDate,
                              ),
                            ),
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.clockIcon,
                            text: AppStrings.duration,
                            subText: RequestsBloc.get(context)
                                .approvedRequests[index]
                                .duration
                                .toString(),
                          ),
                          UserRequestWidget(
                            iconPath: IconsAssets.clockIcon,
                            text: AppStrings.duration,
                            subText: RequestsBloc.get(context)
                                .approvedRequests[index]
                                .state
                                .toString(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButtonCustom(
                              fontSize: FontSize.s14,
                              colors: ColorManager.error,
                              borderColor: ColorManager.error,
                              fontWeight: FontWeight.w800,
                              width: double.infinity,
                              text: AppStrings.rejectRequest,
                              onPressed: () {
                                scaffoldKey.currentState!
                                    .showBottomSheet(
                                      (context) => Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                        ),
                                        padding:
                                            const EdgeInsetsDirectional.all(
                                                20.0),
                                        child: Form(
                                          key: formKey,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  controller:
                                                      RequestsBloc.get(context)
                                                          .reasonController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return (AppStrings
                                                          .reasonMustNotBeEmpty);
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        AppStrings.reason,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    prefixIcon: const Icon(
                                                      Icons.title,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                ElevatedButtonCustom(
                                                  fontSize: FontSize.s14,
                                                  colors: ColorManager.error,
                                                  borderColor:
                                                      ColorManager.error,
                                                  fontWeight: FontWeight.w800,
                                                  width: double.infinity,
                                                  text:
                                                      AppStrings.rejectRequest,
                                                  onPressed: () {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      RequestsBloc.get(context)
                                                          .rejectRequest(
                                                        requestId: RequestsBloc
                                                                .get(context)
                                                            .approvedRequests[
                                                                index]
                                                            .id,
                                                        type: RequestsBloc.get(
                                                                context)
                                                            .approvedRequests[
                                                                index]
                                                            .type,
                                                        reason: RequestsBloc
                                                                .get(context)
                                                            .reasonController
                                                            .text,
                                                      );
                                                      Navigator.pop(context);
                                                      RequestsBloc.get(context)
                                                          .reasonController
                                                          .clear();
                                                      RequestsBloc.get(context)
                                                          .changeBottomSheet(
                                                        isShow: false,
                                                      );
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .closed
                                    .then((value) {});
                              }),
                        ],
                      ),
                    ),
                    itemCount:
                        RequestsBloc.get(context).approvedRequests.length,
                  )
                : state is RequestLoadingState
                    ? ShimmerCustom(
                        child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Column(
                            children: List.generate(
                          6,
                          (index) => const UserRequestWidget(
                            iconPath: IconsAssets.emailIcon,
                            text: AppStrings.message,
                            subText: 'Loading.....',
                          ),
                        )),
                        itemCount: 2,
                      ))
                    : state is RequestErrorState ||
                            RequestsBloc.get(context).approvedRequests.isEmpty
                        ? ErrorsWidget(
                            onPress: () {},
                          )
                        : ShimmerCustom(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Column(
                                children: List.generate(
                                  6,
                                  (index) => const UserRequestWidget(
                                    iconPath: IconsAssets.emailIcon,
                                    text: AppStrings.message,
                                    subText: 'Loading.....',
                                  ),
                                ),
                              ),
                              itemCount: 2,
                            ),
                          );
          },
        ),
      ),
    );
  }
}
