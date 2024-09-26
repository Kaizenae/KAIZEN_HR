// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:Attendace/core/widgets/error_widget.dart';
import 'package:Attendace/core/widgets/shimmer_custom/shimmer_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../controllers/requests_controller/bloc.dart';
import '../controllers/requests_controller/states.dart';
import 'userRequest_widget.dart';

class RejectedRequestsWidget extends StatelessWidget {
  const RejectedRequestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<RequestsBloc>(context)..getRequests(),
      child: BlocConsumer<RequestsBloc, RequestsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          log(state.toString());
          return state is RequestSuccessState &&
                  RequestsBloc.get(context).rejectedRequests.isNotEmpty
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
                                    .rejectedRequests[index]
                                    .employeeName,
                                style: TextStyle(
                                  color: ColorManager.primary,
                                  fontSize: FontSize.s16,
                                ),
                              ),
                            ),
                            RequestsBloc.get(context)
                                    .rejectedRequests[index]
                                    .attachment
                                    .isNotEmpty
                                ? GestureDetector(
                                    onTap: () async {
                                      await launchInBrowser(Uri.parse(
                                          RequestsBloc.get(context)
                                              .rejectedRequests[index]
                                              .attachment));
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
                              .rejectedRequests[index]
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
                                    .rejectedRequests[index]
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
                                  .rejectedRequests[index]
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
                                  .rejectedRequests[index]
                                  .endDate,
                            ),
                          ),
                        ),
                        UserRequestWidget(
                          iconPath: IconsAssets.clockIcon,
                          text: AppStrings.duration,
                          subText: RequestsBloc.get(context)
                              .rejectedRequests[index]
                              .duration
                              .toString(),
                        ),
                        UserRequestWidget(
                          iconPath: IconsAssets.clockIcon,
                          text: AppStrings.duration,
                          subText: RequestsBloc.get(context)
                              .rejectedRequests[index]
                              .state
                              .toString(),
                        ),
                      ],
                    ),
                  ),
                  itemCount: RequestsBloc.get(context).rejectedRequests.length,
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
                      ),
                    )
                  : state is RequestErrorState ||
                          RequestsBloc.get(context).rejectedRequests.isEmpty
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
    );
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
