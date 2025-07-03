import 'dart:async';

import 'package:agrotech_app/screen/network.dart';
import 'package:flutter/material.dart';

class NetworkSplash extends StatefulWidget {
  const NetworkSplash({super.key});

  @override
  State<NetworkSplash> createState() => _NetworkSplashState();
}

class _NetworkSplashState extends State<NetworkSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _navigationTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    );

    // Set up animation loop (2 cycles)
    _animationController.addStatusListener((status) {
      if (_isDisposed) return;
      
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward();

    // Navigate after 5 seconds (2 full animation cycles)
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (!_isDisposed && mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const NetworkPage(),
            transitionsBuilder: (_, a, __, c) => 
              FadeTransition(opacity: a, child: c),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
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
                  child: FadeTransition(
                    opacity: _animation,
                    child: Image.asset(
                      'assets/network.jpg',
                      fit: BoxFit.contain,
                    ),
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