import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/constants/constant.dart';
import '../../../../../../core/utils/image/image_compressor_utils.dart';
import '../../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../../../core/utils/validator/input_validator.dart';
import '../../../../../../core/utils/video/video_compressor_utils.dart';
import '../../../../../../core/widgets/snackbar/custom_snackbar.dart';
import 'evidences_media_bottom_sheet.dart';
import 'evidences_preview.dart';
import 'evidences_upload_button.dart';

class EvidencesPicker extends StatefulWidget {
  final List<String> initialEvidences;
  final ValueChanged<List<String>> onEvidencesChanged;
  final bool _isFieldOfficer;

  const EvidencesPicker({
    super.key,
    required this.onEvidencesChanged,
    required this.initialEvidences,
  }) : _isFieldOfficer = false;

  const EvidencesPicker.fieldOfficer({
    super.key,
    required this.onEvidencesChanged,
    required this.initialEvidences,
  }) : _isFieldOfficer = true;

  @override
  State<EvidencesPicker> createState() => _EvidencesPickerState();
}

class _EvidencesPickerState extends State<EvidencesPicker> {
  final ImagePicker _picker = ImagePicker();
  late final List<String> _evidences;

  // Tambahan state untuk indikator proses kompresi
  bool _isCompressing = false;

  int get _totalBytes {
    return _evidences.fold(
      0,
      (sum, filePath) => sum + File(filePath).lengthSync(),
    );
  }

  bool get _isMaxFilesReached {
    return (_evidences.length >= Constant.evidencesMaxFiles);
  }

  bool get _isMaxSizeReached {
    return (_totalBytes >= Constant.evidencesMaxBytes);
  }

  bool get _canUpload {
    return (!_isMaxFilesReached && !_isMaxSizeReached);
  }

  Future<void> _pickFromCamera({required bool isVideo}) async {
    try {
      final XFile? file = isVideo
          ? await _picker.pickVideo(source: ImageSource.camera)
          : await _picker.pickImage(source: ImageSource.camera);

      if (file == null || !mounted) return;

      setState(() => _isCompressing = true);

      String filePath = file.path;
      final originalFile = File(filePath);

      if (!isVideo) {
        final compressedFile = await ImageCompressorUtils.compressImage(
          originalFile,
        );
        if (compressedFile != null) filePath = compressedFile.path;
      } else {
        final compressedFile = await VideoCompressorUtils.compressVideo(
          originalFile,
        );
        if (compressedFile != null) filePath = compressedFile.path;
      }

      final error = InputValidator.evidenceValidate(
        filePath: filePath,
        currentTotalBytes: _totalBytes,
      );

      if (error != null && mounted) {
        setState(() => _isCompressing = false);
        showSnackBar(context, error, type: SnackBarType.failure);
        return;
      }

      setState(() {
        _evidences.add(filePath);
        _isCompressing = false;
      });

      widget.onEvidencesChanged(_evidences);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCompressing = false);
      debugPrint('❌ Gagal membuka kamera atau memproses media: $e');
      showSnackBar(
        context,
        'Gagal membuka kamera atau memproses media.',
        type: SnackBarType.failure,
      );
    }
  }

  void _removeEvidence(int index) {
    setState(() => _evidences.removeAt(index));
    widget.onEvidencesChanged(_evidences);
  }

  void _showMediaBottomSheet() {
    EvidencesMediaBottomSheet.show(
      context,
      onPickPhoto: () => _pickFromCamera(isVideo: false),
      onPickVideo: () => _pickFromCamera(isVideo: true),
    );
  }

  @override
  void initState() {
    super.initState();
    _evidences = [];
    _evidences.addAll(widget.initialEvidences);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: widget._isFieldOfficer ? 12 : 24,
      children: [
        (widget._isFieldOfficer)
            ? EvidencesUploadButton.fieldOfficer(
                isDisabled: !_canUpload,
                onTap: _showMediaBottomSheet,
              )
            : EvidencesUploadButton(
                isDisabled: !_canUpload,
                onTap: _showMediaBottomSheet,
              ),

        EvidencesPreview(
          evidences: _evidences,
          isMaxSizeReached: _isMaxSizeReached,
          onRemove: _removeEvidence,
        ),

        if (_isCompressing)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Memproses media...',
                  style: AppTextStyle.s12(
                    color: color.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(color.primary),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
