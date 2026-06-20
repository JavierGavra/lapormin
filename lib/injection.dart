import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lapormin/features/notification/domain/use_cases/mark_all_as_read.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/database/local_data_persistance.dart';
import 'core/services/push_notification/push_notification_service.dart';
import 'core/utils/network/network_info.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/use_cases/get_current_user.dart';
import 'features/auth/domain/use_cases/login.dart';
import 'features/auth/domain/use_cases/logout.dart';
import 'features/auth/domain/use_cases/send_otp.dart';
import 'features/auth/domain/use_cases/verify_otp.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';
import 'features/auth/presentation/bloc/register/register_bloc.dart';
import 'features/field_officer/data/data_sources/field_officer_remote_data_source.dart';
import 'features/field_officer/data/repositories/field_officer_repository_impl.dart';
import 'features/field_officer/domain/repositories/field_officer_repository.dart';
import 'features/field_officer/domain/use_cases/add_field_officer.dart';
import 'features/field_officer/domain/use_cases/get_field_officers.dart';
import 'features/field_officer/presentation/bloc/add_field_officer/add_field_officer_bloc.dart';
import 'features/field_officer/presentation/bloc/field_officer/field_officer_bloc.dart';
import 'features/home/presentation/bloc/home_admin/home_admin_bloc.dart';
import 'features/location/data/data_sources/location_local_data_source.dart';
import 'features/location/data/data_sources/location_remote_data_source.dart';
import 'features/location/data/repositories/location_repository_impl.dart';
import 'features/location/domain/repositories/location_repository.dart';
import 'features/location/domain/use_cases/get_address_from_coordinate.dart';
import 'features/location/domain/use_cases/get_current_location.dart';
import 'features/location/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'features/map/data/data_sources/map_remote_data_source.dart';
import 'features/map/data/repositories/map_repository_impl.dart';
import 'features/map/domain/repositories/map_repository.dart';
import 'features/map/domain/use_cases/get_nearby_active_reports.dart';
import 'features/map/presentation/bloc/map_bloc.dart';
import 'features/notification/data/data_sources/notification_remote_data_source.dart';
import 'features/notification/data/repositories/notification_repository_impl.dart';
import 'features/notification/domain/repositories/notification_repository.dart';
import 'features/notification/domain/use_cases/get_notification_history.dart';
import 'features/notification/presentation/bloc/notification_history/notification_history_bloc.dart';
import 'features/notification/presentation/bloc/notification_permission/notification_permission_bloc.dart';
import 'features/profile/data/data_sources/profile_local_data_source.dart';
import 'features/profile/data/data_sources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/use_cases/change_password.dart';
import 'features/profile/domain/use_cases/change_username.dart';
import 'features/profile/domain/use_cases/get_profile.dart';
import 'features/profile/domain/use_cases/get_username.dart';
import 'features/profile/domain/use_cases/upload_photo_profile.dart';
import 'features/profile/presentation/bloc/change_password/change_password_bloc.dart';
import 'features/profile/presentation/bloc/edit_profile/edit_profile_bloc.dart';
import 'features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'features/report/data/data_sources/remote/report_command_remote_data_source.dart';
import 'features/report/data/data_sources/remote/report_evidence_remote_data_source.dart';
import 'features/report/data/data_sources/remote/report_query_remote_data_source.dart';
import 'features/report/data/data_sources/remote/report_remote_data_source_facade.dart';
import 'features/report/data/data_sources/remote/report_statistic_remote_data_source.dart';
import 'features/report/data/repositories/report_repository_impl.dart';
import 'features/report/domain/repositories/report_repository.dart';
import 'features/report/domain/use_cases/assign_field_officer.dart';
import 'features/report/domain/use_cases/completing_report.dart';
import 'features/report/domain/use_cases/get_admin_report_statistics.dart';
import 'features/report/domain/use_cases/get_admin_reports.dart';
import 'features/report/domain/use_cases/get_field_officer_report_statistics.dart';
import 'features/report/domain/use_cases/get_field_officer_reports.dart';
import 'features/report/domain/use_cases/get_public_reports.dart';
import 'features/report/domain/use_cases/get_report.dart';
import 'features/report/domain/use_cases/get_report_aggregate.dart';
import 'features/report/domain/use_cases/get_user_report_amount.dart';
import 'features/report/domain/use_cases/get_user_reports.dart';
import 'features/report/domain/use_cases/provide_action.dart';
import 'features/report/domain/use_cases/reject_report.dart';
import 'features/report/domain/use_cases/submit_field_check.dart';
import 'features/report/domain/use_cases/submit_final_report.dart';
import 'features/report/domain/use_cases/submit_report.dart';
import 'features/report/domain/use_cases/verify_report.dart';
import 'features/report/presentation/bloc/admin_reports/admin_reports_bloc.dart';
import 'features/report/presentation/bloc/create_report/create_report_bloc.dart';
import 'features/report/presentation/bloc/field_officer_reports/field_officer_reports_bloc.dart';
import 'features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'features/report/presentation/bloc/my_reports/my_reports_bloc.dart';
import 'features/report/presentation/bloc/public_report_detail/public_report_detail_bloc.dart';
import 'features/report/presentation/bloc/public_reports/public_reports_bloc.dart';
import 'features/report/presentation/bloc/report_result_form/report_result_form_bloc.dart';

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
  _initNotificationFeature();

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  final internetConnectionChecker = InternetConnectionChecker();
  final supabase = Supabase.instance.client;

  // sl.registerSingleton(database);
  sl.registerLazySingleton(() => internetConnectionChecker);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => supabase);
  sl.registerLazySingleton(() => LocalDataPersistance(sl<SharedPreferences>()));
  sl.registerLazySingleton(() => NetworkInfo(sl<InternetConnectionChecker>()));

  // Push Notification Service
  sl.registerLazySingleton(() => PushNotificationService());
}

