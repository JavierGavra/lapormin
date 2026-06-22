import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/entities/evidence.dart';

class FieldCheck extends Equatable {
  final String id;
  final String fieldOfficerName;
  final String fieldOfficerPhone;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Evidence> evidences;

  const FieldCheck({
    required this.id,
    required this.fieldOfficerName,
    required this.fieldOfficerPhone,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.evidences,
  });

  @override
  List<Object?> get props => [
    id,
    fieldOfficerName,
    fieldOfficerPhone,
    description,
    createdAt,
    updatedAt,
    evidences,
  ];
}
