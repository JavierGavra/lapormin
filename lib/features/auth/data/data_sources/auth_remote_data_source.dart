import 'package:lapormin/core/error/exceptions.dart';
import 'package:lapormin/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<bool> isPhoneExist(String phoneNumber);
  Future<void> sendOtp(String username, String phoneNumber, String password);
  Future<bool> verifyOtp(String phoneNumber, String otp);
  Future<UserModel> postLogin(String phoneNumber, String password);
  Future<bool> postLogout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;

  const AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Future<UserModel> postLogin(String phoneNumber, String password) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        phone: phoneNumber,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('Pengguna tidak ditemukan.');
      }

      final userData = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromMap(userData);
    } on AuthException catch (e) {
      throw InvalidCredentialsException(e.message);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw ServerException();
    }
  }

  @override
  Future<bool> postLogout() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendOtp(
    String username,
    String phoneNumber,
    String password,
  ) async {
    try {
      await supabase.auth.signUp(
        phone: phoneNumber,
        password: password,
        data: {
          'username': username,
          'full_name': username,
          'no_telp': phoneNumber,
        },
      );
    } on AuthException catch (e) {
      throw InvalidCredentialsException(e.message);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw const ServerException();
    }
  }

  @override
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    try {
      await supabase.auth.verifyOTP(
        type: OtpType.sms,
        phone: phoneNumber,
        token: otp,
      );
      return true;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw const ServerException();
    }
  }

  @override
  Future<bool> isPhoneExist(String phoneNumber) {
    throw UnimplementedError();
  }
}
