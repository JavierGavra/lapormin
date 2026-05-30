import 'package:flutter/material.dart';
import 'package:lapormin/features/report/presentation/widgets/picker/evidences_picker/evidences_picker.dart';
import 'create_report_step_header.dart';

class EvidencesStep extends StatefulWidget {
  final List<String> initialEvidences;
  final ValueChanged<List<String>> onEvidencesChanged;

  const EvidencesStep({
    super.key,
    required this.onEvidencesChanged,
    required this.initialEvidences,
  });

  @override
  State<EvidencesStep> createState() => _EvidencesStepState();
}

class _EvidencesStepState extends State<EvidencesStep>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          const CreateReportStepHeader(
            title: "Tambahkan bukti\n(Foto/Video)",
            description: "Buktikan bahwa laporanmu valid.",
          ),
          EvidencesPicker(
            initialEvidences: widget.initialEvidences,
            onEvidencesChanged: widget.onEvidencesChanged,
          ),
          const SizedBox(height: 0),
        ],
      ),
    );
  }
}