void _initAuthFeature() {
  sl.registerFactory(() => AuthBloc(supabase: sl(), getCurrentUser: sl()));
  sl.registerFactory(() => LoginBloc(login: sl()));
  sl.registerFactory(() => RegisterBloc(sendOtp: sl(), verifyOtp: sl()));

  // Use Cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(local: sl(), remote: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      localDataPersistance: sl(),
      pushNotificationService: sl(),
    ),
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
  sl.registerFactory(() => MyReportsBloc(getUserReports: sl()));
  sl.registerFactory(() => AdminReportsBloc(getAdminReports: sl()));
  sl.registerFactory(
    () => ReportResultFormBloc(submitFieldCheck: sl(), submitFinalReport: sl()),
  );

  sl.registerFactory(
    () => PublicReportsBloc(
      getPublicReports: sl(),
      getCurrentLocation: sl(),
      getUsername: sl(),
    ),
  );

  sl.registerFactory(
    () => FieldOfficerReportsBloc(
      getFieldOfficerReports: sl(),
      getFieldOfficerReportStatistics: sl(),
      getCurrentLocation: sl(),
    ),
  );

  sl.registerFactory(
    () => InternalReportDetailBloc(
      getReportAggregate: sl(),
      assignFieldOfficer: sl(),
      verifyReport: sl(),
      rejectReport: sl(),
      provideAction: sl(),
      completingReport: sl(),
      getFieldOfficers: sl(),
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
  sl.registerLazySingleton(() => SubmitFieldCheck(sl()));
  sl.registerLazySingleton(() => SubmitFinalReport(sl()));
  sl.registerLazySingleton(() => GetAdminReportStatistics(sl()));
  sl.registerLazySingleton(() => GetFieldOfficerReportStatistics(sl()));
  sl.registerLazySingleton(() => GetUserReportAmount(sl()));

  // Repository
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      remote: sl(),
      localPersistance: sl(),
      networkInfo: sl(),
    ),
  );

  // Facade
  sl.registerLazySingleton<ReportRemoteDataSourceFacade>(
    () => ReportRemoteDataSourceFacade(
      query: sl(),
      command: sl(),
      evidence: sl(),
      statistic: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ReportQueryRemoteDataSource>(
    () => ReportQueryRemoteDataSourceImpl(supabase: sl()),
  );
  sl.registerLazySingleton<ReportCommandRemoteDataSource>(
    () => ReportCommandRemoteDataSourceImpl(supabase: sl()),
  );
  sl.registerLazySingleton<ReportEvidenceRemoteDataSource>(
    () => ReportEvidenceRemoteDataSourceImpl(supabase: sl()),
  );
  sl.registerLazySingleton<ReportStatisticRemoteDataSource>(
    () => ReportStatisticRemoteDataSourceImpl(supabase: sl()),
  );
}

void _initProfileFeature() {
  sl.registerFactory(
    () => ProfileBloc(
      getProfile: sl(),
      logout: sl(),
      getUserReportAmount: sl(),
      uploadProfilePhoto: sl(),
    ),
  );
  sl.registerFactory(() => EditProfileBloc(changeUsername: sl()));
  sl.registerFactory(() => ChangePasswordBloc(changePasswordUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => GetUsername(sl()));
  sl.registerLazySingleton(() => UploadPhotoProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => ChangeUsername(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(local: sl(), remote: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(localDataPersistance: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(supabase: sl()),
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
  sl.registerFactory(
    () => HomeAdminBloc(
      getAdminReports: sl(),
      getAdminReportStatistics: sl(),
      getCurrentLocation: sl(),
    ),
  );
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
    () => FieldOfficerRepositoryImpl(remote: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<FieldOfficerRemoteDataSource>(
    () => FieldOfficerRemoteDataSourceImpl(supabase: sl()),
  );
}

void _initNotificationFeature() {
  // BLoC
  sl.registerFactory(
    () => NotificationPermissionBloc(pushNotificationService: sl()),
  );
  sl.registerFactory(
    () => NotificationHistoryBloc(
      getNotificationHistory: sl(),
      markAllAsRead: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetNotificationHistory(sl()));
  sl.registerLazySingleton(() => MarkAllAsRead(sl()));

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remote: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(supabase: sl()),
  );
}
