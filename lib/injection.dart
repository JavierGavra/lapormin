import 'package:get_it/get_it.dart';

import 'package:lapormin/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lapormin/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lapormin/features/auth/domain/repositories/auth_repository.dart';
import 'package:lapormin/features/auth/domain/use_cases/send_otp.dart';
import 'package:lapormin/features/auth/domain/use_cases/verify_otp.dart';
import 'package:lapormin/features/auth/presentation/bloc/register/register_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initializeServiceLocator() async {
  // Feature
  _initAuthFeature();

  // External
  // final database = await DatabaseHelper.instance.database;
  final sharedPreferences = await SharedPreferences.getInstance();
  final supabase = Supabase.instance.client;

  // sl.registerSingleton(database);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => supabase);
}

void _initAuthFeature() {
  sl.registerFactory(() => RegisterBloc(sendOtp: sl(), verifyOtp: sl()));

  // Use Cases
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabase: sl()),
  );
}
