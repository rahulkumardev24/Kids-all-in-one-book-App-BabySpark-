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
    required this.onTap,
  });

  bool _isLottie(String path) {
    return path.toLowerCase().endsWith('.json');
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet(BuildContext context) {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide >= 600;
    }

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
            /// Animation or Image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: _isLottie(animationPath)
                    ? Lottie.asset(
                  animationPath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                )
                    : Image.asset(
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
                  color: Colors.white.withOpacity(0.5),
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
                    style: isTablet(context)
                        ? myTextStyle30(fontWeight: FontWeight.bold)
                        : myTextStyle22(fontWeight: FontWeight.bold),
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
