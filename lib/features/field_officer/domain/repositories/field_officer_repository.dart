import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import '../entities/field_officer.dart';

abstract class FieldOfficerRepository {
  // 📍 MENU LAMA: Fungsi untuk narik daftar petugas (JANGAN DIHAPUS)
  Future<Either<Failure, List<FieldOfficer>>> getFieldOfficers();

  Future<Either<Failure, void>> addFieldOfficer(
    String name,
    String phone,
    String password,
  );
}