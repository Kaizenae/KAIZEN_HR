import '../../../../core/utils/values_manager.dart';

import 'package:flutter/material.dart';

import '../../../../core/widgets/scaffold_custom/scaffold_custom.dart';
import 'profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldCustom(
      body: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: ProfileCard(),
      ),
    );
  }
}
