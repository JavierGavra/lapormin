// import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/data/data_sources/report_remote_data_source.dart';
import 'package:lapormin/features/report/data/repositories/report_repository_impl.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_admin_reports.dart';
// import 'package:lapormin/features/report/domain/use_cases/get_public_reports.dart';
// import 'package:lapormin/features/report/domain/use_cases/get_user_reports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});

  await Supabase.initialize(
    url: 'https://rhmpnzgwnlywwayhsdcp.supabase.co',
    anonKey: 'sb_publishable_9jIV3Vn9baV_elqXXwrhFQ_zDseYMFk',
  );

  final supabase = Supabase.instance.client;
  final repository = ReportRepositoryImpl(
    remoteDataSource: ReportRemoteDataSourceImpl(supabase: supabase),
  );
  // final getUserReportsResult = GetUserReports(repository);
  final getAdminReportsResult = GetAdminReports(repository);
  // final getPublicReportsResult = GetPublicReports(repository);

  await supabase.auth.signInWithPassword(
    phone: "+6285866478673",
    password: "masyarakat123",
  );
  // await supabase.auth.signInWithPassword(
  //   phone: "+6285800000002",
  //   password: "rusdi123",
  // );

  // b9364f1f-4109-4801-8417-6433b148d176
  print(supabase.auth.currentUser!.id);
  print(supabase.auth.currentUser!.role);

  final adminReports = await getAdminReportsResult(
    ReportFilterParams(category: null, status: null, keyword: null),
  );
  adminReports.fold(
    (failure) => print("Error fetching admin reports: $failure"),
    (reports) {
      print("Admin Reports:");
      for (var report in reports) {
        print("- ${report.title} (${report.status})");
      }
    },
  );
}
