import 'package:flutter/material.dart';
import 'package:lms_app/presentation/screens/home_page.dart';
import 'package:lms_app/presentation/screens/modules_page.dart';
import 'package:lms_app/widgets/error_screen.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    // final args = settings.arguments as Map<String,int>;

    switch(settings.name){
      case '/HomePage':
        return MaterialPageRoute(builder: (_)=> const HomePage());
      case '/ModulesPage':
        return MaterialPageRoute(builder: (_)=> const ModulesPage());
      default:
        return MaterialPageRoute(
            builder: (_) => const ErrorScreen(errorMessage: 'Page not found'));
    }
  }
}