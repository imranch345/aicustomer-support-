import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/colors.dart';
import '../config/constants.dart';
import '../models/ticket_model.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Status style mapping
    Color statusColor;
    String statusText;
    switch (ticket.status) {
      case TicketStatus.open:
        statusColor = AppColors.info;
        statusText = 'Open';
        break;
      case TicketStatus.inProgress:
        statusColor = AppColors.warning;
        statusText = 'In Progress';
        break;
      case TicketStatus.pending:
        statusColor = Colors.purple;
        statusText = 'Pending';
        break;
      case TicketStatus.resolved:
        statusColor = AppColors.success;
        statusText = 'Resolved';
        break;
      case TicketStatus.closed:
        statusColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
        statusText = 'Closed';
        break;
    }

    // Priority style mapping
    Color priorityColor;
    String priorityText;
    switch (ticket.priority) {
      case TicketPriority.low:
        priorityColor = AppColors.success;
        priorityText = 'Low';
        break;
      case TicketPriority.medium:
        priorityColor = AppColors.warning;
        priorityText = 'Medium';
        break;
      case TicketPriority.high:
        priorityColor = Colors.orange;
        priorityText = 'High';
        break;
      case TicketPriority.urgent:
        priorityColor = AppColors.error;
        priorityText = 'Urgent';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${ticket.id}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  Row(
                    children: [
                      _Badge(text: priorityText, color: priorityColor),
                      const SizedBox(width: 8),
                      _Badge(text: statusText, color: statusColor),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingS),
              Text(
                ticket.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                ticket.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.paddingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(ticket.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  if (ticket.assignedAgentId != null)
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 14,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Assigned',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
