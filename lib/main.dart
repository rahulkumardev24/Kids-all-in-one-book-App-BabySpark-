import 'package:babyspark/screen/math/box_count_screen.dart';
import 'package:babyspark/screen/math/math_dashboard_screen.dart';
import 'package:babyspark/screen/number/number_screen.dart';
import 'package:babyspark/screen/dashboard_screen.dart';
import 'package:babyspark/service/tts_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'helper/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// screen Orientation -> Portrait
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await TTSService.initTTS();

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
        home: BoxCountScreen(),
      ),
    );
  }
}
