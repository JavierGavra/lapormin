import 'package:flutter/material.dart';

import '../../../../../core/constants/notification_type.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../../core/utils/time/time_utils.dart';
import '../../../domain/entities/notification_history.dart';

class NotificationCard extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final NotificationHistory notification;

  const NotificationCard({
    super.key,
    required this.notification,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    late final Color iconBackgroundColor, iconColor;
    late final IconData icon;
    switch (notification.type) {
      case NotificationType.changeStatus:
        iconBackgroundColor = color.successContainer;
        iconColor = color.onSuccessContainer;
        icon = Icons.sync_rounded;
        break;
      case NotificationType.assignment:
        iconBackgroundColor = color.tertiaryContainer;
        iconColor = color.onTertiaryContainer;
        icon = Icons.assignment_returned_outlined;
        break;
      case NotificationType.fieldResult:
        iconBackgroundColor = color.secondaryContainer;
        iconColor = color.onSecondaryContainer;
        icon = Icons.description_outlined;
        break;
      case NotificationType.newReport:
        iconBackgroundColor = color.primaryContainer;
        iconColor = color.onPrimaryContainer;
        icon = Icons.assignment_outlined;
        break;
      case NotificationType.nearbyReport:
        iconBackgroundColor = color.warningContainer;
        iconColor = color.onWarningContainer;
        icon = Icons.info_outline_rounded;
        break;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(24, isFirst ? 24 : 16, 24, isLast ? 8 : 0),
      color: color.surfaceContainerLowest,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.type.label,
                      style: AppTextStyle.s14(fontWeight: FontWeight.w600),
                    ),
                    if (!notification.isRead)
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: color.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                Text(
                  notification.content,
                  style: AppTextStyle.s14(color: color.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  TimeUtils.format(notification.createdAt),
                  style: AppTextStyle.s12(color: color.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                if (!isLast)
                  Container(height: 1, color: color.surfaceContainerHighest),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
