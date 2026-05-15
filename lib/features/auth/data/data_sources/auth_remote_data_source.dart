import 'package:lapormin/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> postLogin(String phoneNumber, String password);
  Future<bool> postRegister(
    String username,
    String phoneNumber,
    String password,
  );
  Future<bool> verifyRegistrationOTP(String phoneNumber, String otpCode);
  Future<bool> postLogout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;

  const AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Future<UserModel> postLogin(String phoneNumber, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        phone: phoneNumber,
        password: password,
      );

      if (response.session == null) {
        throw Exception('Login failed: No session returned');
      }

      return UserModel.fromAuthResponse(response);
    } catch (e) {
      throw Exception('Login failed');
    }
  }

  @override
  Future<bool> postLogout() {
    // TODO: implement postLogout
    throw UnimplementedError();
  }

  @override
  Future<bool> postRegister(
    String username,
    String phoneNumber,
    String password,
  ) async {
    try {
      await supabase.auth.signUp(
        phone: phoneNumber,
        password: password,
        data: {'username': username, 'no_telp': phoneNumber},
      );
      print('Cek SMS Anda untuk melihat kode OTP!');
      return true;
    } on AuthException catch (e) {
      print('Error Registrasi: ${e.message}');
      return false;
    }
  }

  @override
  Future<bool> verifyRegistrationOTP(String phone, String otpCode) async {
    try {
      final AuthResponse response = await supabase.auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: otpCode,
      );

      print('Verifikasi sukses! Token: ${response.session?.accessToken}');
      return true;
    } on AuthException catch (e) {
      print('OTP Salah atau Expired: ${e.message}');
      return false;
    }
  }
}
