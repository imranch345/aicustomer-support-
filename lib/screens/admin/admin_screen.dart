import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../models/ticket_model.dart';
import '../../services/api_service.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/ticket_card.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<TicketModel> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllTickets();
  }

  Future<void> _loadAllTickets() async {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Admin Control Panel',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Stats Banner
              const Text(
                'Live Operations Dashboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.paddingM),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Unassigned',
                      _tickets.where((t) => t.assignedAgentId == null).length.toString(),
                      AppColors.error,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: _buildStatCard(
                      'Live Queues',
                      '4 sessions',
                      AppColors.warning,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: _buildStatCard(
                      'SLA Breaches',
                      '0 cases',
                      AppColors.success,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Assigned Tickets Queue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.paddingS),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_tickets.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'No active support cases.',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _tickets[index];
                    return TicketCard(
                      ticket: ticket,
                      onTap: () {
                        // Open detail logs
                        Navigator.of(context).pushNamed(
                          AppConstants.routeTickets,
                          arguments: ticket,
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, bool isDark) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
