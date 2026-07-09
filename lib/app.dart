import 'package:flutter/material.dart';
import 'config/constants.dart';
import 'config/theme.dart';
import 'utils/routes.dart';

class CustomerSupportApp extends StatelessWidget {
  const CustomerSupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme settings using Material 3 and premium style config
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Dynamically toggle between Dark and Light mode

      // Routing configuration
      initialRoute: AppConstants.routeSplash,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
