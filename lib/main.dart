import 'package:babyspark/screen/number/number_screen.dart';
import 'package:babyspark/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        title: 'BabyBook - All in one',
        debugShowCheckedModeBanner: false,
        home: DashboardScreen(),
      ),
    );
  }
}
