import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini/models/openscreen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _zoomAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);
    _animationController.forward();

    // Simulate a time-consuming operation, e.g., fetching data
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the next screen after 2 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OpenScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(6, 30, 69, 1),
      // Customize your background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _fadeAnimation.value,
              duration: const Duration(milliseconds: 900),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                width: 200 * _zoomAnimation.value,
                height: 200 * _zoomAnimation.value,
                child: Image.asset(
                  'images/loginpagephoto-removebg-preview.png', // Replace with your own image path
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16),
            AnimatedOpacity(
              opacity: _fadeAnimation.value,
              duration: const Duration(milliseconds: 200),
              child: GradientText(
                'Welcome To GuideViz',
                style: TextStyle(
fontFamily: 'SourceSansPro',
                  fontSize: 35.0 * _zoomAnimation.value,
                  fontWeight: FontWeight.w500,
                ),
                colors: [
                  Color.fromRGBO(67, 236, 227, 1),
                  Color.fromRGBO(20, 188, 233, 1)
                ],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

