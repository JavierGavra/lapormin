import 'package:equatable/equatable.dart';

import '../../../../core/constants/report_status_enum.dart';

class Report extends Equatable {
  final String id;
  final String ticket;
  final String title;
  final String category;
  final String adddress;
  final String description;
  final double latitude;
  final double longitude;
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
    required this.latitude,
    required this.longitude,
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
    latitude,
    longitude,
    dueDate,
    createdAt,
    status,
    evidences,
  ];
}
