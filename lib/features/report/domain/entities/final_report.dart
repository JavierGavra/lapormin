import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/entities/evidence.dart';

class FinalReport extends Equatable {
  final String id;
  final String description;
  final DateTime createdAt;
  final List<Evidence> evidences;

  const FinalReport({
    required this.id,
    required this.description,
    required this.createdAt,
    required this.evidences,
  });

  @override
  List<Object?> get props => [id, description, createdAt, evidences];
}
