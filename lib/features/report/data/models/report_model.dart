import 'package:lapormin/core/constants/report_category_enum.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.ticket,
    required super.title,
    required super.category,
    required super.adddress,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.dueDate,
    required super.createdAt,
    required super.status,
    required super.evidences,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as String,
      ticket: map['ticket_number'] as String,
      title: map['title'] as String,
      category: ReportCategory.fromString(map['category'] as String),
      adddress: map['address'] as String,
      description: map['description'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      dueDate: map['due_action'] != null
          ? DateTime.parse(map['due_action'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      status: ReportStatus.fromString(map['status'] as String),
      evidences: [
        "assets/images/cards/banjir.png",
        "assets/images/cards/infrastruktur.png",
        "assets/images/cards/jlnberlubang.png",
        "assets/images/cards/kriminal.png",
      ],
    );
  }
}
