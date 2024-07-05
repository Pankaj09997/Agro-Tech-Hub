import 'package:agrotech_app/Routes/routes.dart';

import 'package:agrotech_app/screen/splashscreen/splash.dart';


import 'package:flutter/material.dart';



void main() {
  
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashPage() ,
      initialRoute: "/",
      onGenerateRoute:RouteGenerator.generateRoute,


    );
  }
}
