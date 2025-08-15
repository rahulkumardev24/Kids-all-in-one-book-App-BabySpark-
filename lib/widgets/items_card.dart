import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';

class ItemsCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isTablet;


  const ItemsCard(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.isTablet,
   });

  @override
  Widget build(BuildContext context) {
    String firstLetter = title.isNotEmpty ? title[0].toUpperCase() : "?";
    final size = MediaQuery.of(context).size;

    return VxArc(
      height: 20,
      edge: VxEdge.top,
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadiusGeometry.only(
                topRight: Radius.circular(200),
                bottomRight: Radius.circular(200),
                topLeft: Radius.circular(200))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: imagePath,
              height: size.width * 0.4,
              width: size.width * 0.4,
              fit: BoxFit.contain,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: Text(
                  firstLetter,
                  style: myTextStyleCus(
                    fontSize: isTablet ? 150 : 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
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
            const SizedBox(height: 8),

            /// --- Title --- ///
            Text(
              title,
              style: myTextStyleCus(
                  fontSize: isTablet ? 60 : 22,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
