import '../entities/field_officer.dart';
import '../repositories/field_officer_repository.dart';

class GetFieldOfficers {
  final FieldOfficerRepository repository;

  GetFieldOfficers(this.repository);

  Future<List<FieldOfficer>> execute() async {
    return await repository.getFieldOfficers();
  }
}
