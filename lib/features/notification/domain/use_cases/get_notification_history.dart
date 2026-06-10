import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/notification_history.dart';
import '../repositories/notification_repository.dart';

class GetNotificationHistory
    implements UseCase<List<NotificationHistory>, NoParams> {
  final NotificationRepository repository;

  const GetNotificationHistory(this.repository);

  @override
  Future<Either<Failure, List<NotificationHistory>>> call(NoParams params) {
    return repository.getNotificationHistory();
  }
}
