import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapormin/core/constants/constant.dart';
import 'package:lapormin/core/utils/validator/input_validator.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/features/report/presentation/widgets/picker/evidences_picker/evidences_media_bottom_sheet.dart';
import 'package:lapormin/features/report/presentation/widgets/picker/evidences_picker/evidences_preview.dart';
import 'package:lapormin/features/report/presentation/widgets/picker/evidences_picker/evidences_upload_button.dart';

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

      final String filePath = file.path;
      final error = InputValidator.evidenceValidate(
        filePath: filePath,
        currentTotalBytes: _totalBytes,
      );

      if (error != null) {
        showSnackBar(context, error, type: SnackBarType.failure);
        return;
      }

      setState(() => _evidences.add(filePath));
      widget.onEvidencesChanged(_evidences);
    } catch (_) {
      if (!mounted) return;
      showSnackBar(
        context,
        'Gagal membuka kamera.',
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
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
      ],
    );
  }
}
