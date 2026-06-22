import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';

class ReportFilterParams {
  final String? keyword;
  final List<ReportCategory> categories;
  final List<ReportStatus> statuses;

  const ReportFilterParams({
    this.keyword,
    this.categories = const [],
    this.statuses = const [],
  });
}
