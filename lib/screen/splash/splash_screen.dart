import 'dart:async';

import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      /// after splash screen user navigate to dashboard screen
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie_animation_file/rabbit.json"),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Baby Spark",
              style: myTextStyle30(
                  fontWeight: FontWeight.bold,
                  fontFamily: "mainSecond",
                  fontColor: Colors.orange),
            ),
            const SizedBox(
              height: 10,
            ),

            /// slogan
            Text(
              "Capture the Magic of Growing Up.",
              style: myTextStyle22(fontFamily: "cursive"),
            )
          ],
        ),
      ),
    );
  }
}

/// Splash screen complete
