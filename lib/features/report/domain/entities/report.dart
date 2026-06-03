import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';

import '../../../../core/constants/report_status_enum.dart';

class Report extends Equatable {
  final String id;
  final String ticket;
  final String title;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime? dueDate;
  final DateTime createdAt;
  final ReportStatus status;
  final ReportCategory category;
  final List<String> evidences;

  const Report({
    required this.id,
    required this.ticket,
    required this.title,
    required this.category,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.dueDate,
    required this.createdAt,
    required this.status,
    required this.evidences,
  });

  Report copyWith({
    String? id,
    String? ticket,
    String? title,
    String? address,
    String? description,
    double? latitude,
    double? longitude,
    DateTime? dueDate,
    DateTime? createdAt,
    ReportStatus? status,
    ReportCategory? category,
    List<String>? evidences,
  }) {
    return Report(
      id: id ?? this.id,
      ticket: ticket ?? this.ticket,
      title: title ?? this.title,
      address: address ?? this.address,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      category: category ?? this.category,
      evidences: evidences ?? this.evidences,
    );
  }

  @override
  List<Object?> get props => [
    id,
    ticket,
    title,
    category,
    address,
    description,
    latitude,
    longitude,
    dueDate,
    createdAt,
    status,
    evidences,
  ];
}
