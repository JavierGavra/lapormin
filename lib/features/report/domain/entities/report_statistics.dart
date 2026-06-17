import 'package:equatable/equatable.dart';

class ReportStatistics extends Equatable {
  final int pending;
  final int processing;
  final int done;
  final int total;

  final int infrastructure;
  final int disaster;
  final int crime;
  final int publicService;

  const ReportStatistics({
    required this.pending,
    required this.processing,
    required this.done,
    required this.total,
    required this.infrastructure,
    required this.disaster,
    required this.crime,
    required this.publicService,
  });

  @override
  List<Object?> get props => [
    pending,
    processing,
    done,
    total,
    infrastructure,
    disaster,
    crime,
    publicService,
  ];
}
