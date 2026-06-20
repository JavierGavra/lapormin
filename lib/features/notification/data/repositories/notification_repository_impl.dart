import 'package:dartz/dartz.dart';
import 'package:lapormin/core/utils/network/network_info.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_history.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;
  final NetworkInfo networkInfo;

  const NotificationRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NotificationHistory>>>
  getNotificationHistory() async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure());

      final result = await remote.fetchNotificationHistory();

      return Right(result);
    } on NetworkException {
      return Left(NetworkFailure());
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> markAllAsRead() async {
    try {
      final result = await remote.markNotificationsAsRead();

      return Right(result);
    } on NetworkException {
      return Left(NetworkFailure());
    } on TimeoutException {
      return Left(NetworkFailure("Koneksi internet lambat. Coba lagi."));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
