import 'package:equatable/equatable.dart';

class FieldOfficer extends Equatable {
  final String id;
  final String name;
  final String phone;
  final int reportAmount;
  final DateTime createdAt;

  const FieldOfficer({
    required this.id,
    required this.name,
    required this.phone,
    required this.reportAmount,
    required this.createdAt,
  });

  String get initial {
    if (name.trim().isEmpty) {
      return '??';
    }

    final nameParts = name.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    }

    if (nameParts[1].isEmpty) {
      return nameParts[0].substring(0, 1).toUpperCase();
    }

    return '${nameParts[0].substring(0, 1)}${nameParts[1].substring(0, 1)}'
        .toUpperCase();
  }

  @override
  List<Object?> get props => [id, name, phone, reportAmount, createdAt];
}
