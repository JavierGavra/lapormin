import 'package:equatable/equatable.dart';
import '../../../domain/entities/field_officer.dart';

enum FieldOfficerStatus { initial, loading, success, failure }

class FieldOfficerState extends Equatable {
  final FieldOfficerStatus status;
  final List<FieldOfficer> officers;
  final String? errorMessage;

  const FieldOfficerState({
    this.status = FieldOfficerStatus.initial,
    this.officers = const [],
    this.errorMessage,
  });

  bool get isInitial => status == FieldOfficerStatus.initial;
  bool get isLoading => status == FieldOfficerStatus.loading;
  bool get isSuccess => status == FieldOfficerStatus.success;
  bool get isFailure => status == FieldOfficerStatus.failure;

  FieldOfficerState copyWith({
    FieldOfficerStatus? status,
    List<FieldOfficer>? officers,
    String? errorMessage,
  }) {
    return FieldOfficerState(
      status: status ?? this.status,
      officers: officers ?? this.officers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, officers, errorMessage];
}
