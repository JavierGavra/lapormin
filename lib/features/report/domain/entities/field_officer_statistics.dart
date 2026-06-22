import 'package:equatable/equatable.dart';

class FieldOfficerStatistics extends Equatable {
  final int inspeksi;
  final int tindakan;
  final int penugasan; // Total dari inspeksi + tindakan

  const FieldOfficerStatistics({
    required this.inspeksi,
    required this.tindakan,
    required this.penugasan,
  });

  @override
  List<Object?> get props => [inspeksi, tindakan, penugasan];
}
