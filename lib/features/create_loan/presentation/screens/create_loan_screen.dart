import 'dart:io';
import 'package:Attendace/core/utils/font_manager.dart';
import 'package:Attendace/core/widgets/progress_indicator/progress_indicator.dart';
import 'package:Attendace/core/widgets/text_form_field/text_form_field_custom.dart';
import 'package:Attendace/features/create_loan/presentation/controller/currency_controller/currency_cubit.dart';
import 'package:Attendace/features/create_loan/presentation/controller/currency_controller/currency_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/media_query_values.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_bar/app_bar_custom.dart';
import '../../../../core/widgets/elevated_button/elevated_button_custom.dart';
import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import '../../../../core/widgets/snack_bar/snack_bar_widget.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../controller/create_loan_cubit.dart';
import '../controller/create_loan_state.dart';

class CreateLoanScreen extends StatefulWidget {
  const CreateLoanScreen({super.key});

  @override
  State<CreateLoanScreen> createState() => _CreateLoanScreenState();
}

class _CreateLoanScreenState extends State<CreateLoanScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBarCustom: const AppBarCustom(text: 'Apply Request'),
      body: BlocConsumer<CreateLoanCubit, CreateLoanState>(
        listener: (context, state) {
          if (state is CreateLoanSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                message: state.createLoanEntity.resultEntity.message.toString(),
                context: context));
            Navigator.pop(context);
          } else if (state is CreateLoanError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                message: state.message.toString(), context: context));
          }
        },
        builder: (context, state) {
          var cubit = CreateLoanCubit.get(context);
          return Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: SafeArea(
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextCustom(
                      text: 'Type',
                      fontSize: FontSize.s14,
                      color: ColorManager.textFormLabelColor,
                    ),
                    const SizedBox(
                      height: AppSize.s4,
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<CurrencyCubit>(context)
                        ..getCurrencyFun(),
                      child: BlocConsumer<CurrencyCubit, CurrencyState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return DropdownButtonHideUnderline(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorManager.textFormColor,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8)),
                              width: context.width / 1.1,
                              height: AppSize.s50,
                              child: state is GetCurrencySuccess
                                  ? InkWell(
                                      onTap: () {
                                        // CurrencyCubit.get(context).getCurrencyFun();
                                        showCupertinoModalPopup<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: AppSize.s100 * 3,
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                color: CupertinoColors.white,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: DefaultTextStyle(
                                                        style: const TextStyle(
                                                          color: CupertinoColors
                                                              .black,
                                                          fontSize: 22.0,
                                                        ),
                                                        child: GestureDetector(
                                                          // Blocks taps from propagating to the modal sheet and popping.
                                                          onTap: () {},
                                                          child: SafeArea(
                                                            top: false,
                                                            child:
                                                                CupertinoPicker(
                                                              scrollController:
                                                                  FixedExtentScrollController(
                                                                      initialItem:
                                                                          6),

                                                              magnification:
                                                                  1.5,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              itemExtent: 30,
                                                              //height of each item
                                                              looping: true,

                                                              children:
                                                                  List.generate(
                                                                      state
                                                                          .getCurrencyEntity
                                                                          .resultEntity
                                                                          .response
                                                                          .length,
                                                                      (index) =>
                                                                          Center(
                                                                            child: TextCustom(
                                                                                color: ColorManager.primary,
                                                                                fontSize: FontSize.s14,
                                                                                textAlign: TextAlign.center,
                                                                                text: state.getCurrencyEntity.resultEntity.response[index].name),
                                                                          )),

                                                              onSelectedItemChanged:
                                                                  (index) {
                                                                cubit.selectedValue = state
                                                                    .getCurrencyEntity
                                                                    .resultEntity
                                                                    .response[
                                                                        index]
                                                                    .id;
                                                                // cubit.checkType = state
                                                                //     .getCurrencyEntity
                                                                //     .resultEntity
                                                                //     .response[
                                                                //         index]
                                                                //     .name;
                                                                cubit.getCurrency(state
                                                                    .getCurrencyEntity
                                                                    .resultEntity
                                                                    .response[
                                                                        index]
                                                                    .name);
                                                                // setState(() {
                                                                //   selectItem=value.toString();
                                                                // });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButtonCustom(
                                                      fontSize: FontSize.s14,
                                                      text: 'Done',
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Center(
                                        child: TextCustom(
                                          fontSize: FontSize.s14,
                                          text: cubit.checkType.isNotEmpty
                                              ? cubit.checkType
                                              : 'Select Type',
                                          color: cubit.checkType.isNotEmpty
                                              ? ColorManager.secondary
                                              : ColorManager.textFormIconColor,
                                          overflow: TextOverflow.ellipsis,
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
                      text: 'Loan Amount',
                      color: ColorManager.textFormLabelColor,
                    ),
                    const SizedBox(
                      height: AppSize.s4,
                    ),
                    Platform.isAndroid
                        ? TextFormFieldCustom(
                            controller: cubit.loanAmountController,
                            keyboardType: TextInputType.number,
                            validate: (validate) {
                              if (validate!.isEmpty) {
                                return 'Please Enter the Loan Amount';
                              }
                              return null;
                            })
                        : Expanded(
                            child: SizedBox(
                              height: AppSize.s100,
                              child: CupertinoTextFormFieldRow(
                                controller: cubit.loanAmountController,
                                decoration: BoxDecoration(
                                  color: ColorManager.textFormColor,
                                  //floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  border: Border.all(
                                    color: ColorManager.textFormColor,
                                    width: AppSize.s1_5,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8),
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: ColorManager.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: FontSize.s14),
                                showCursor: true,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p16,
                                  horizontal: AppPadding.p16,
                                ),
                                validator: (validate) {
                                  if (validate!.isEmpty) {
                                    return 'Please Enter the reason';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                maxLines: null,
                              ),
                            ),
                          ),
                    const Spacer(),
                    state is CreateLoanLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              color: ColorManager.primary,
                              radius: AppSize.s16,
                            ),
                          )
                        : ElevatedButtonCustom(
                            text: 'Save',
                            fontWeight: FontWeight.w500,
                            fontSize: FontSize.s18,
                            onPressed: () async {
                              if (cubit.formKey.currentState!.validate() &&
                                  cubit.checkType.isNotEmpty) {
                                // ProfileCubit.get(context)..getEmployeesFun();

                                cubit.createLoanFun();
                                cubit.selectedValue = 0;
                                cubit.checkType = '';
                                cubit.loanAmountController.clear();
                              }
                            })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
