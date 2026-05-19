class InputValidator {
  static String? empty(String? value) {
    return value.toString().trim().isEmpty ? 'Bidang tidak boleh kosong' : null;
  }

  static String? phone(String? value) {
    final isValid = RegExp(r'^\d{10,15}$').hasMatch(value.toString());
    return !isValid ? 'Nomor telepon tidak valid' : null;
  }

  static String? password(String? value) {
    if (value.toString().length < 8) {
      return 'Kata sandi harus minimal 8 karakter';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    return value != password ? 'Kata sandi tidak cocok' : null;
  }
}
