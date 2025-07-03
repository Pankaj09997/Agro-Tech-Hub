import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agrotech_app/screen/network.dart';

class NetworkSplash extends StatefulWidget {
  const NetworkSplash({super.key});

  @override
  State<NetworkSplash> createState() => _NetworkSplashState();
}

class _NetworkSplashState extends State<NetworkSplash> {
  @override
  void initState() {
    super.initState();

    // Wait until the first frame is rendered, then start the timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const NetworkPage()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/network.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Agro-Tech Hub",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
