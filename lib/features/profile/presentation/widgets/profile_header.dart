import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/route/navigate.dart';
import '../../../../core/utils/text_style/app_text_style.dart';
import '../../../../core/widgets/avatar/profile_avatar.dart';
import '../../../../core/widgets/image/image_viewer_page.dart';
import '../bloc/profile/profile_bloc.dart';

class ProfileHeader extends StatefulWidget {
  final String? photoProfile;
  final String username;

  const ProfileHeader({super.key, this.photoProfile, required this.username});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();

    // Pilih Gambar dari Galeri
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && context.mounted) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Potong Foto',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'Potong Foto',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      // Jika pengguna menekan butang 'Selesai' pada skrin crop
      if (croppedFile != null) {
        final file = File(croppedFile.path);
        final extension = croppedFile.path.split('.').last;

        if (context.mounted) {
          context.read<ProfileBloc>().add(
            ProfilePhotoUpdateRequested(imageFile: file, extension: extension),
          );
          Navigate.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final isLoading = state.status == ProfileStatus.avatarLoading;

            return GestureDetector(
              onTap: () {
                Navigate.push(
                  context,
                  ImageViewerPage.network(
                    tag: 'profile_avatar',
                    title: "Foto Profil",
                    withDownload: true,
                    onEdit: () => _pickImage(context),
                    urlImage: widget.photoProfile,
                  ),
                );
              },
              child: Hero(
                tag: 'profile_avatar',
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ProfileAvatar.large(
                      photoProfile: widget.photoProfile,
                      username: widget.username,
                    ),

                    if (isLoading)
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        Text(
          widget.username,
          style: AppTextStyle.s20(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
