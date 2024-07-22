import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agrotech_app/Routes/routes.dart';
import 'package:agrotech_app/screen/splashscreen/splash.dart';
import 'package:agrotech_app/cubit/theme_cubit.dart';

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
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: const SplashPage(),
            initialRoute: "/",
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
