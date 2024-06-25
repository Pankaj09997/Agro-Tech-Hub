import 'package:agrotech_app/screen/network.dart';
import 'package:flutter/material.dart';

class NetworkSplash extends StatefulWidget {
  const NetworkSplash({super.key});

  @override
  State<NetworkSplash> createState() => _NetworkSplashState();
}

class _NetworkSplashState extends State<NetworkSplash>
    with SingleTickerProviderStateMixin {
  // Mixin that provides a single ticker, required for animations.

  //managing the animation
  late AnimationController _animationController;
  //animating object to be animated which would be controlled by the controller
  late Animation<double> _animation;
  //tracks the number of times the animation has been played
  int _animationcounts = 0;
  //tracks the direction of the animation
  bool _forward = true;

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController
        (
          //vsync:this means that the animation to be played when the widget is to be played
          vsync: this,
          //Giving duration to the animation 
           duration: Duration(seconds: 2));

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    );
    _animationController.forward();
    _animationController.addStatusListener((status) {
      //checks whether the animation has been completed or restarted
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (_animationcounts < 2) {
          _forward = !_forward;
        }
        if (_forward) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
        _animationcounts++;
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => NetworkPage()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: orientation == Orientation.portrait
          ? Column(
              children: [
                SizedBox(
                  height: height * 0.2,
                ),
                FadeTransition(
                  opacity: _animation,
                  child: Image.asset('assets/network.jpg'),
                ),
                Text(
                  "Agro-Tech Hub",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.1,
                    width: width * 1,
                  ),
                  FadeTransition(
                    opacity: _animation,
                    child: Image.asset('assets/network.jpg',
                        height: height * 0.8, width: width * 0.8),
                  ),
                  Text(
                    "Agro-Tech Hub",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
    );
  }
}
