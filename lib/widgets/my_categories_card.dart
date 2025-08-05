import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    bool isTablet(BuildContext context) {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide >= 600;
    }

    final size = MediaQuery.of(context).size;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1.5 , color: Colors.grey.shade500)
        ),
        child: Stack(
          children: [
            /// Animation or Image
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Image.asset(
                      animationPath,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Container(
                    width: size.width,
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
                        style: isTablet(context)
                            ? myTextStyle30(fontWeight: FontWeight.bold)
                            : myTextStyle22(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
