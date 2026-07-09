import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary branding
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFFEEF2F6); // Indigo 50
  
  // Secondary / Accent branding
  static const Color secondary = Color(0xFF0EA5E9); // Sky 500
  static const Color accent = Color(0xFF10B981); // Emerald 500

  // Neutral Colors (Light Mode)
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF475569); // Slate 600
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200

  // Neutral Colors (Dark Mode)
  static const Color backgroundDark = Color(0xFF0B0F19); // Custom deep dark blue-grey
  static const Color surfaceDark = Color(0xFF151D30); // Deep slate card
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400
  static const Color borderDark = Color(0xFF1E293B); // Slate 800

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Rose 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Bubble Colors
  static const Color userBubbleLight = Color(0xFF6366F1);
  static const Color userBubbleTextLight = Colors.white;
  static const Color botBubbleLight = Color(0xFFF1F5F9);
  static const Color botBubbleTextLight = Color(0xFF0F172A);

  static const Color userBubbleDark = Color(0xFF4F46E5);
  static const Color userBubbleTextDark = Colors.white;
  static const Color botBubbleDark = Color(0xFF1E293B);
  static const Color botBubbleTextDark = Color(0xFFF1F5F9);
}
