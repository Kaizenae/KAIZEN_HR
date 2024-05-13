import 'package:Attendace/core/utils/color_manager.dart';
import 'package:Attendace/core/utils/strings_manager.dart';
import 'package:Attendace/core/utils/values_manager.dart';
import 'package:Attendace/core/widgets/app_bar/app_bar_custom.dart';
import 'package:Attendace/core/widgets/scaffold_custom/scaffold_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/assets_manager.dart';

class HelpAndFeedbackScreen extends StatelessWidget {
  HelpAndFeedbackScreen({super.key});

  final List<String> icons = [
    IconsAssets.facebookIcon,
    IconsAssets.whatsappIcon,
    IconsAssets.instagramIcon,
    IconsAssets.twitterIcon,
    IconsAssets.youtubeIcon,
    IconsAssets.linkedinIcon,
  ];
  final List<String> links = [
    AppStrings.facebook,
    AppStrings.whatsapp,
    AppStrings.instagram,
    AppStrings.twitter,
    AppStrings.youtube,
    AppStrings.linkedin,
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
        appBarCustom: const AppBarCustom(
          text: AppStrings.helpsFeedback,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: 3 / 1,
                      child: Image.asset(
                        ImageAssets.logoImg,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s30,
                  ),
                  Text(
                    "PO Box: 130652, Office 262, 2nd Floor WAFRA Square Building, Reem Island, Abu Dhabi, UAE.",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await launchInBrowser(Uri.parse("tel:+971 2 3051500"));
                    },
                    child: Text(
                      "Contact number : +971 2 3051500 ",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: ColorManager.darkGrey,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await launchInBrowser(
                          Uri.parse("mailto:hr.helpdesk@ideacrate.net"));
                    },
                    child: Text(
                      "Email : hr.helpdesk@ideacrate.net",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  InkWell(
                      onTap: () async {
                        await launchInBrowser(Uri.parse(
                            "https://www.linkedin.com/company/ideacrateuae/mycompany/"));
                      },
                      child: SvgPicture.asset(
                        IconsAssets.linkedinIcon,
                        height: AppSize.s40 * 1.3,
                      )),
                ],
              ),
            ),
          ),
        ));
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
