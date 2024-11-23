import 'package:flutter/material.dart';
import 'package:lms_app/data/models/subjects.dart';
import 'package:lms_app/presentation/screens/home_page.dart';
import 'package:lms_app/presentation/screens/modules_page.dart';
import 'package:lms_app/presentation/screens/video_screen.dart';
import 'package:lms_app/widgets/error_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/HomePage':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/ModulesPage':
        if (args is Subjects) {
          return MaterialPageRoute(
            builder: (_) => ModulesPage(subject: args),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(errorMessage: 'Invalid args for ModulesPage'),
        );
      case '/VideosPage':
        if (args is Map<String, dynamic>) {
          final modName = args['modName'];
          final modId = args['modId'];

          return MaterialPageRoute(
            builder: (_) => VideoScreen(modName: modName, modId: modId),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(errorMessage: 'Invalid args for VideosPage'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(errorMessage: 'Page not found'),
        );
    }
  }
}
