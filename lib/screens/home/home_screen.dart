import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../services/api_service.dart';
import '../../widgets/ticket_card.dart';
import '../../models/ticket_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TicketModel> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final tickets = await ApiService.instance.getTickets();
      setState(() {
        _tickets = tickets;
      });
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _handleLogout() async {
    await ApiService.instance.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppConstants.routeLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ApiService.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeTickets = _tickets.where((t) => t.status != TicketStatus.closed && t.status != TicketStatus.resolved).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: user?.avatarUrl == null
                            ? const Icon(Icons.person, color: AppColors.primary)
                            : null,
                      ),
                      const SizedBox(width: AppConstants.paddingS + 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          Text(
                            user?.name ?? 'Guest User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined),
                        onPressed: () => Navigator.of(context).pushNamed(AppConstants.routeNotifications),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: _handleLogout,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingL),

              // Overview Cards
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Active Cases', activeTickets.length.toString(), Colors.white),
                    Container(height: 40, width: 1, color: Colors.white.withOpacity(0.3)),
                    _buildStatColumn(
                      'Resolved',
                      _tickets.where((t) => t.status == TicketStatus.resolved).length.toString(),
                      Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingL),

              // Quick Actions
              const Text(
                'How can we help today?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingM),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.paddingM,
                mainAxisSpacing: AppConstants.paddingM,
                childAspectRatio: 1.4,
                children: [
                  _buildQuickActionCard(
                    context,
                    title: 'Chat Assistant',
                    subtitle: '24/7 Support Bot',
                    icon: Icons.smart_toy_outlined,
                    color: Colors.indigo,
                    route: AppConstants.routeChatbot,
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Support Tickets',
                    subtitle: 'Create & view cases',
                    icon: Icons.confirmation_number_outlined,
                    color: Colors.teal,
                    route: AppConstants.routeTickets,
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Live Chat',
                    subtitle: 'Talk to an agent',
                    icon: Icons.forum_outlined,
                    color: Colors.blue,
                    route: AppConstants.routeLiveChat,
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Help Center',
                    subtitle: 'FAQs & knowledgebase',
                    icon: Icons.help_outline,
                    color: Colors.amber,
                    route: AppConstants.routeHelp,
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'My Profile',
                    subtitle: 'Manage user settings',
                    icon: Icons.manage_accounts_outlined,
                    color: Colors.purple,
                    route: AppConstants.routeProfile,
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Settings',
                    subtitle: 'Theme & security',
                    icon: Icons.settings_outlined,
                    color: Colors.blueGrey,
                    route: AppConstants.routeSettings,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingL),

              // Recent Tickets Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Tickets',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppConstants.routeTickets),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingS),

              if (_isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
              else if (_tickets.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'No tickets created yet',
                      style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tickets.length > 2 ? 2 : _tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _tickets[index];
                    return TicketCard(
                      ticket: ticket,
                      onTap: () => Navigator.of(context).pushNamed(
                        AppConstants.routeTickets,
                        arguments: ticket,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingS),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
