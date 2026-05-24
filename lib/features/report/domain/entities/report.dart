import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:latlong2/latlong.dart';

class Report extends Equatable {
  final String id;
  final String ticket;
  final String title;
  final String category;
  final String adddress;
  final String description;
  final LatLng position;
  final DateTime dueDate;
  final DateTime createdAt;
  final ReportStatus status;
  final List<String> evidences;

  const Report({
    required this.id,
    required this.ticket,
    required this.title,
    required this.category,
    required this.adddress,
    required this.description,
    required this.position,
    required this.dueDate,
    required this.createdAt,
    required this.status,
    required this.evidences,
  });

  @override
  List<Object?> get props => [
    id,
    ticket,
    title,
    category,
    adddress,
    description,
    position,
    dueDate,
    createdAt,
    status,
    evidences,
  ];
}
