import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';
import 'navigation_button.dart';

class PrimaryAppBar extends StatelessWidget {
  final String title;
  const PrimaryAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isTablet(BuildContext context) {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide >= 600;
    }

    return Stack(
      children: [
        ClipPath(
          clipper: _BabyWaveClipper(),
          child: Container(
            color: AppColors.primaryColor,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavigationButton(
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: myTextStyleCus(
                  fontSize: isTablet(context) ? 42 : 24,
                  fontFamily: "secondary",
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: size.width * 0.04,
          bottom: size.height * 0.03,
          child: Lottie.asset(
            "assets/lottie_animation_file/rabbit.json",
            height: size.height * 0.18,
            width: size.height * 0.18,
          ),
        ),
      ],
    );
  }
}

class _BabyWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.6,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
