import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/text_style/app_text_style.dart';

enum AvatarSize { verySmall, small, medium, large }

class ProfileAvatar extends StatelessWidget {
  final String? photoProfile;
  final String username;
  final AvatarSize size;

  const ProfileAvatar({
    super.key,
    required this.size,
    this.photoProfile,
    required this.username,
  });

  const ProfileAvatar.large({
    super.key,
    this.photoProfile,
    required this.username,
  }) : size = AvatarSize.large;

  const ProfileAvatar.medium({
    super.key,
    this.photoProfile,
    required this.username,
  }) : size = AvatarSize.medium;

  const ProfileAvatar.small({
    super.key,
    this.photoProfile,
    required this.username,
  }) : size = AvatarSize.small;

  const ProfileAvatar.verySmall({
    super.key,
    this.photoProfile,
    required this.username,
  }) : size = AvatarSize.verySmall;

  String get _initials {
    final words = username.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return words[0][0].toUpperCase();
  }

  ImageProvider _buildImage(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return switch (size) {
      AvatarSize.large => _buildLargeAvatar(color),
      AvatarSize.medium => _buildMediumAvatar(color),
      AvatarSize.small => _buildSmallAvatar(color),
      AvatarSize.verySmall => _buildVerySmallAvatar(color),
    };
  }

  Widget _buildLargeAvatar(ColorScheme color) {
    return Container(
      width: 120,
      height: 120,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.primary, width: 3),
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: color.primary,
        backgroundImage: photoProfile != null
            ? _buildImage(photoProfile!)
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
    );
  }

  Widget _buildMediumAvatar(ColorScheme color) {
    return Container(
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
            ? _buildImage(photoProfile!)
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
    );
  }

  Widget _buildSmallAvatar(ColorScheme color) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.primary,
      backgroundImage: photoProfile != null ? _buildImage(photoProfile!) : null,
      child: photoProfile == null
          ? Text(
              _initials,
              textAlign: TextAlign.center,
              style: AppTextStyle.s16(
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            )
          : null,
    );
  }

  Widget _buildVerySmallAvatar(ColorScheme color) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: color.primary,
      backgroundImage: photoProfile != null ? _buildImage(photoProfile!) : null,
      child: photoProfile == null
          ? Text(
              _initials,
              textAlign: TextAlign.center,
              style: AppTextStyle.s14(
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            )
          : null,
    );
  }
}
