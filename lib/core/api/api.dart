import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static final String baseUrl = dotenv.get('SUPABASE_URL');
  static final String anonKey = dotenv.get('SUPABASE_ANON_KEY');
}
