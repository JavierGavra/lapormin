import '../../domain/entities/field_officer.dart';
import '../../domain/repositories/field_officer_repository.dart';
import '../data_sources/field_officer_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';

class FieldOfficerRepositoryImpl implements FieldOfficerRepository {
  final FieldOfficerRemoteDataSource remoteDataSource;

  FieldOfficerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FieldOfficer>> getFieldOfficers() async {
    try {
      final models = await remoteDataSource.getFieldOfficers();
      return models;
    } catch (e) {
      rethrow;
    }
  }

  // 📍 FUNGSI INI HARUS RAPI SEPERTI INI, MANGGIL REMOTE DATA SOURCE
  @override
  Future<Either<Failure, void>> addFieldOfficer(
    String name,
    String phone,
    String password,
  ) async {
    try {
      await remoteDataSource.addFieldOfficer(name, phone, password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
