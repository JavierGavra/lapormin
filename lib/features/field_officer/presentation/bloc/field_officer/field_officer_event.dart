import 'package:equatable/equatable.dart';

abstract class FieldOfficerEvent extends Equatable {
  const FieldOfficerEvent();

  @override
  List<Object> get props => [];
}

class FetchFieldOfficers extends FieldOfficerEvent {
  const FetchFieldOfficers();
}
