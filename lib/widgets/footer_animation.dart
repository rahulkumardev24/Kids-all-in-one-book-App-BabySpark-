import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class FooterAnimation extends StatefulWidget {
  const FooterAnimation({super.key});

  @override
  State<FooterAnimation> createState() => _FooterAnimationState();
}

class _FooterAnimationState extends State<FooterAnimation> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Lottie.asset(
          "assets/lottie_animation_file/water_wave.json",
          fit: BoxFit.cover,
          width: size.width,
        ),

        Positioned(
          bottom: -20,
          child: Lottie.asset(
            "assets/lottie_animation_file/Fish Animation.json",
            fit: BoxFit.cover,
            width: size.width,
          ),
        ),

        Positioned(
            left: 0,
            bottom: -size.height * 0.06,
            child: Lottie.asset("assets/lottie_animation_file/fishing_new.json",
                height: size.height * 0.26, fit: BoxFit.cover)),

        /// --- Tree --- ///
        Positioned(
          right: -size.width * 0.25,
          bottom: -size.height * 0.06,
          child: Lottie.asset(
              "assets/lottie_animation_file/Palm Tree Leaf Animation.json",
              height: size.height * 0.3),
        ),
      ],
    );
  }
}
