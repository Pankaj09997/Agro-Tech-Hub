import 'package:agrotech_app/homepage.dart';
import 'package:agrotech_app/login.dart';
import 'package:agrotech_app/splash.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => SplashPage());
      case "/login":
        return MaterialPageRoute(builder: (_) => login());
      case "/home":
        return MaterialPageRoute(builder: (_) => homepage());
      default:
        return MaterialPageRoute(builder: (_) => Error());
    }
  }
}
class Error extends StatelessWidget {
  const Error({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Error"),),
    );
  }
}
