import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_color.dart';
import 'package:flutter/material.dart';

import '../../widgets/navigation_button.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Daily Challenge",
            style: myTextStyle21(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primaryDark,
          leading: NavigationButton(onTap: () {
            Navigator.pop(context);
          }),
        ),
        body: Center(
          child: Image.asset(
            "assets/images/coming_soon.png",
            height: size.height * 0.2,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
