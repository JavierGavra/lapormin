import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import '../repositories/field_officer_repository.dart';

class AddFieldOfficer implements UseCase<void, AddFieldOfficerParams> {
  final FieldOfficerRepository repository;

  AddFieldOfficer(this.repository);

  @override
  Future<Either<Failure, void>> call(AddFieldOfficerParams params) {
    return repository.addFieldOfficer(
      params.name,
      params.phone,
      params.password,
    );
  }
}

class AddFieldOfficerParams extends Equatable {
  final String name;
  final String phone;
  final String password;

  const AddFieldOfficerParams({
    required this.name,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phone, password];
}
