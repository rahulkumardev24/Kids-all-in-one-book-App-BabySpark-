import 'package:babyspark/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';

class MonthsScreen extends StatefulWidget {
  const MonthsScreen({super.key});

  @override
  State<MonthsScreen> createState() => _MonthsScreenState();
}

class _MonthsScreenState extends State<MonthsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const SecondaryAppBar(title: "Months"),
      ),
    );
  }
}
