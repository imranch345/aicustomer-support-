import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../widgets/app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mockNotifications = [
      {
        'title': 'Ticket Resolved',
        'body': 'Your ticket #tkt_103 "How to update billing email?" has been marked as resolved.',
        'time': '2 hours ago',
        'icon': Icons.check_circle_outline,
        'color': AppColors.success,
      },
      {
        'title': 'Agent Replied',
        'body': 'Sarah Jenkins left a reply on ticket #tkt_102 "API integration returning 500 error".',
        'time': '5 hours ago',
        'icon': Icons.forum_outlined,
        'color': AppColors.primary,
      },
      {
        'title': 'System Maintenance',
        'body': 'SupportSync will undergo scheduled database maintenance on Sunday at 02:00 AM UTC.',
        'time': '1 day ago',
        'icon': Icons.build_outlined,
        'color': AppColors.warning,
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: mockNotifications.isEmpty
          ? Center(
              child: Text(
                'You have no notifications',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              itemCount: mockNotifications.length,
              itemBuilder: (context, index) {
                final item = mockNotifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppConstants.paddingS),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: item['color'] as Color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['body'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['time'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.textSecondaryDark.withOpacity(0.6)
                                      : AppColors.textSecondaryLight.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
