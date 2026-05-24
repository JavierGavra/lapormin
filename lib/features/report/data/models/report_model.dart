import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/features/report/domain/entities/report.dart';
import 'package:latlong2/latlong.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.ticket,
    required super.title,
    required super.category,
    required super.adddress,
    required super.description,
    required super.position,
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
      category: map['category'] as String,
      adddress: map['adddress'] as String,
      description: map['description'] as String,
      position: LatLng(map['latitude'] as double, map['longitude'] as double),
      dueDate: DateTime.parse(map['due_action'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      status: ReportStatus.values.byName(map['status'] as String),
      evidences: [],
    );
  }
}
