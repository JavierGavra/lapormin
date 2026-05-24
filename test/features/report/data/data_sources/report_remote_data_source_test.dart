import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/features/report/data/data_sources/report_remote_data_source.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/submit_report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});

  await Supabase.initialize(
    url: 'https://rhmpnzgwnlywwayhsdcp.supabase.co',
    anonKey: 'sb_publishable_9jIV3Vn9baV_elqXXwrhFQ_zDseYMFk',
  );

  final supabase = Supabase.instance.client;
  final remoteDataSource = ReportRemoteDataSourceImpl(supabase: supabase);

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

  // await remoteDataSource.insertReport(
  //   SubmitReportParams(
  //     title: "Test Report",
  //     description: "This is a test report.",
  //     latitude: -6.984643,
  //     longitude: 110.403724,
  //     address: "Jl. Raya Semarang - Demak, Semarang, Jawa Tengah",
  //     category: ReportCategory.infrastructure,
  //     evidences: [],
  //   ),
  // );

  // try {
  //   final reports = await remoteDataSource.fetchPublicReports(
  //     ReportFilterParams(category: null, status: null, keyword: null),
  //   );

  //   for (var report in reports) {
  //     print("ID: ${report.id}");
  //     print("Title: ${report.title}");
  //     print("Address: ${report.shortAdddress}");
  //     print("Category: ${report.category}");
  //     print("Status: ${report.status}");
  //     print("Created At: ${report.createdAt}");
  //     print("Due Action: ${report.dueAction}");
  //     print("-----------------------------");
  //   }
  // } catch (e) {
  //   print(e);
  // }

  try {
    final reports = await remoteDataSource.fetchFieldOfficerReports(
      ReportFilterParams(category: null, status: null, keyword: null),
    );

    for (var report in reports) {
      print("ID: ${report.id}");
      print("Title: ${report.title}");
      print("Address: ${report.shortAdddress}");
      print("Category: ${report.category}");
      print("Status: ${report.status}");
      print("Created At: ${report.createdAt}");
      print("Due Action: ${report.dueAction}");
      print("-----------------------------");
    }
  } catch (e) {
    print(e);
  }
}
