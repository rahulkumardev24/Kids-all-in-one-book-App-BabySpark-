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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie_animation_file/rabbit.json"),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              "Baby Spark",
              style: myTextStyle30(
                  fontWeight: FontWeight.bold,
                  fontFamily: "mainSecond",
                  fontColor: Colors.orange),
            ),
             SizedBox(
              height: size.height * 0.01,
            ),

            /// slogan
            Text(
              "Mother's Lap, Teacher's Support!",
              style: myTextStyle22(fontFamily: "primary"),
            )
          ],
        ),
      ),
    );
  }
}


