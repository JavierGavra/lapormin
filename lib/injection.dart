import 'package:get_it/get_it.dart';
import 'package:lapormin/features/auth/data/data_sources/auth_local_data_source.dart';

import 'package:lapormin/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lapormin/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lapormin/features/auth/domain/repositories/auth_repository.dart';
import 'package:lapormin/features/auth/domain/use_cases/login.dart';
import 'package:lapormin/features/auth/domain/use_cases/send_otp.dart';
import 'package:lapormin/features/auth/domain/use_cases/verify_otp.dart';
import 'package:lapormin/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:lapormin/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:lapormin/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:lapormin/features/location/data/data_sources/location_local_data_source.dart';
import 'package:lapormin/features/location/data/data_sources/location_remote_data_source.dart';
import 'package:lapormin/features/location/data/repositories/location_repository_impl.dart';
import 'package:lapormin/features/location/domain/repositories/location_repository.dart';
import 'package:lapormin/features/location/domain/use_cases/get_address_from_coordinate.dart';
import 'package:lapormin/features/location/domain/use_cases/get_current_location.dart';
import 'package:lapormin/features/location/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'package:lapormin/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:lapormin/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:lapormin/features/profile/domain/repositories/profile_repository.dart';
import 'package:lapormin/features/profile/domain/use_cases/get_profile.dart';
import 'package:lapormin/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:lapormin/features/report/data/data_sources/report_remote_data_source.dart';
import 'package:lapormin/features/report/data/repositories/report_repository_impl.dart';
import 'package:lapormin/features/report/domain/repositories/report_repository.dart';
import 'package:lapormin/features/report/domain/use_cases/get_report.dart';
import 'package:lapormin/features/report/domain/use_cases/submit_report.dart';
import 'package:lapormin/features/report/presentation/bloc/create_report/create_report_bloc.dart';
import 'package:lapormin/features/report/presentation/bloc/public_detail_report/public_detail_report_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initializeServiceLocator() async {
  // Feature
  _initAuthFeature();
  _initLocationFeature();
  _initReportFeature();
  _initProfileFeature();

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
  sl.registerFactory(() => PublicDetailReportBloc(getReport: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetReport(sl()));
  sl.registerLazySingleton(() => SubmitReport(sl()));

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
  sl.registerFactory(() => ProfileBloc(getProfile: sl()));

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
