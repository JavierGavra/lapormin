import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';

import '../entities/field_officer.dart';
import '../repositories/field_officer_repository.dart';

class GetFieldOfficers implements UseCase<List<FieldOfficer>, NoParams> {
  final FieldOfficerRepository repository;

  GetFieldOfficers(this.repository);

  @override
  Future<Either<Failure, List<FieldOfficer>>> call(NoParams params) {
    return repository.getFieldOfficers();
  }
}
