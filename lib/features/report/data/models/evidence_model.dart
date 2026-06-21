import 'package:lapormin/features/report/domain/entities/evidence.dart';

class EvidenceModel extends Evidence {
  const EvidenceModel({required super.url, super.thumbnailUrl});

  factory EvidenceModel.fromMap(Map<String, dynamic> map) {
    return EvidenceModel(
      url: map['media'] as String,
      thumbnailUrl: map['thumbnail'] as String?,
    );
  }
}
