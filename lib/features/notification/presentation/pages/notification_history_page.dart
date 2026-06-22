import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bar/custom_app_bar.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../bloc/notification_history/notification_history_bloc.dart';
import '../widgets/card/notification_card.dart';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({super.key});

  @override
  State<NotificationHistoryPage> createState() =>
      _NotificationHistoryPageState();
}

class _NotificationHistoryPageState extends State<NotificationHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationHistoryBloc>().add(NotificationHistoryOpened());
  }

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<AuthBloc>().state.user!.role;

    return Scaffold(
      appBar: CustomAppBar(title: "Notifikasi"),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NotificationHistoryBloc>().add(
            NotificationHistoryOpened(),
          );

          await Future.delayed(const Duration(seconds: 1));
        },
        child: BlocConsumer<NotificationHistoryBloc, NotificationHistoryState>(
          listener: (context, state) {
            if (state.isFailure) {
              showSnackBar(
                context,
                state.errorMessage ?? "Terjadi kesalahan",
                type: SnackBarType.failure,
              );
            }
          },
          builder: (context, state) {
            if (!state.isSuccess) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: state.notificationHistories.length,
              itemBuilder: (context, index) {
                final notification = state.notificationHistories[index];
                final isFirst = index == 0;
                final isLast = index == state.notificationHistories.length - 1;

                return NotificationCard(
                  notification: notification,
                  isFirst: isFirst,
                  isLast: isLast,
                  role: userRole,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
