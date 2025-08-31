import 'package:avatar_glow/avatar_glow.dart';
import 'package:babyspark/controller/subtraction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../domain/custom_text_style.dart';
import '../../helper/app_color.dart';
import '../../helper/dialog_helper.dart';
import '../../widgets/control_icon_button.dart';
import '../../widgets/math_screen_app_bar.dart';

class SubtractionScreen extends StatefulWidget {
  const SubtractionScreen({super.key});

  @override
  State<SubtractionScreen> createState() => _SubtractionScreenState();
}

class _SubtractionScreenState extends State<SubtractionScreen> {
  final SubtractionController subtractionController =
      Get.put(SubtractionController());


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// ---- Set up completion callback ----- ///
      subtractionController.onCompletion = () {
        DialogHelper.showMathCompletionDialog(
          context: context,
          onRestartGame: subtractionController.restartGame,
          onExit: () => Navigator.pop(context),
        );
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isTablet(BuildContext context) {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return SafeArea(
      child: Scaffold(

          /// ---- App bar -------- ///
          appBar: AppBar(
            toolbarHeight: size.height * 0.18,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.yellow,
            flexibleSpace: MathScreenAppBar(
                isTablet: isTablet(context), size: size, title: "Subtraction"),
          ),
          backgroundColor: Colors.white,

          /// ----------- Body ------------ ///
          body: Obx(() {
            if (subtractionController.subtractionProblems.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            /// ------- get current problem --------- ///
            final currentProblem = subtractionController.subtractionProblems[
                subtractionController.currentProblemIndex.value];

            /// -------- get correct answer --------- ///
            final correctAnswer = currentProblem['result'].toString();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      /// ------------ Subtraction Ball ---------  ///

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          /// First Ball
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: currentProblem['num1'],
                                  itemBuilder: (context, index) {
                                    return Image.asset(
                                      "assets/images/yellow_ball.webp",
                                      width: 6.h,
                                      height: 6.h,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  height: 8.h,
                                  width: 8.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryDark,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${currentProblem['num1']}",
                                      style: myTextStyle30(
                                        fontWeight: FontWeight.bold,
                                        fontColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// subtraction
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "-",
                                style: myTextStyle40(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          /// Second Ball
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: currentProblem['num2'],
                                  itemBuilder: (context, index) {
                                    return Image.asset(
                                      "assets/images/yellow_ball.webp",
                                      width: 6.h,
                                      height: 6.h,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  height: 8.h,
                                  width: 8.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryDark,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${currentProblem['num2']}",
                                        style: myTextStyle30(
                                          fontWeight: FontWeight.bold,
                                          fontColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Equal
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "=",
                                style: myTextStyle40(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          /// Result Ball
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                                  itemCount: currentProblem['result'],
                                  itemBuilder: (context, index) {
                                    return Image.asset(
                                      "assets/images/yellow_ball.webp",
                                      width: 6.h,
                                      height: 6.h,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                SizedBox(height: 1.h),
                                DragTarget<String>(
                                  builder: (context, accepted, rejected) {
                                    return Container(
                                      height: 8.h,
                                      width: 8.h,
                                      decoration: BoxDecoration(
                                        color: subtractionController.isCorrect.value ||
                                            accepted.isNotEmpty
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                          subtractionController.isCorrect.value ||
                                              accepted.isNotEmpty
                                              ? Colors.green
                                              : AppColors.primaryDark,
                                          width: 3,
                                        ),
                                      ),
                                      child: Center(
                                        child: subtractionController.isCorrect.value ||
                                            accepted.isNotEmpty
                                            ? Text(
                                          correctAnswer,
                                          style: myTextStyle30(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontColor: Colors.white,
                                          ),
                                        )
                                            : Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            const Icon(
                                              Icons
                                                  .question_mark_rounded,
                                              color: AppColors.primaryDark,
                                              size: 25,
                                            ),
                                            if (subtractionController
                                                .currentProblemIndex
                                                .value ==
                                                0 &&
                                                !subtractionController
                                                    .isCorrect.value)
                                              Text(
                                                "Drag here",
                                                style: myTextStyle12(
                                                  fontColor:
                                                  AppColors.primaryDark,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  onAcceptWithDetails: (details) {
                                    subtractionController.checkAnswer(details.data);
                                  },
                                ),

                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )),

                  SizedBox(height: 2.h,),



                  /// -------------  Liner Progress bar  ------------- ///
                  LinearProgressIndicator(
                    minHeight: 1.h,
                    value: (subtractionController.currentProblemIndex.value + 1) /
                        subtractionController.subtractionProblems.length,
                    backgroundColor: Colors.grey.shade400,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SizedBox(height: 2.h),


                  /// ------------ Options --------------------- ///
                  Wrap(
                    spacing: 2.h,
                    children: subtractionController.currentOptions.map((number) {
                      final isCorrectOption = number == correctAnswer;
                      final isSelected = subtractionController.selectedAnswer.value == number;

                      return Draggable<String>(
                        data: number,
                        feedback: Material(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color:
                              subtractionController.showHint.value && isCorrectOption
                                  ? Colors.amber.shade100
                                  : AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                number,
                                style: myTextStyle30(
                                  fontWeight: FontWeight.bold,
                                  fontColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              number,
                              style: myTextStyle30(
                                fontWeight: FontWeight.bold,
                                fontColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            subtractionController.checkAnswer(number);
                          },
                          child:
                          // If selected and correct - GREEN
                          (isSelected && subtractionController.isCorrect.value)
                              ? Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                              BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.green.shade800,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                number,
                                style: myTextStyle30(
                                  fontWeight: FontWeight.bold,
                                  fontColor: Colors.white,
                                ),
                              ),
                            ),
                          )

                          // If hint is shown and this is correct option - YELLOW with vibration
                              : subtractionController.showHint.value &&
                              isCorrectOption
                              ? AnimatedContainer(
                            duration: const Duration(
                                milliseconds: 100),
                            transform: subtractionController
                                .vibrateCorrectOption.value
                                ? Matrix4.translationValues(
                              subtractionController.random
                                  .nextDouble() *
                                  16 -
                                  8,
                              subtractionController.random
                                  .nextDouble() *
                                  16 -
                                  8,
                              0,
                            )
                                : Matrix4.identity(),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  number,
                                  style: myTextStyle30(
                                    fontWeight: FontWeight.bold,
                                    fontColor: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )

                          // Default state - NORMAL
                              : Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                              BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey.shade700,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                number,
                                style: myTextStyle30(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),


                  /// ----- Control Button ----------- ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ControlIconButton(
                        icon: Icons.arrow_back_rounded,
                        iconSize: 24,
                        color: AppColors.primaryDark,
                        onPressed: subtractionController.goToPreviousProblem,
                        borderColor: Colors.grey.shade700,
                        isRounded: false,
                      ),
                      AvatarGlow(
                        glowColor: subtractionController.isSpeaking.value
                            ? Colors.amber
                            : AppColors.primaryColor,
                        glowRadiusFactor: 0.4,
                        animate: subtractionController.isSpeaking.value,
                        child: ControlIconButton(
                          icon: subtractionController.isSpeaking.value
                              ? Icons.pause_rounded
                              : Icons.volume_up_rounded,
                          iconSize: 24,
                          color: subtractionController.isSpeaking.value
                              ? Colors.amber
                              : AppColors.primaryDark,
                          onPressed: subtractionController.toggleAutoPlay,
                          borderColor: Colors.grey.shade700,
                        ),
                      ),
                      ControlIconButton(
                        icon: Icons.arrow_forward_rounded,
                        iconSize: 24,
                        color: AppColors.primaryDark,
                        onPressed: subtractionController.goToNextProblem,
                        isRounded: false,
                        borderColor: Colors.grey.shade700,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            );
          })),
    );
  }
}
