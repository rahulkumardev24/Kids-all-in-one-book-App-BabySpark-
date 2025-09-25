import 'package:babyspark/domain/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        color: color.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(3.h),
                topRight: Radius.circular(3.h),
                bottomRight: Radius.circular(1.h) ,
               bottomLeft: Radius.circular(1.h)
            )),
        elevation: 0,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VxArc(
                height: isTablet ? 2.h : 1.h,
                arcType: VxArcType.convey,
                edge: VxEdge.top,
                child: Container(
                  height: isTablet ? 8.h : 5.h,
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

            ///------ Number display ------- ///
            Center(
              child: Text(
                '$number',
                style: myTextStyleCus(
                    fontSize: isTablet ? 6.h : 4.h,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
