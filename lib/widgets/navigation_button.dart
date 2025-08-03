import 'package:flutter/material.dart';

import '../helper/app_color.dart';

class NavigationButton extends StatelessWidget {
  final VoidCallback onTap;
  const NavigationButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: AppColors.primaryDark,
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(1.0, 1.5)),
                BoxShadow(
                    color: AppColors.textColor,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(-1.5, 2.0)),
              ]),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
