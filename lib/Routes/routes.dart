import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/marketpalce/citizenverify.dart';
import 'package:agrotech_app/screen/Advice.dart';
import 'package:agrotech_app/screen/Streaming.dart';
import 'package:agrotech_app/screen/Test.dart';
import 'package:agrotech_app/screen/homepage.dart';
import 'package:agrotech_app/login.dart';
import 'package:agrotech_app/screen/network.dart';
import 'package:agrotech_app/screen/splashscreen/splash.dart';
import 'package:agrotech_app/screen/splashscreen/networksplash.dart';

import 'package:flutter/material.dart';

class RouteGenerator {
  static final ApiService _apiService = ApiService();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => SplashPage());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/network":
        return MaterialPageRoute(builder: (_) => NetworkSplash());
      case "/stream":
        return MaterialPageRoute(builder: (_) => StreamingSite());
      case "/test":
        return MaterialPageRoute(builder: (_) => Test());
      case "/advice":
        return MaterialPageRoute(builder: (_) => Advice());

      case "/citizenshipverify":
        return MaterialPageRoute(
            builder: (_) => CitizenshipVerificationScreen());

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
      appBar: AppBar(
        title: Text("Error"),
      ),
    );
  }
}
