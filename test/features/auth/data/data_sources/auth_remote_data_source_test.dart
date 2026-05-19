import 'package:flutter_test/flutter_test.dart';
import 'package:lapormin/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  SharedPreferences.setMockInitialValues({});

  await Supabase.initialize(
    url: 'https://rhmpnzgwnlywwayhsdcp.supabase.co',
    anonKey: 'sb_publishable_9jIV3Vn9baV_elqXXwrhFQ_zDseYMFk',
  );

  final supabase = Supabase.instance.client;
  final authRemoteDataSource = AuthRemoteDataSourceImpl(supabase: supabase);

  await authRemoteDataSource.sendOtp(
    "Javier Gavra",
    "+6285866478673",
    "masyarakat123",
  );

  // final responseVerifyOTP = await authRemoteDataSource.verifyRegistrationOTP(
  //   "+6285866478673",
  //   otp,
  // );
  // print("Response Verify OTP: $responseVerifyOTP");
}
