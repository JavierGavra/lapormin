abstract class AddFieldOfficerState {}

class AddFieldOfficerInitial extends AddFieldOfficerState {}

class AddFieldOfficerLoading extends AddFieldOfficerState {}

class AddFieldOfficerFailure extends AddFieldOfficerState {
  final String message;
  AddFieldOfficerFailure(this.message);
}

class AddFieldOfficerSuccess extends AddFieldOfficerState {
  final String generatedPassword;
  AddFieldOfficerSuccess(this.generatedPassword);
}
