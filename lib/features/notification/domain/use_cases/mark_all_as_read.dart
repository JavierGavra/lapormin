import 'package:dartz/dartz.dart';
import 'package:lapormin/core/error/failures.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/notification/domain/repositories/notification_repository.dart';

class MarkAllAsRead implements UseCase<bool, NoParams> {
  final NotificationRepository repository;

  const MarkAllAsRead(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.markAllAsRead();
  }
}
