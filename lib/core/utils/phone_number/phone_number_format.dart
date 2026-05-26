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
    return phone.replaceAllMapped(
      RegExp(r'^(\d{4})(\d{4})(\d+)$'),
      (Match m) => '${m[1]}-${m[2]}-${m[3]}',
    );
  }
}
