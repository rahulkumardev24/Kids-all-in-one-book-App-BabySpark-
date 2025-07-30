import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../domain/custom_text_style.dart';

class MyCategoriesCard extends StatelessWidget {
  final String title;
  final String animationPath;
  final Color color;
  final VoidCallback? onTap;

  const MyCategoriesCard({
    super.key,
    required this.color,
    required this.title,
    required this.animationPath,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            /// Animation with padding to ensure it fits
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Lottie.asset(
                  animationPath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            /// Title
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: myTextStyle18(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
