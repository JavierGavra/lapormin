import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/text_style/app_text_style.dart';
import '../../../../core/widgets/button/app_back_button.dart';
import '../bloc/notification_history/notification_history_bloc.dart';
import '../widgets/card/notification_card.dart';

class NotificationHistoryPage extends StatelessWidget {
  const NotificationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        leadingWidth: 24 + 40,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        surfaceTintColor: Colors.transparent,
        backgroundColor: color.surfaceContainerLowest,
        actionsPadding: const EdgeInsets.only(right: 24),
        title: Text(
          "Notifikasi",
          style: AppTextStyle.s16(
            fontWeight: FontWeight.w600,
            color: color.primary,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Center(
            child: SizedBox(width: 40, height: 40, child: AppBackButton()),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NotificationHistoryBloc>().add(
            NotificationHistoryOpened(),
          );

          await Future.delayed(const Duration(seconds: 1));
        },
        child: BlocConsumer<NotificationHistoryBloc, NotificationHistoryState>(
          listener: (context, state) {},
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
