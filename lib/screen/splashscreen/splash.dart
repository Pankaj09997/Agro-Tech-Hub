import 'dart:async';
import 'package:agrotech_app/login.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  //SingleTickerProviderStateMixin for animation control
  //animation controller always needs to be initialized in init function
  late AnimationController _controller;
  //animation object
  late Animation<double> _animation;

  int _animationCount = 0;
  bool _forward = true;
//time for controlling the redirection
  // late Timer _redirectionTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      //make sure that the animation only runs when it is visible on the screen
      vsync: this,
      duration:
          Duration(milliseconds: 2000), // Adjust animation duration as needed
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start animation initially
    _controller.forward();

    // Listen for animation status
    _controller.addStatusListener((status) {
      //a animation changes its status only when there are two states i.e completed 
      //or reset or dismissed since animation usually plays in a loop so completed 
      //looks for it and dismissed if the animation has been reset
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        // Check if animation completed 2 times
        if (_animationCount < 2) {
          // Toggle animation direction
           _forward = !_forward;
          if (_forward) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          _animationCount++;
        } else {
          // Redirect to next page after animation completes 2 times
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>Login()));
        }
      }
    });

    // Set up timer to control redirection after a certain time
    // _redirectTimer = Timer(Duration(seconds: 5), () {
    //   if (_animationCount >= 2) {
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NextPage()));
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    // Cancel the timer to prevent accessing context after disposal

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
                  child: Image.asset('assets/splashimage.jpg'),
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
                    child: Image.asset('assets/splashimage.jpg',
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

// class NextPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace this with your next page widget
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Next Page'),
//       ),
//       body: Center(
//         child: Text('This is the next page'),
//       ),
//     );
//   }
// }
