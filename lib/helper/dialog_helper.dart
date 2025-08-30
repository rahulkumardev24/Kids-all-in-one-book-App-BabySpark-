import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../domain/custom_text_style.dart';
import 'app_color.dart';

class DialogHelper {
  /// ------- Show Game Completion Dialog
  static void showMathCompletionDialog({
    required BuildContext context,
    required VoidCallback onRestartGame,
    required VoidCallback onExit,
    String title = "Congratulations!",
    String message = "You've completed all the addition problems!",
    String lottiePath = "assets/lottie_animation_file/monkey_dance.json",
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: myTextStyleCus(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontColor: AppColors.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                lottiePath,
                width: 20.h,
                height: 20.h,
                fit: BoxFit.cover,
              ),
              Text(
                message,
                style: myTextStyleCus(
                  fontSize: 18,
                  fontColor: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onExit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Exit",
                    style: myTextStyleCus(
                      fontSize: 16,
                      fontColor: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onRestartGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Play Again",
                    style: myTextStyleCus(
                      fontSize: 16,
                      fontColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
