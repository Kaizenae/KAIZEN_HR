import 'package:Attendace/core/utils/media_query_values.dart';
import 'package:Attendace/core/utils/strings_manager.dart';
import 'package:Attendace/core/widgets/app_bar/app_bar_custom.dart';
import 'package:Attendace/core/widgets/scaffold_custom/scaffold_custom.dart';
import 'package:Attendace/core/widgets/snack_bar/snack_bar_widget.dart';
import 'package:Attendace/features/late_in_and_early_out/presentation/controller/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/elevated_button/elevated_button_custom.dart';
import '../../../../core/widgets/tab_bar_custom/tab_bar_custom.dart';
import '../controller/cubit.dart';
import '../widget/approved_widget.dart';
import '../widget/pending_time_widget.dart';
import '../widget/refuse_widget.dart';
import 'create_late_in_and_early_out_screen.dart';

class LateInAndEarlyOutScreen extends StatelessWidget {
  const LateInAndEarlyOutScreen({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EarlyOutLateInCubit()
        ..getLateIn()
        ..getEarlyOut(),
      child: ScaffoldCustom(
        appBarCustom: AppBarCustom(
          text: title,
        ),
        body: BlocConsumer<EarlyOutLateInCubit, EarlyOutLateInStates>(
          listener: (context, state) {
            if (state is CancelMyRequestSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
              EarlyOutLateInCubit.get(context).getEarlyOut();
              EarlyOutLateInCubit.get(context).getLateIn();
            } else if (state is CancelMyRequestErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message: state.message.toString(), context: context));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(
                    height: AppSize.s16,
                  ),
                  Center(
                    child: ElevatedButtonCustom(
                      fontSize: FontSize.s14,
                      colors: ColorManager.secondary,
                      width: context.width / 1.6,
                      text: AppStrings.applyRequest,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateLateInEarlyOutScreen(
                              title: title,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s20,
                  ),
                  TabBarCustom(
                    widgets: [
                      PendingWidget(
                        title: title,
                        state: state,
                      ),
                      ApprovedWidget(
                        title: title,
                        state: state,
                      ),
                      RefusedWidget(
                        title: title,
                        state: state,
                      ),
                    ],
                    myTabs: const [
                      Tab(
                        text: AppStrings.pending,
                      ),
                      Tab(
                        text: AppStrings.approved,
                      ),
                      Tab(
                        text: AppStrings.rejected,
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
