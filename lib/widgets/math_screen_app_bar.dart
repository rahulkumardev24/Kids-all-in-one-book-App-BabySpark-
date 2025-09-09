import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';
import 'navigation_button.dart';

class MathScreenAppBar extends StatelessWidget {
  final Size size;
  final bool isTablet;
  final String title;
  final VoidCallback onPress ;

  const MathScreenAppBar(
      {super.key,
      required this.isTablet,
      required this.size,
      required this.title ,
      required this.onPress
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      color: AppColors.babyOrange,
      child: Stack(
        children: [
          /// navigation button -> back button
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: myTextStyleCus(
                    fontSize: isTablet ? 32 : 28,
                    fontFamily: "secondary",
                  ),
                ),
              ],
            ),
          ),

          /// airplane animation
          Positioned(
            bottom: -10,
            child: Lottie.asset(
              "assets/lottie_animation_file/Sunrise - Breathe in Breathe out.json",
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),

          /// ---  Sun and cloud --- ///
          Positioned(
              right: 10,
              top: 10,
              child: Lottie.asset(
                  height: size.width * 0.18,
                  width: size.width * 0.18,
                  fit: BoxFit.cover,
                  "assets/lottie_animation_file/sun_cloud_animation.json")),

          /// --- Bird animations --- ///
          Positioned(
            top: 30,
            child: Lottie.asset(
                "assets/lottie_animation_file/Birds_in_the_sky.json",
                width: size.width,
                fit: BoxFit.cover),
          ),

          /// --- Close button --- ///
          Positioned(
              top: 8,
              left: 8,
              child: NavigationButton(onTap: onPress)),
        ],
      ),
    );
  }
}
