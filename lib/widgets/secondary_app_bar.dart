import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';
import 'navigation_button.dart';

class SecondaryAppBar extends StatefulWidget {
  final String title;
  const SecondaryAppBar({super.key, required this.title});

  @override
  State<SecondaryAppBar> createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {
  @override
  Widget build(BuildContext context) {
    bool isTablet(BuildContext context) {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    final size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.babyBlue.withValues(alpha: 0.5),
      height: size.height * 0.2,
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
                  widget.title,
                  style: myTextStyleCus(
                    fontSize: isTablet(context) ? 32 : 28,
                    fontFamily: "secondary",
                  ),
                ),
              ],
            ),
          ),

          /// rainbow
          Positioned(
            bottom: -10,
            child: Lottie.asset(
              "assets/lottie_animation_file/Sunrise - Breathe in Breathe out.json",
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
              right: 10,
              top: 10,
              child: Lottie.asset(
                  height: size.width * 0.25,
                  width: size.width * 0.25,
                  fit: BoxFit.cover,
                  "assets/lottie_animation_file/sun_cloud_animation.json")),

          Positioned(
            top: 30,
            child: Lottie.asset(
                "assets/lottie_animation_file/Birds_in_the_sky.json",
                width: size.width,
                fit: BoxFit.cover),
          ),

          Positioned(
              top: 10,
              left: 8,
              child: NavigationButton(onTap: () => Navigator.pop(context))),
        ],
      ),
    );
  }
}
