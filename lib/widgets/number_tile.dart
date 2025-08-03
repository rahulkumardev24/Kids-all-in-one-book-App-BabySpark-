import 'package:babyspark/domain/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class NumberTile extends StatelessWidget {
  final int number;
  final Color color;
  final VoidCallback onTap;
  final bool isTablet;

  const NumberTile({
    super.key,
    required this.number,
    required this.color,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        color: color.withValues(alpha: 0.8),
        elevation: 0,
        child: Stack(
          children: [
            // Background arc effect
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VxArc(
                height: size.height * 0.01,
                arcType: VxArcType.convey,
                edge: VxEdge.top,
                child: Container(
                  height: size.height * 0.05,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            // Number display
            Center(
              child: Text(
                '$number',
                style: isTablet
                    ? myTextStyle32(
                        fontWeight: FontWeight.bold,
                  fontColor: Colors.white

                      )
                    : myTextStyle28(
                        fontWeight: FontWeight.w700,
                  fontColor: Colors.white
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
