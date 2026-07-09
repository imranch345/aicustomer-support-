import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../widgets/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailInvoices = true;
  bool _biometricUnlock = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        children: [
          _buildSectionHeader('Preferences'),
          _buildToggleTile(
            title: 'Push Notifications',
            subtitle: 'Get alerts on ticket updates',
            value: _pushNotifications,
            onChanged: (val) {
              setState(() {
                _pushNotifications = val;
              });
            },
          ),
          _buildToggleTile(
            title: 'Email Notifications',
            subtitle: 'Receive invoice & status updates',
            value: _emailInvoices,
            onChanged: (val) {
              setState(() {
                _emailInvoices = val;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Security'),
          _buildToggleTile(
            title: 'Biometric Login',
            subtitle: 'Secure app access via FaceID/Fingerprint',
            value: _biometricUnlock,
            onChanged: (val) {
              setState(() {
                _biometricUnlock = val;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('System info'),
          ListTile(
            title: const Text('App Version'),
            trailing: Text(
              '1.0.0 (Build 42)',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: SwitchListTile(
        activeColor: AppColors.primary,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
