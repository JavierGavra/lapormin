enum UserRole {
  informant('informant'),
  admin('admin'),
  fieldOfficer('field_officer');

  final String dbValue;
  const UserRole(this.dbValue);

  static UserRole fromString(String role) => UserRole.values.firstWhere(
    (e) => e.dbValue == role,
    orElse: () => UserRole.informant,
  );
}
