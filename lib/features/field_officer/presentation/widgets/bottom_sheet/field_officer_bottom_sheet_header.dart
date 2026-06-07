import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class FieldOfficerBottomSheetHeader extends StatelessWidget {
  final String? photoProfile;
  final String username;

  const FieldOfficerBottomSheetHeader({
    super.key,
    this.photoProfile,
    required this.username,
  });

  String get _initials {
    final words = username.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return words[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      spacing: 12,
      children: [
        Container(
          width: 96,
          height: 96,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.primary, width: 3),
          ),
          child: CircleAvatar(
            radius: 42,
            backgroundColor: color.primary,
            backgroundImage: photoProfile != null
                ? NetworkImage(photoProfile!)
                : null,
            child: photoProfile == null
                ? Text(
                    _initials,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.s24(
                      fontWeight: FontWeight.w600,
                      color: color.onPrimary,
                    ),
                  )
                : null,
          ),
        ),
        Text(
          username,
          textAlign: TextAlign.center,
          style: AppTextStyle.s20(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
