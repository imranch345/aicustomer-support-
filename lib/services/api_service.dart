import 'dart:math';
import '../models/user_model.dart';
import '../models/ticket_model.dart';
import '../models/message_model.dart';
import '../models/company_model.dart';

class ApiService {
  // Singleton pattern
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  // Mock database state
  UserModel? _currentUser;
  final List<TicketModel> _tickets = [];
  final List<CompanyModel> _companies = [];

  UserModel? get currentUser => _currentUser;

  // Initialize with seed mock data
  void initializeMockData() {
    _currentUser = UserModel(
      id: 'usr_1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      role: UserRole.client,
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop',
      companyId: 'comp_1',
    );

    _companies.add(CompanyModel(
      id: 'comp_1',
      name: 'Acme Corp',
      domain: 'acme.com',
      plan: CompanyPlan.premium,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ));

    // Seed Tickets
    _tickets.addAll([
      TicketModel(
        id: 'tkt_101',
        title: 'Billing issue on invoice #1042',
        description: 'I was charged twice for this month\'s subscription. Please refund the duplicate transaction.',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
        userId: 'usr_1',
        assignedAgentId: 'agent_1',
        messages: [
          MessageModel(
            id: 'msg_1',
            content: 'Hello, I noticed a double charge on my account.',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            sender: MessageSender.user,
            senderName: 'John Doe',
          ),
          MessageModel(
            id: 'msg_2',
            content: 'Thank you for reaching out John. We have assigned this to our billing specialist.',
            timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 45)),
            sender: MessageSender.system,
            senderName: 'System',
          ),
        ],
      ),
      TicketModel(
        id: 'tkt_102',
        title: 'API integration returning 500 error',
        description: 'When calling the webhook endpoint /v1/events, we are getting a 500 internal server error.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.urgent,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        userId: 'usr_1',
        assignedAgentId: 'agent_2',
        messages: [
          MessageModel(
            id: 'msg_3',
            content: 'The endpoint /v1/events crashes under load.',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            sender: MessageSender.user,
            senderName: 'John Doe',
          ),
          MessageModel(
            id: 'msg_4',
            content: 'Hey John, I am looking into the stack trace right now. It seems to be a database deadlock issue.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            sender: MessageSender.agent,
            senderName: 'Sarah Jenkins (Support Agent)',
          ),
        ],
      ),
      TicketModel(
        id: 'tkt_103',
        title: 'How to update billing email?',
        description: 'Can I add multiple email recipients for monthly invoices?',
        status: TicketStatus.resolved,
        priority: TicketPriority.low,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        userId: 'usr_1',
        assignedAgentId: 'agent_1',
        messages: [
          MessageModel(
            id: 'msg_5',
            content: 'I want to add my accounting team to invoice notifications.',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            sender: MessageSender.user,
            senderName: 'John Doe',
          ),
          MessageModel(
            id: 'msg_6',
            content: 'You can configure billing recipients under Settings > Billing > Email Notifications. I have resolved this ticket, let me know if you need anything else.',
            timestamp: DateTime.now().subtract(const Duration(days: 4)),
            sender: MessageSender.agent,
            senderName: 'Sarah Jenkins (Support Agent)',
          ),
        ],
      ),
    ]);
  }

  // Authentication
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency
    if (email.contains('admin')) {
      _currentUser = UserModel(
        id: 'usr_admin',
        name: 'Administrator',
        email: email,
        role: UserRole.admin,
        avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=256&auto=format&fit=crop',
      );
    } else {
      _currentUser = UserModel(
        id: 'usr_1',
        name: 'John Doe',
        email: email,
        role: UserRole.client,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop',
        companyId: 'comp_1',
      );
    }
    return _currentUser!;
  }

  Future<UserModel> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = UserModel(
      id: 'usr_${Random().nextInt(1000)}',
      name: name,
      email: email,
      role: UserRole.client,
      avatarUrl: null,
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  Future<void> sendForgotPasswordEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Tickets
  Future<List<TicketModel>> getTickets() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_tickets);
  }

  Future<TicketModel> createTicket(String title, String description, TicketPriority priority) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newTicket = TicketModel(
      id: 'tkt_${Random().nextInt(1000) + 200}',
      title: title,
      description: description,
      status: TicketStatus.open,
      priority: priority,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: _currentUser?.id ?? 'usr_guest',
      messages: [
        MessageModel(
          id: 'msg_${Random().nextInt(10000)}',
          content: description,
          timestamp: DateTime.now(),
          sender: MessageSender.user,
          senderName: _currentUser?.name ?? 'Guest User',
        ),
      ],
    );
    _tickets.insert(0, newTicket);
    return newTicket;
  }

  Future<TicketModel> addMessageToTicket(String ticketId, String content, MessageSender sender) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index == -1) throw Exception('Ticket not found');

    final ticket = _tickets[index];
    final newMessage = MessageModel(
      id: 'msg_${Random().nextInt(10000)}',
      content: content,
      timestamp: DateTime.now(),
      sender: sender,
      senderName: sender == MessageSender.user ? (_currentUser?.name ?? 'User') : 'Support Agent',
    );

    final updatedMessages = List<MessageModel>.from(ticket.messages)..add(newMessage);
    final updatedTicket = ticket.copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
      status: sender == MessageSender.user ? TicketStatus.open : TicketStatus.inProgress,
    );

    _tickets[index] = updatedTicket;
    return updatedTicket;
  }

  // AI Chatbot
  Future<MessageModel> getChatbotResponse(String userMessage) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    String botReply;
    final cleanMsg = userMessage.toLowerCase();

    if (cleanMsg.contains('billing') || cleanMsg.contains('invoice') || cleanMsg.contains('payment')) {
      botReply = 'For billing concerns, invoices, or subscription refunds, you can check the "Billing" section in Settings. Alternatively, would you like me to open a Billing support ticket for you?';
    } else if (cleanMsg.contains('ticket') || cleanMsg.contains('open support')) {
      botReply = 'You can easily open a ticket by navigating to the "Tickets" screen from the home dashboard and tapping the "+" button. I can also collect some details and open one right here if you prefer!';
    } else if (cleanMsg.contains('human') || cleanMsg.contains('live chat') || cleanMsg.contains('agent')) {
      botReply = 'Sure! I can connect you to a live support agent. Please head over to the "Live Chat" section from the Home screen to start a real-time messaging session with a support engineer.';
    } else if (cleanMsg.contains('hello') || cleanMsg.contains('hi')) {
      botReply = 'Hello! I am your SupportSync Assistant. How can I help you today? You can ask me about billing, opening tickets, or connecting to a live representative.';
    } else {
      botReply = 'I understand you have a question about "$userMessage". You can browse our FAQs in the Help Center, open a ticket in the Tickets tab, or request to chat with a live agent.';
    }

    return MessageModel(
      id: 'msg_${Random().nextInt(10000)}',
      content: botReply,
      timestamp: DateTime.now(),
      sender: MessageSender.bot,
      senderName: 'Support Bot',
    );
  }
}
