import 'package:babyspark/screen/dashboard_screen.dart';
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

  try {
    /// Firebase initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Screen Orientation -> Portrait only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// Initialize TTS service
    await TTSService.initTTS();
  } catch (e) {
    print("Initialization error: $e");
  }

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
        systemNavigationBarColor: Colors.black, // Added for better navigation bar
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialBinding: BindingsBuilder(() {
              Get.put(LoadingController(), permanent: true);
            }),
            theme: ThemeData(
              primaryColor: AppColors.primaryDark,
              fontFamily: 'main',
            ),
            home: const DashboardScreen(),

            // Optional: Add error handling for better UX
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child ?? const SizedBox(),
              );
            },
          );
        },
      ),
    );
  }
}