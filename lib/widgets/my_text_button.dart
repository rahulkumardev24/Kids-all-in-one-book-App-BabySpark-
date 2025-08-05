import 'package:babyspark/domain/custom_text_style.dart';
import 'package:flutter/material.dart';

import '../helper/app_color.dart';

class MyTextButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onPress;
  const MyTextButton({super.key, required this.btnText, required this.onPress});

  @override
  Widget build(BuildContext context) {
    bool isTablet(BuildContext context) {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return InkWell(
      onTap: onPress,
      child: Ink(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: AppColors.primaryDark),
            color: AppColors.primaryColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Text(
            btnText,
            style: isTablet(context) ? myTextStyle25() : myTextStyle21(),
          ),
        ),
      ),
    );
  }
}
