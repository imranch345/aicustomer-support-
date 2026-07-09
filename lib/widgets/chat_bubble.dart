import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/colors.dart';
import '../config/constants.dart';
import '../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.sender == MessageSender.user;
    
    // Bubble theme resolving
    Color bubbleColor;
    Color textColor;
    if (isUser) {
      bubbleColor = isDark ? AppColors.userBubbleDark : AppColors.userBubbleLight;
      textColor = isDark ? AppColors.userBubbleTextDark : AppColors.userBubbleTextLight;
    } else {
      bubbleColor = isDark ? AppColors.botBubbleDark : AppColors.botBubbleLight;
      textColor = isDark ? AppColors.botBubbleTextDark : AppColors.botBubbleTextLight;
    }

    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final messageAlignment = isUser ? MainAxisAlignment.end : MainAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
      child: Row(
        mainAxisAlignment: messageAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.sender == MessageSender.bot
                  ? AppColors.secondary.withOpacity(0.2)
                  : AppColors.primary.withOpacity(0.2),
              child: Icon(
                message.sender == MessageSender.bot ? Icons.smart_toy_outlined : Icons.support_agent,
                size: 16,
                color: message.sender == MessageSender.bot ? AppColors.secondary : AppColors.primary,
              ),
            ),
            const SizedBox(width: AppConstants.paddingS),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                if (!isUser && message.senderName != null) ...[
                  Text(
                    message.senderName!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingM,
                    vertical: AppConstants.paddingS + 2,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppConstants.radiusM),
                      topRight: const Radius.circular(AppConstants.radiusM),
                      bottomLeft: Radius.circular(isUser ? AppConstants.radiusM : 0),
                      bottomRight: Radius.circular(isUser ? 0 : AppConstants.radiusM),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.textSecondaryDark.withOpacity(0.7) : AppColors.textSecondaryLight.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppConstants.paddingS),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
