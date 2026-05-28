part of 'my_reports_bloc.dart';

enum MyReportsStatus { initial, loading, success, failure }

final class MyReportsState extends Equatable {
  final MyReportsStatus status;
  final List<ReportSummary> reports;
  final String? errorMessage;

  const MyReportsState({
    this.status = MyReportsStatus.initial,
    this.reports = const [],
    this.errorMessage,
  });

  MyReportsState copyWith({
    MyReportsStatus? status,
    List<ReportSummary>? reports,
    String? errorMessage,
  }) {
    return MyReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage];
}
