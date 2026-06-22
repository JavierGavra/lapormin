import 'package:flutter/material.dart';

import '../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../../core/widgets/avatar/profile_avatar.dart';

class FieldOfficerBottomSheetHeader extends StatelessWidget {
  final String? photoProfile;
  final String username;

  const FieldOfficerBottomSheetHeader({
    super.key,
    this.photoProfile,
    required this.username,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        ProfileAvatar.medium(photoProfile: photoProfile, username: username),
        Text(
          username,
          textAlign: TextAlign.center,
          style: AppTextStyle.s20(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
