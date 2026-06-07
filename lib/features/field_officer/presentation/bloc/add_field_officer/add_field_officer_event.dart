abstract class AddFieldOfficerEvent {}

class SubmitFieldOfficer extends AddFieldOfficerEvent {
  final String name;
  final String phone;

  SubmitFieldOfficer({required this.name, required this.phone});
}
