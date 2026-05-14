class User {
  final String id;
  final String username;
  final String phoneNumber;
  final String? photoProfile;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.phoneNumber,
    this.photoProfile,
    required this.role,
  });
}
