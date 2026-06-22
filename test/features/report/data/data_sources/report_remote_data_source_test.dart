import 'package:lapormin/core/constants/report_status_enum.dart';
// import 'package:lapormin/features/report/data/data_sources/report_remote_data_source.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});

  await Supabase.initialize(
    url: 'https://rhmpnzgwnlywwayhsdcp.supabase.co',
    anonKey: 'sb_publishable_9jIV3Vn9baV_elqXXwrhFQ_zDseYMFk',
  );

  final supabase = Supabase.instance.client;
  // final remoteDataSource = ReportRemoteDataSourceImpl(supabase: supabase);

  await supabase.auth.signInWithPassword(
    phone: "+6285800000001",
    password: "adminlapormin",
  );
  // await supabase.auth.signInWithPassword(
  //   phone: "+6285800000002",
  //   password: "rusdi123",
  // );

  // b9364f1f-4109-4801-8417-6433b148d176
  // print(supabase.auth.currentUser!.id);
  // print(supabase.auth.currentUser!.role);

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

  // final response = await supabase
  //     .from('report')
  //     .select('''
  //             *,
  //             report_status_logs: report_status_log (
  //               id, user_id, status, created_at
  //             ),
  //             field_check (
  //               *,
  //               ...users(
  //                 field_officer_name: username,
  //                 field_officer_phone: no_telp
  //               )
  //             ),
  //             final_report (*)
  //           ''')
  //     .eq('id', "c93bd9b1-508a-4d90-89c8-3d986f215bad")
  //     .single();

  var response = await supabase
      .from('report')
      .update({'status': ReportStatus.verified.dbValue})
      .eq('id', "61545c2e-762d-4d26-8d44-d8dc36ee2f40")
      .select();

  debugPrint("$response");
}
