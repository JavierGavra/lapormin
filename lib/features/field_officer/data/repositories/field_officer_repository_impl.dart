import 'package:lapormin/core/error/exceptions.dart';
import 'package:lapormin/core/utils/network/network_info.dart';

import '../../domain/entities/field_officer.dart';
import '../../domain/repositories/field_officer_repository.dart';
import '../data_sources/field_officer_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';

class FieldOfficerRepositoryImpl implements FieldOfficerRepository {
  final FieldOfficerRemoteDataSource remote;
  final NetworkInfo networkInfo;

  FieldOfficerRepositoryImpl({required this.remote, required this.networkInfo});

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() call) async {
    try {
      if (!await networkInfo.isConnected) return Left(NetworkFailure());
      final result = await call();
      return Right(result);
    } on NetworkException {
      return Left(NetworkFailure());
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FieldOfficer>>> getFieldOfficers() =>
      _execute(() => remote.getFieldOfficers());

  @override
  Future<Either<Failure, void>> addFieldOfficer(
    String name,
    String phone,
    String password,
  ) => _execute(() => remote.addFieldOfficer(name, phone, password));
}
