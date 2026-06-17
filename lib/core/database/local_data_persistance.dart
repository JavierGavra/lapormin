import 'package:shared_preferences/shared_preferences.dart';

class LocalDataPersistance {
  final SharedPreferences _prefs;

  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _phoneNumberKey = 'phone_number';
  static const String _createdAtKey = 'created_at';
  static const String _roleKey = 'role';
  static const String _photoProfileKey = 'photo_profile';
  static const String _reportAmountKey = 'report_amount';

  const LocalDataPersistance(this._prefs);

  Future<void> clear() async {
    await _prefs.clear();
  }

  // =========== Getters ===========
  String? get getUserId => _prefs.getString(_userIdKey);
  String? get getUsername => _prefs.getString(_usernameKey);
  String? get getPhoneNumber => _prefs.getString(_phoneNumberKey);
  String? get getCreatedAt => _prefs.getString(_createdAtKey);
  String? get getRole => _prefs.getString(_roleKey);
  String? get getPhotoProfile => _prefs.getString(_photoProfileKey);
  int? get getReportAmount => _prefs.getInt(_reportAmountKey);

  // =========== Setters ===========
  Future<void> setUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  Future<void> setUsername(String username) async {
    await _prefs.setString(_usernameKey, username);
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    await _prefs.setString(_phoneNumberKey, phoneNumber);
  }

  Future<void> setCreatedAt(DateTime createdAt) async {
    await _prefs.setString(_createdAtKey, createdAt.toIso8601String());
  }

  Future<void> setRole(String role) async {
    await _prefs.setString(_roleKey, role);
  }

  Future<void> setPhotoProfile(String photoProfile) async {
    await _prefs.setString(_photoProfileKey, photoProfile);
  }

  Future<void> setReportAmount(int reportAmount) async {
    await _prefs.setInt(_reportAmountKey, reportAmount);
  }
}
