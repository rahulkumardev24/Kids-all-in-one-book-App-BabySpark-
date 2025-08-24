import 'package:flutter/material.dart';

class MathDashboardScreen extends StatefulWidget {
  const MathDashboardScreen({super.key});

  @override
  State<MathDashboardScreen> createState() => _MathDashboardScreenState();
}

class _MathDashboardScreenState extends State<MathDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Learn Math"),),
    );
  }
}
