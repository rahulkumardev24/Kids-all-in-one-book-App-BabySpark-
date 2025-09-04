import 'package:flutter/material.dart';

import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';

class SimpleTextButton extends StatelessWidget {
  final VoidCallback onPress;
  final String btnText;
  final Color btnBackgroundColor;
  final double btnBorderRadius;
  final Color fontColor;
  const SimpleTextButton(
      {super.key,
      required this.onPress,
      required this.btnText,
      this.btnBackgroundColor = AppColors.primaryDark,
      this.btnBorderRadius = 10,
      this.fontColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(btnBorderRadius)),
      ),
      child: Text(
        btnText,
        style: myTextStyle18(fontColor: fontColor),
      ),
    );
  }
}
