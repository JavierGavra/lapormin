import 'package:equatable/equatable.dart';

class FieldCheck extends Equatable {
  final String id;
  final String fieldOfficerName;
  final String fieldOfficerPhone;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<String> evidences;

  const FieldCheck({
    required this.id,
    required this.fieldOfficerName,
    required this.fieldOfficerPhone,
    required this.description,
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
