import 'package:get_it/get_it.dart';
import 'package:lapormin/features/field_officer/domain/use_cases/add_field_officer.dart';
import 'package:lapormin/features/field_officer/presentation/bloc/add_field_officer/add_field_officer_bloc.dart';
import 'package:lapormin/features/report/domain/use_cases/assign_field_officer.dart';
import 'package:lapormin/features/report/domain/use_cases/completing_report.dart';
import 'package:lapormin/features/report/domain/use_cases/provide_action.dart';
import 'package:lapormin/features/report/domain/use_cases/reject_report.dart';
import 'package:lapormin/features/report/domain/use_cases/verify_report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/use_cases/login.dart';
import 'features/auth/domain/use_cases/logout.dart';
import 'features/auth/domain/use_cases/send_otp.dart';
import 'features/auth/domain/use_cases/verify_otp.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';
import 'features/auth/presentation/bloc/register/register_bloc.dart';
import 'features/location/data/data_sources/location_local_data_source.dart';
import 'features/location/data/data_sources/location_remote_data_source.dart';
import 'features/location/data/repositories/location_repository_impl.dart';
import 'features/location/domain/repositories/location_repository.dart';
import 'features/location/domain/use_cases/get_address_from_coordinate.dart';
import 'features/location/domain/use_cases/get_current_location.dart';
import 'features/location/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'features/profile/data/data_sources/profile_local_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/use_cases/get_profile.dart';
import 'features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'features/report/data/data_sources/report_remote_data_source.dart';
import 'features/report/data/repositories/report_repository_impl.dart';
import 'features/report/domain/repositories/report_repository.dart';
import 'features/report/domain/use_cases/get_admin_reports.dart';
import 'features/report/domain/use_cases/get_field_officer_reports.dart';
import 'features/report/domain/use_cases/get_public_reports.dart';
import 'features/report/domain/use_cases/get_report.dart';
import 'features/report/domain/use_cases/get_report_aggregate.dart';
import 'features/report/domain/use_cases/get_user_reports.dart';
import 'features/report/domain/use_cases/submit_report.dart';
import 'features/report/presentation/bloc/admin_reports/admin_reports_bloc.dart';
import 'features/report/presentation/bloc/create_report/create_report_bloc.dart';
import 'features/report/presentation/bloc/field_officer_reports/field_officer_reports_bloc.dart';
import 'features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'features/report/presentation/bloc/my_reports/my_reports_bloc.dart';
import 'features/report/presentation/bloc/public_report_detail/public_report_detail_bloc.dart';
import 'features/report/presentation/bloc/public_reports/public_reports_bloc.dart';
import 'features/map/data/data_sources/map_remote_data_source.dart';
import 'features/map/data/repositories/map_repository_impl.dart';
import 'features/map/domain/repositories/map_repository.dart';
import 'features/map/domain/use_cases/get_nearby_active_reports.dart';
import 'features/map/presentation/bloc/map_bloc.dart';
import 'features/home/presentation/bloc/home_admin/home_admin_bloc.dart';
import 'features/field_officer/data/data_sources/field_officer_remote_data_source.dart';
import 'features/field_officer/data/repositories/field_officer_repository_impl.dart';
import 'features/field_officer/domain/repositories/field_officer_repository.dart';
import 'features/field_officer/domain/use_cases/get_field_officers.dart';
import 'features/field_officer/presentation/bloc/field_officer/field_officer_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeServiceLocator() async {
  // Feature
  _initAuthFeature();
  _initLocationFeature();
  _initReportFeature();
  _initProfileFeature();
  _initMapFeature();
  _initHomeAdminFeature();
  _initFieldOfficerFeature();
  // External
  // final database = await DatabaseHelper.instance.database;
  final sharedPreferences = await SharedPreferences.getInstance();
  final supabase = Supabase.instance.client;

  // sl.registerSingleton(database);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => supabase);
}

void _initAuthFeature() {
  sl.registerFactory(() => AuthBloc(supabase: sl()));
  sl.registerFactory(() => LoginBloc(login: sl()));
  sl.registerFactory(() => RegisterBloc(sendOtp: sl(), verifyOtp: sl()));

  // Use Cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabase: sl()),
  );
}

void _initLocationFeature() {
  sl.registerFactory(
    () => LocationPickerBloc(
      getCurrentLocation: sl(),
      getAddressFromCoordinate: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCurrentLocation(sl()));
  sl.registerLazySingleton(() => GetAddressFromCoordinate(sl()));

  // Repository
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(),
  );
}

void _initReportFeature() {
  sl.registerFactory(() => CreateReportBloc(submitReport: sl()));
  sl.registerFactory(() => PublicReportDetailBloc(getReport: sl()));
  sl.registerFactory(() => PublicReportsBloc(getPublicReports: sl()));
  sl.registerFactory(() => MyReportsBloc(getUserReports: sl()));
  sl.registerFactory(() => AdminReportsBloc(getAdminReports: sl()));
  sl.registerFactory(
    () => FieldOfficerReportsBloc(getFieldOfficerReports: sl()),
  );
  sl.registerFactory(
    () => InternalReportDetailBloc(
      getReportAggregate: sl(),
      assignFieldOfficer: sl(),
      verifyReport: sl(),
      rejectReport: sl(),
      provideAction: sl(),
      completingReport: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetReport(sl()));
  sl.registerLazySingleton(() => GetReportAggregate(sl()));
  sl.registerLazySingleton(() => SubmitReport(sl()));
  sl.registerLazySingleton(() => GetPublicReports(sl()));
  sl.registerLazySingleton(() => GetUserReports(sl()));
  sl.registerLazySingleton(() => GetAdminReports(sl()));
  sl.registerLazySingleton(() => GetFieldOfficerReports(sl()));
  sl.registerLazySingleton(() => AssignFieldOfficer(sl()));
  sl.registerLazySingleton(() => VerifyReport(sl()));
  sl.registerLazySingleton(() => RejectReport(sl()));
  sl.registerLazySingleton(() => ProvideAction(sl()));
  sl.registerLazySingleton(() => CompletingReport(sl()));

  // Repository
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(supabase: sl()),
  );
}

void _initProfileFeature() {
  sl.registerFactory(() => ProfileBloc(getProfile: sl(), logout: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProfile(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(prefs: sl()),
  );
}

void _initMapFeature() {
  // BLoC
  sl.registerFactory(() => MapBloc(getNearbyActiveReports: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetNearbyActiveReports(sl()));

  // Repository
  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(supabase: sl()),
  );
}

void _initHomeAdminFeature() {
  // BLoC
  sl.registerFactory(() => HomeAdminBloc(getAdminReports: sl()));
}

void _initFieldOfficerFeature() {
  // BLoC
  sl.registerFactory(() => FieldOfficerBloc(getFieldOfficers: sl()));
  sl.registerFactory(() => AddFieldOfficerBloc(addFieldOfficerUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetFieldOfficers(sl()));
  sl.registerLazySingleton(() => AddFieldOfficer(sl()));

  // Repository
  sl.registerLazySingleton<FieldOfficerRepository>(
    () => FieldOfficerRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<FieldOfficerRemoteDataSource>(
    () => FieldOfficerRemoteDataSourceImpl(supabase: sl()),
  );
}
