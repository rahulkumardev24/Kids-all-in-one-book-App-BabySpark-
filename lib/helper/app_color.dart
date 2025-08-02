import 'package:flutter/material.dart';

class AppColors {
  /// Core Theme Colors
  static const Color primaryColor = Color(0xFFFFD6E8);
  static const Color primaryDark = Color(0xFFFB76B0);
  static const Color secondaryColor = Color(0xFFA7E9AF);
  static const Color accentColor = Color(0xFFFFF5BA);
  static const Color backgroundColor = Color(0xFFFDFDFD);

  /// Additional Baby-Friendly Pastels
  static const Color babyBlue = Color(0xFFB3E5FC);
  static const Color lavender = Color(0xFFE1BEE7);
  static const Color peach = Color(0xFFFFE0B2);
  static const Color softGreen = Color(0xFFD0F0C0);
  static const Color babyOrange = Color(0xFFFFD8A9);
  static const Color softViolet = Color(0xFFE6E6FA);
  static const Color bubbleGumPink = Color(0xFFFFC1CC);

  /// navigation
  static  Color navigationColor = Colors.grey.shade700;

  /// Text and Border Colors
  static const Color textColor = Color(0xFF444444);
  static const Color lightTextColor = Color(0xFF777777);
  static const Color borderColor = Color(0xFFE0E0E0);

  /// Gradient Helpers
  static const Gradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFFFF5BA), Color(0xFFFFD6E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient skyGradient = LinearGradient(
    colors: [Color(0xFFB3E5FC), Color(0xFFE1BEE7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
