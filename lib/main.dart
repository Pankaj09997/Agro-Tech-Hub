import 'package:agrotech_app/NotificationService/NotificationService.dart';
import 'package:agrotech_app/bots/consts.dart';
import 'package:agrotech_app/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agrotech_app/Routes/routes.dart';
import 'package:agrotech_app/screen/splashscreen/splash.dart';
import 'package:agrotech_app/cubit/theme_cubit.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  Gemini.init(apiKey: GEMINI_API_KEY);
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
            builder: (context, child) {
              final width = MediaQuery.of(context).size.width;

              if (width >= 800) {
                // Large screen like tablet or desktop — force mobile UI layout
                return const ForcedMobileAppView();
              } else {
                // Normal mobile flow
                return child!;
              }
            },
            home: const Login(),
            initialRoute: "/",
            onGenerateRoute: RouteGenerator.generateRoute,
          );  
        },
      ),
    );
  }
}

class ForcedMobileAppView extends StatelessWidget {
  const ForcedMobileAppView({super.key});

  @override
  Widget build(BuildContext context) {
    // You can customize this container to simulate mobile view on larger screens
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 480, // Fixed width to mimic mobile
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Login(), // Start from your splash page
      ),
    );
  }
}
