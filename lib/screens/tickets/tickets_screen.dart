import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../models/ticket_model.dart';
import '../../models/message_model.dart';
import '../../services/api_service.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/ticket_card.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/chat_bubble.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  List<TicketModel> _tickets = [];
  bool _isLoading = true;
  TicketModel? _selectedTicket; // For viewing details on the same screen or split-view

  // Ticket Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TicketPriority _selectedPriority = TicketPriority.medium;
  bool _isCreating = false;

  // Detail View Chat Controller
  final _replyController = TextEditingController();
  final _chatScrollController = ScrollController();
  bool _isReplying = false;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _replyController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    setState(() => _isLoading = true);
    try {
      final tickets = await ApiService.instance.getTickets();
      setState(() {
        _tickets = tickets;
        // Keep selected ticket in sync if updated
        if (_selectedTicket != null) {
          _selectedTicket = tickets.firstWhere((t) => t.id == _selectedTicket!.id, orElse: () => _selectedTicket!);
        }
      });
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  void _scrollToChatBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleCreateTicket() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isCreating = true);

    try {
      await ApiService.instance.createTicket(
        _titleController.text,
        _descriptionController.text,
        _selectedPriority,
      );
      _titleController.clear();
      _descriptionController.clear();
      Navigator.of(context).pop(); // Close sheet
      _loadTickets();
    } catch (_) {}
    setState(() => _isCreating = false);
  }

  Future<void> _handleSendReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty || _selectedTicket == null) return;

    _replyController.clear();
    setState(() => _isReplying = true);

    try {
      final updatedTicket = await ApiService.instance.addMessageToTicket(
        _selectedTicket!.id,
        text,
        MessageSender.user,
      );
      setState(() {
        _selectedTicket = updatedTicket;
      });
      _scrollToChatBottom();
      
      // Reload underlying ticket list in background
      final updatedList = await ApiService.instance.getTickets();
      setState(() {
        _tickets = updatedList;
      });
    } catch (_) {}
    setState(() => _isReplying = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Check if Route arguments passed a ticket directly to view details
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is TicketModel && _selectedTicket == null) {
      _selectedTicket = routeArgs;
    }

    if (_selectedTicket != null) {
      return _buildTicketDetailsView(isDark);
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Support Tickets', showBackButton: true),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showCreateTicketSheet(context),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTickets,
              child: _tickets.isEmpty
                  ? Center(
                      child: Text(
                        'No tickets created yet.',
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      itemCount: _tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = _tickets[index];
                        return TicketCard(
                          ticket: ticket,
                          onTap: () {
                            setState(() {
                              _selectedTicket = ticket;
                            });
                          },
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildTicketDetailsView(bool isDark) {
    final ticket = _selectedTicket!;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ticket #${ticket.id}',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTickets,
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          setState(() {
            _selectedTicket = null;
          });
          return false;
        },
        child: Column(
          children: [
            // Header Ticket Info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ticket.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            // Message log
            Expanded(
              child: ListView.builder(
                controller: _chatScrollController,
                padding: const EdgeInsets.all(AppConstants.paddingM),
                itemCount: ticket.messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: ticket.messages[index]);
                },
              ),
            ),
            // Message Input bar
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
                        controller: _replyController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSendReply(),
                        decoration: InputDecoration(
                          hintText: 'Add a reply to ticket...',
                          fillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingS),
                    IconButton(
                      icon: _isReplying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send, color: AppColors.primary),
                      onPressed: _handleSendReply,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTicketSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusL)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: AppConstants.paddingL,
                right: AppConstants.paddingL,
                top: AppConstants.paddingL,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Open Support Ticket',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'Ticket Subject',
                        hintText: 'Brief summary of the issue',
                        validator: (val) => val == null || val.isEmpty ? 'Subject is required' : null,
                      ),
                      const SizedBox(height: AppConstants.paddingM),
                      CustomTextField(
                        controller: _descriptionController,
                        labelText: 'Detailed Description',
                        hintText: 'Please detail step-by-step logs, links, or info...',
                        maxLines: 4,
                        validator: (val) => val == null || val.isEmpty ? 'Description is required' : null,
                      ),
                      const SizedBox(height: AppConstants.paddingM),
                      const Text(
                        'Case Priority',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppConstants.paddingS),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: TicketPriority.values.map((priority) {
                          final isSelected = _selectedPriority == priority;
                          return ChoiceChip(
                            label: Text(priority.name.toUpperCase()),
                            selected: isSelected,
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() {
                                  _selectedPriority = priority;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                      CustomButton(
                        text: 'Submit Case',
                        onPressed: _handleCreateTicket,
                        isLoading: _isCreating,
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
