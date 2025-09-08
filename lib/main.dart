import 'package:babyspark/screen/dashboard_screen.dart';
import 'package:babyspark/screen/math/number_comparison_screen.dart';
import 'package:babyspark/service/tts_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'controller/loading_controller.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryDark,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialBinding: BindingsBuilder(() {
                Get.put(LoadingController(), permanent: true);
              }),
              home: const DashboardScreen(),
            );
          },
        ));
  }
}
