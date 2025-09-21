import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:babyspark/service/tts_service.dart';
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
  final AudioPlayer audioPlayer = AudioPlayer();
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
    String speakNumber = "Find Number $randomQuestion ";
    Future.delayed(const Duration(milliseconds: 800), () {
      TTSService.speak(speakNumber);
    });
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
        } else {
          audioPlayer.play(AssetSource("audio/wrong.mp3"));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet(BuildContext context) {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// ----------- Number --------------- ///
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 0.5.h,
                  )),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(21))),
                  ),
                  Container(
                    width: Get.width * 0.6,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadiusGeometry.all(Radius.circular(21)),
                      gradient: LinearGradient(
                          colors: [Colors.black87, Colors.black]),
                    ),
                    child: Center(
                      child: Text(
                        "$randomQuestion",
                        style: TextStyle(
                          letterSpacing: 2,
                          color: AppColors.primaryDark,
                          fontFamily: "Secondary",
                          fontSize: isTablet(context) ? 13.h : 11.h,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(21))),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 0.5.h,
                  )),
                ],
              ),

              SizedBox(height: 2.h),

              /// --------- Grid ---------- Options ---------- ///
              GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.12.h,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
