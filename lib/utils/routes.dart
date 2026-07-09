import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/signup/signup_screen.dart';
import '../screens/forgot_password/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/chatbot/chatbot_screen.dart';
import '../screens/tickets/tickets_screen.dart';
import '../screens/live_chat/live_chat_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/help/help_screen.dart';
import '../screens/admin/admin_screen.dart';

class AppRoutes {
  AppRoutes._();

  static Map<String, WidgetBuilder> get routes {
    return {
      AppConstants.routeSplash: (context) => const SplashScreen(),
      AppConstants.routeOnboarding: (context) => const OnboardingScreen(),
      AppConstants.routeLogin: (context) => const LoginScreen(),
      AppConstants.routeSignup: (context) => const SignupScreen(),
      AppConstants.routeForgotPassword: (context) => const ForgotPasswordScreen(),
      AppConstants.routeHome: (context) => const HomeScreen(),
      AppConstants.routeChatbot: (context) => const ChatbotScreen(),
      AppConstants.routeTickets: (context) => const TicketsScreen(),
      AppConstants.routeLiveChat: (context) => const LiveChatScreen(),
      AppConstants.routeNotifications: (context) => const NotificationsScreen(),
      AppConstants.routeProfile: (context) => const ProfileScreen(),
      AppConstants.routeSettings: (context) => const SettingsScreen(),
      AppConstants.routeHelp: (context) => const HelpScreen(),
      AppConstants.routeAdmin: (context) => const AdminScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // If dynamic routes with arguments are needed in the future, handle them here
    return null;
  }
}
