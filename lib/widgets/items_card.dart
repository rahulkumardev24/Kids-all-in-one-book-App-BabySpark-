import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';

class ItemsCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isTablet;

  const ItemsCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    String firstLetter = title.isNotEmpty ? title[0].toUpperCase() : "?";
    final size = MediaQuery.of(context).size;

    /// --- Card --- ///
    return VxArc(
      height: size.height * 0.02,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: size.height,
              width: size.height,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.8),
                  borderRadius: const BorderRadiusGeometry.only(
                      topRight: Radius.circular(400),
                      bottomRight: Radius.circular(100),
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(200))),
            ),
          ),

          /// --- Title --- ///
          Positioned(
            bottom: size.height * 0.03,
            child: FittedBox(
              child: Text(
                title,
                style: myTextStyleCus(
                    fontSize: isTablet ? 3.h : 3.h,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Positioned(
            top: -size.width * 0.00,
            right: 0,
            child: CachedNetworkImage(
              imageUrl: imagePath,
              height: isTablet ? size.width * 0.2 : size.width * 0.35,
              width: isTablet ? size.width * 0.2 : size.width * 0.35,
              fit: BoxFit.contain,
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: Text(
                  firstLetter,
                  style: myTextStyleCus(
                    fontSize: isTablet ? 130 : 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                alignment: Alignment.center,
                child: Text(
                  firstLetter,
                  style: myTextStyleCus(
                    fontSize: isTablet ? 150 : 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
