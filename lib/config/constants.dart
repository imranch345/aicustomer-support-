class AppConstants {
  AppConstants._();

  // App details
  static const String appName = 'SupportSync';

  // API Config
  static const String apiBaseUrl = 'https://api.supportsync.example.com/v1';
  static const int connectTimeoutMs = 10000;
  static const int receiveTimeoutMs = 10000;

  // Shared Preferences or Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Layout Paddings & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // BorderRadius values
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Route Names
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeHome = '/home';
  static const String routeChatbot = '/chatbot';
  static const String routeTickets = '/tickets';
  static const String routeLiveChat = '/live-chat';
  static const String routeNotifications = '/notifications';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeHelp = '/help';
  static const String routeAdmin = '/admin';
}
