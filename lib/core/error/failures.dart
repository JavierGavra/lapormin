import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

class ServerFailure extends Failure {
  const ServerFailure([String super.message = 'Terjadi kesalahan pada server']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String super.message = 'Tidak ada koneksi internet']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    String super.message = 'Sesi Anda telah berakhir, silakan login kembali',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
