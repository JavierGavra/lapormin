import 'package:equatable/equatable.dart';

import '../../../../core/constants/report_category_enum.dart';
import '../../../../core/constants/report_status_enum.dart';

class ReportFilterParams extends Equatable {
  final ReportCategory? category;
  final ReportStatus? status;
  final String? keyword;

  const ReportFilterParams({this.category, this.status, this.keyword});

  @override
  List<Object?> get props => [category, status, keyword];
}
