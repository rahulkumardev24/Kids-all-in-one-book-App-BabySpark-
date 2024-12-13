import 'package:babyspark/screen/dashboard_screen.dart';
import 'package:babyspark/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DashboardScreen()
    );
  }
}



/// ----------------------------------- IN THIS PROJECT -------------------------///
/// CREATE COMPLETE KIDS / BABY All in on Book
///
/// SIMPLE PROJECT
/// ------------------------- IN THIS VIDEO ------------------------------------///
///------------------------------------ VIDEO 1--------------------------------///
/// PROJECT SETUP
/// START
/// fonts download from google fonts
/// ---------------------- DONE --------------------------------///
/// ADD DEPENDENCY
/// ------------------------ COMPLETE -------------------------///
///
/// NEXT VIDEO
/// ----------------------------SPLASH SCREEN -----------------------///
///
///------------------------------------ VIDEO 2 --------------------///
/// IN THIS VIDEO SPLASH SCREEN CREATE
/// ------------ SPLASH SCREEN COMPLETE ---------------------------///
///
/// -------------------- VIDEO 3 --------------------------------///
/// DASH BOARD SCREEN CREATE AND DESIGN
///
///
///
