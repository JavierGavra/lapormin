import 'package:equatable/equatable.dart';

class FinalReport extends Equatable {
  final String id;
  final String description;
  final DateTime createdAt;
  final List<String> evidences;

  const FinalReport({
    required this.id,
    required this.description,
    required this.createdAt,
    required this.evidences,
  });

  @override
  List<Object?> get props => [id, description, createdAt, evidences];
}
