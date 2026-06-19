import 'report_command_remote_data_source.dart';
import 'report_evidence_remote_data_source.dart';
import 'report_query_remote_data_source.dart';
import 'report_statistic_remote_data_source.dart';

class ReportRemoteDataSourceFacade {
  final ReportQueryRemoteDataSource query;
  final ReportCommandRemoteDataSource command;
  final ReportEvidenceRemoteDataSource evidence;
  final ReportStatisticRemoteDataSource statistic;

  const ReportRemoteDataSourceFacade({
    required this.query,
    required this.command,
    required this.evidence,
    required this.statistic,
  });
}
