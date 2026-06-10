import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/notification_history.dart';
import '../models/notification_history_model.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<NotificationHistory>> fetchNotificationHistory();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient supabase;

  const NotificationRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<NotificationHistory>> fetchNotificationHistory() async {
    try {
      final userid = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('notification_history')
          .select()
          .eq('user_id', userid)
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw const TimeoutException(),
          );

      return response.map((e) => NotificationHistoryModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }
}
