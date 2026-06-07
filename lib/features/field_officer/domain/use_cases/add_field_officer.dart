import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import '../repositories/field_officer_repository.dart';

class AddFieldOfficer {
  final FieldOfficerRepository repository;

  AddFieldOfficer(this.repository);

  Future<Either<Failure, void>> call(
    String name,
    String phone,
    String password,
  ) async {
    return await repository.addFieldOfficer(name, phone, password);
  }
}
