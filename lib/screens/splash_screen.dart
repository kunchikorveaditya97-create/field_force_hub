import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Keeps the splash screen active for 4 seconds so you can see the typing animation
    await Future.delayed(const Duration(milliseconds: 4000));

    if (!mounted) return;

    // Smoothly transition over to the Login Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Setting up the clean text to match your new logo image exactly!
    final String mainTitle = "FIELD";
    final String subTitle = "FORCE HUB";

    return Scaffold(
      // A premium, very dark custom purple background matching your logo design
      backgroundColor: const Color(0xFF110724),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO ICON: Swapped the rocket for a beautiful connected geometric network node icon
            const Icon(
              Icons.hub_rounded,
              size: 100,
              color: Color(0xFFB176FF), // A vibrant bright purple matching the logo's core accents
            ),
            const SizedBox(height: 35),

            // MAIN TEXT ANIMATION ("FIELD")
            TweenAnimationBuilder<int>(
              duration: const Duration(milliseconds: 1200), // Takes 1.2 seconds to type "FIELD"
              tween: IntTween(begin: 0, end: mainTitle.length),
              builder: (BuildContext context, int value, Widget? child) {
                String animatedText = mainTitle.substring(0, value);
                return Text(
                  animatedText,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4.0,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // SUB TEXT ANIMATION ("FORCE HUB")
            TweenAnimationBuilder<int>(
              duration: const Duration(milliseconds: 2000), // Types out fully right after
              tween: IntTween(begin: 0, end: subTitle.length),
              builder: (BuildContext context, int value, Widget? child) {
                String animatedText = subTitle.substring(0, value);
                return Text(
                  animatedText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70, // Slightly faded white for a perfect text hierarchy
                    letterSpacing: 3.0,
                  ),
                );
              },
            ),
            const SizedBox(height: 50),

            // A clean, sleek loading wheel that matches our bright purple accent color
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB176FF)),
            ),
          ],
        ),
      ),
    );
  }
}