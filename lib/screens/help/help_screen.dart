import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../widgets/app_bar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final faqs = [
      {
        'q': 'How do I open a support ticket?',
        'a': 'Navigate to "Tickets" from the dashboard, and click the Floating Action Button (+) on the bottom right. Fill in your issue summary and details, and our team will get right on it.',
      },
      {
        'q': 'What are the response time SLAs?',
        'a': 'Response times depend on your organization\'s plan. Premium support plans guarantee a response within 2 hours. Enterprise support plans offer a 30-minute SLA.',
      },
      {
        'q': 'Can I export my chat histories?',
        'a': 'Yes, you can request an export of your ticket chat logs. Head over to Settings > Security > Export Data or contact your account administrator.',
      },
      {
        'q': 'How does the chatbot agent help?',
        'a': 'Our chatbot runs on custom fine-tuned NLP models to resolve common queries (billing setup, credential issues, API usage links) instantly without waiting in queue.',
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Help Center'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
                  child: ExpansionTile(
                    title: Text(
                      faq['q']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.all(AppConstants.paddingM),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        faq['a']!,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.5),
              ),
              child: Column(
                children: [
                  const Icon(Icons.support_agent, size: 48, color: AppColors.primary),
                  const SizedBox(height: 12),
                  const Text(
                    'Still need help?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Our support teams are available 24/7. Speak to a live specialist right now.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppConstants.routeLiveChat),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Start Live Chat'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
