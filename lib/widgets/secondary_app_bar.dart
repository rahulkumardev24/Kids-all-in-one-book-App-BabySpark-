import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

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
    return VxArc(
      height: size.height * 0.03,
      arcType: VxArcType.convey,
      child: Container(
        color: Colors.white,
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

            /// airplane animation
            Positioned(
              top: 0,
              child: Lottie.asset(
                "assets/lottie_animation_file/airplane_animation.json",
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
                    "assets/lottie_animation_file/sun.json")),

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
                child: NavigationButton(onTap: () => Navigator.pop(context))),
          ],
        ),
      ),
    );
  }
}
