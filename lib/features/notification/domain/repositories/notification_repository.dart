import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_history.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<NotificationHistory>>> getNotificationHistory();
  Future<Either<Failure, bool>> markAllAsRead();
}
