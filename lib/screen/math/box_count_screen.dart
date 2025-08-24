import 'dart:async';
import 'dart:math';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/utils/app_utils.dart';
import 'package:babyspark/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../helper/app_color.dart';

class BoxCountScreen extends StatefulWidget {
  const BoxCountScreen({super.key});

  @override
  State<BoxCountScreen> createState() => _BoxCountScreenState();
}

class _BoxCountScreenState extends State<BoxCountScreen> {
  final Random _random = Random();

  int boxCount = 0;
  List<int> options = [];
  int? selectedAnswer;
  bool? isCorrect;
  int questionIndex = 1;
  int totalQuestions = 10;
  int score = 0;
  List<Color> boxColors = [];

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    setState(() {
      boxCount = _random.nextInt(15) + 1;
      options = [];
      options.add(boxCount);

      ///------ Generate 3 wrong answers ----- ///
      while (options.length < 4) {
        int wrong = _random.nextInt(13) + 1;
        if (!options.contains(wrong)) {
          options.add(wrong);
        }
      }

      options.shuffle();
      selectedAnswer = null;
      isCorrect = null;
    });
  }

  void checkAnswer(int answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = (answer == boxCount);

      if (isCorrect!) {
        score++;
        AppUtils.playSound(fileName: "audio/correct.mp3", isMute: true);
      } else {
        AppUtils.playSound(fileName: "audio/wrong.mp3", isMute: true);
      }
    });

    // Show feedback dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              isCorrect! ? AppColors.softGreen : Colors.red.shade100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                  isCorrect!
                      ? "assets/lottie_animation_file/smiley emoji.json"
                      : "assets/lottie_animation_file/Crying emoji.json",
                  fit: BoxFit.cover),
              SizedBox(height: 2.h),
              Text(
                isCorrect! ? "Correct!" : "Wrong!",
                style: myTextStyle25(
                  fontWeight: FontWeight.bold,
                  fontColor: isCorrect! ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 1.h),
              isCorrect!
                  ? const SizedBox()
                  : Text(
                      "Correct answer : $boxCount",
                      style: myTextStyle18(),
                    ),
            ],
          ),
        );
      },
    );

    /// Close dialog and move to next question or show results after 1.2 seconds
    Timer(const Duration(milliseconds: 1200), () {
      Navigator.pop(context);

      if (questionIndex < totalQuestions) {
        setState(() {
          questionIndex++;
        });
        generateQuestion();
      } else {
        showGameCompletedDialog();
      }
    });
  }

  void showGameCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameCompletedDialog(
          score: score,
          wrongScore: totalQuestions - score,
          totalQuestions: totalQuestions,
          onRestart: restartGame,
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  /// Game Re start
  void restartGame() {
    Navigator.pop(context);
    setState(() {
      questionIndex = 1;
      score = 0;
    });
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        /// --------- Appbar --------------- ///
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: size.height * 0.2,
          backgroundColor: Colors.white,
          flexibleSpace: VxArc(
            height: 2.5.h,
            arcType: VxArcType.convey,
            child: Container(
              color: AppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavigationButton(onTap: () => Navigator.pop(context)),
                        Text(
                          "Count And Select Number",
                          style: myTextStyle21(),
                        ),

                        /// Progress bar and question counter - FIXED LAYOUT
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade500),
                              borderRadius: BorderRadiusGeometry.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.04,
                                        width: size.height * 0.04,
                                        child: CircularProgressIndicator(
                                          value: questionIndex / totalQuestions,
                                          strokeWidth: 4,
                                          backgroundColor:
                                              Colors.grey.withAlpha(70),
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                      Text(
                                        "$questionIndex/$totalQuestions",
                                        style: myTextStyle12(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Questions",
                                  style: myTextStyle21(
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Lottie.asset(
                      "assets/lottie_animation_file/Boy looking .json",
                      fit: BoxFit.cover,
                      height: size.height * 0.15,
                      width: size.height * 0.15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Text(
              "How many Ball do you see?",
              style: myTextStyle21(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.01),
            Expanded(
              flex: 4,
              child: Animate(
                effects: const [
                  BlurEffect(
                      duration: Duration(milliseconds: 500),
                      begin: Offset(5.0, 5.0),
                      end: Offset(0.0, 0.0))
                ],
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: List.generate(
                    boxCount,
                    (index) => Image.asset(
                            height: size.height * 0.09,
                            width: size.height * 0.09,
                            fit: BoxFit.cover,
                            "assets/images/ball.webp")
                        .animate()
                        .scale(duration: 200.ms, delay: (index * 100).ms)
                        .then()
                        .shake(duration: 300.ms),
                  ),
                ),
              ),
            ),

            /// Options
            Padding(
              padding: EdgeInsets.all(3.h),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 21,
                crossAxisSpacing: 21,
                childAspectRatio: 1.1,
                children: options.map((e) {
                  return FittedBox(
                    child: Animate(
                      effects: const [
                        FlipEffect(
                          delay: Duration(milliseconds: 500),
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        )
                      ],
                      child: SizedBox(
                        height: size.width * 0.3,
                        width: size.width * 0.3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryLight.withValues(alpha: 0.6),
                            elevation: 0,
                            side: const BorderSide(
                                width: 12, color: AppColors.primaryDark),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40)),
                            ),
                          ),
                          onPressed: selectedAnswer == null
                              ? () => checkAnswer(e)
                              : null,
                          child: Text(
                            e.toString(),
                            style: myTextStyle40(
                                fontFamily: "secondary",
                                fontColor: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameCompletedDialog extends StatelessWidget {
  final int score;
  final int wrongScore;
  final int totalQuestions;
  final VoidCallback onRestart;
  final VoidCallback onClose;

  const GameCompletedDialog({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRestart,
    required this.onClose,
    required this.wrongScore,
  });

  String _getScoreEmoji(int score, int total) {
    final percentage = score / total;

    if (percentage >= 0.8) {
      return 'assets/lottie_animation_file/Trophy.json';
    } else if (percentage >= 0.6) {
      return 'assets/lottie_animation_file/smiley emoji.json';
    } else if (percentage >= 0.4) {
      return 'assets/lottie_animation_file/Winking Emoji.json';
    } else {
      return 'assets/lottie_animation_file/Crying emoji.json';
    }
  }

  String _getScoreMessage(int score, int total) {
    final percentage = score / total;

    if (percentage >= 0.8) {
      return '🎉 Superstar!';
    } else if (percentage >= 0.6) {
      return '👍Great job!';
    } else if (percentage >= 0.4) {
      return '😐 Good try!';
    } else {
      return '😢 Try again!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ------- Title  ---------------- ///
            Text("Game Completed!", style: myTextStyle25()),
            SizedBox(height: 1.h),

            /// Show emoji according to score
            Lottie.asset(
                height: 50.w,
                width: 50.w,
                fit: BoxFit.cover,
                _getScoreEmoji(score, totalQuestions)),
            SizedBox(height: 1.h),

            Text(
              _getScoreMessage(score, totalQuestions),
              style: myTextStyle21(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            /// -------  Score Board  ---------------- ///
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.verified_user_rounded,
                          color: Colors.green, size: 8.h),
                      Text(
                        "$score",
                        style: Device.screenType == ScreenType.tablet
                            ? myTextStyle32()
                            : myTextStyle30(),
                      ),
                      Text(
                        "Correct",
                        style: myTextStyle25(fontColor: Colors.green),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.cancel, color: Colors.red, size: 8.h),
                      Text(
                        "$wrongScore",
                        style: Device.screenType == ScreenType.tablet
                            ? myTextStyle32()
                            : myTextStyle30(),
                      ),
                      Text(
                        "Wrong",
                        style: myTextStyle25(fontColor: Colors.red),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            /// --------- Divider ---------- ///
            const Divider(),

            /// ------- Control Button ------- ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Colors.grey.shade300),
                  child: Row(
                    children: [
                      const Icon(Icons.close_rounded,
                          color: Colors.black, size: 21),
                      SizedBox(width: 1.w),
                      Text("Close",
                          style: myTextStyle14(fontColor: Colors.black)),
                    ],
                  ),
                ),

                /// Restart Button
                ElevatedButton(
                  onPressed: onRestart,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent, elevation: 0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.restart_alt_rounded,
                        size: 21,
                        color: Colors.white,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "Play Again",
                        style: myTextStyle14(fontColor: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
