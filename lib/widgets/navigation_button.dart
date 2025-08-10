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
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.navigationColor,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 1),
              ),
              BoxShadow(
                color: AppColors.navigationColor,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            // Center the icon
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey.shade700,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
