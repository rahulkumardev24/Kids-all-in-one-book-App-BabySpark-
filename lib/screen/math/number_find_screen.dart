import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../domain/custom_text_style.dart';
import '../../helper/app_color.dart';
import '../../widgets/navigation_button.dart';

class NumberFindScreen extends StatefulWidget {
  const NumberFindScreen({super.key});

  @override
  State<NumberFindScreen> createState() => _NumberFindScreenState();
}

class _NumberFindScreenState extends State<NumberFindScreen> {
  final Random _randomNumber = Random();
  final AudioPlayer audioPlayer = AudioPlayer() ;
  late int randomQuestion;
  int currentQuestion = 1;
  int totalQuestions = 10;
  int score = 0;

  late List<String> optionsList;

  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    generateRandomNumber();
    optionsList = generateOptions(randomQuestion);
  }

  /// ---- Generate random number ---- ///
  generateRandomNumber() {
    randomQuestion = _randomNumber.nextInt(100);
  }

  /// ---- Generate Random Options ---- ///
  List<String> generateOptions(int correctAnswer) {
    final correct = correctAnswer.toString();
    final options = <String>[correct];

    while (options.length < 25) {
      int randomOption = _randomNumber.nextInt(100);
      if (!options.contains(randomOption.toString())) {
        options.add(randomOption.toString());
      }
    }
    options.shuffle();
    return options;
  }

  void checkAnswer(String selected) {
    setState(() {
      selectedAnswer = selected;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          selectedAnswer = null;
        });

        /// Correct 
        if (selected == randomQuestion.toString()) {
          audioPlayer.play(AssetSource("audio/correct.mp3"));
          score++;
          if (currentQuestion < totalQuestions) {
            setState(() {
              currentQuestion++;
              generateRandomNumber();
              optionsList = generateOptions(randomQuestion);
            });
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Game Completed!"),
                content: Text("Your score: $score/$totalQuestions"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        currentQuestion = 1;
                        score = 0;
                        generateRandomNumber();
                        optionsList = generateOptions(randomQuestion);
                      });
                    },
                    child: const Text("Play Again"),
                  ),
                ],
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /// ----------- Appbar ---------- ///
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: Get.height * 0.2,
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
                          "Find the Same Number",
                          style: myTextStyle21(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(100),
                          ),
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
                                        height: Get.height * 0.04,
                                        width: Get.height * 0.04,
                                        child: CircularProgressIndicator(
                                          value:
                                              currentQuestion / totalQuestions,
                                          strokeWidth: 4,
                                          backgroundColor:
                                              Colors.grey.withAlpha(70),
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                      Text(
                                        "$currentQuestion/$totalQuestions",
                                        style: myTextStyle12(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
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
                      height: Get.height * 0.15,
                      width: Get.height * 0.15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,

        /// ---------- Body ------------ ///
        body: Column(
          children: [
            SizedBox(height: 2.h),

            /// ----------- Number --------------- ///
            ClayContainer(
              width: Get.width * 0.9,
              borderRadius: 21.0,
              surfaceColor: Colors.white,
              curveType: CurveType.concave,
              spread: 2,
              child: Center(
                child: Text(
                  "$randomQuestion",
                  style: const TextStyle(
                      letterSpacing: 2,
                      color: AppColors.primaryDark,
                      fontFamily: "Secondary",
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(1.0, -2.5))
                      ],
                      fontSize: 100),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            /// --------- Grid ---------- Options ---------- ///
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: optionsList.length,
                itemBuilder: (context, index) {
                  String option = optionsList[index];
                  Color cardColor = Colors.white;

                  if (selectedAnswer != null) {
                    if (option == selectedAnswer) {
                      if (option == randomQuestion.toString()) {
                        cardColor = Colors.green;
                      } else {
                        cardColor = Colors.red;
                      }
                    }
                  }

                  return GestureDetector(
                    onTap: () => checkAnswer(option),
                    child: Card(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 1,
                      shadowColor: AppColors.primaryDark,
                      child: Center(
                        child: Text(
                          option,
                          style: myTextStyleCus(
                              fontColor: selectedAnswer == option
                                  ? Colors.white
                                  : Vx.gray700,
                              fontSize: 30),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
