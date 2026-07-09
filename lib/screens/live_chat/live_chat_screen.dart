import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../models/message_model.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/chat_bubble.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final List<MessageModel> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToAgent();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _connectToAgent() async {
    // Simulate connection lag
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isConnected = true;
        _messages.add(MessageModel(
          id: 'welcome_live',
          content: 'Hello! I am Sarah Jenkins, your dedicated Support Specialist today. How can I help you?',
          timestamp: DateTime.now(),
          sender: MessageSender.agent,
          senderName: 'Sarah Jenkins (Support Specialist)',
        ));
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    final userMessage = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: text,
      timestamp: DateTime.now(),
      sender: MessageSender.user,
    );

    setState(() {
      _messages.add(userMessage);
    });
    _scrollToBottom();

    // Mock agent auto reply after a brief latency
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _messages.add(MessageModel(
          id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
          content: 'Got it. Let me look up your account details and subscription status. Please hold on for a minute.',
          timestamp: DateTime.now(),
          sender: MessageSender.agent,
          senderName: 'Sarah Jenkins (Support Specialist)',
        ));
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Live Agent Chat'),
      body: !_isConnected
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)),
                  const SizedBox(height: 16),
                  Text(
                    'Connecting to a support specialist...',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: AppColors.success.withOpacity(0.08),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Connected to Sarah Jenkins',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(message: _messages[index]);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingS + 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              fillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingS),
                        IconButton(
                          icon: const Icon(Icons.send, color: AppColors.primary),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
