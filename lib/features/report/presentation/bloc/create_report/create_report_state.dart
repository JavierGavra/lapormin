part of 'create_report_bloc.dart';

enum CreateReportStatus { initial, loading, next, previous, success, failure }

final class CreateReportState extends Equatable {
  final CreateReportStatus status;
  final int currentStep;
  final String? title;
  final ReportCategory? category;
  final LatLng? position;
  final String? address;
  final String? description;
  final String? errorMessage;
  final List<String> evidences;

  const CreateReportState({
    this.status = CreateReportStatus.initial,
    this.currentStep = 1,
    this.title,
    this.category,
    this.position,
    this.address,
    this.description,
    this.errorMessage,
    this.evidences = const [],
  });

  bool get isLoading => status == CreateReportStatus.loading;

  CreateReportState copyWith({
    CreateReportStatus? status,
    int? currentStep,
    String? title,
    ReportCategory? category,
    LatLng? position,
    String? address,
    String? description,
    List<String>? evidences,
    String? errorMessage,
  }) {
    return CreateReportState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      title: title ?? this.title,
      category: category ?? this.category,
      position: position ?? this.position,
      address: address ?? this.address,
      description: description ?? this.description,
      evidences: evidences ?? this.evidences,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentStep,
    title,
    category,
    position,
    address,
    description,
    evidences,
    errorMessage,
  ];
}
