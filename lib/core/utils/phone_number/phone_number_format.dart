class PhoneNumberFormat {
  static String international(String prefix, String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]+'), '');

    // +6287654321098
    if (phoneNumber.startsWith(prefix)) {
      return phoneNumber;
    }

    // 087654321098
    if (phoneNumber.startsWith('0')) {
      return '$prefix${phoneNumber.substring(1)}';
    }

    // 87654321098
    return '$prefix$phoneNumber';
  }

  static String formatted(String phone) {
    // 1. Bersihkan semua non-digit
    String digits = phone.replaceAll(RegExp(r'\D'), '');

    // 2. Normalisasi prefix → buang '62' atau '0' di awal
    if (digits.startsWith('62')) {
      digits = digits.substring(2);
    } else if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    // 3. Format: +62 XXX-XXXX-XXXX
    return digits.replaceAllMapped(
      RegExp(r'^(\d{3})(\d{4})(\d+)$'),
      (m) => '+62 ${m[1]}-${m[2]}-${m[3]}',
    );
  }
}
