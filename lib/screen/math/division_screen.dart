import 'package:avatar_glow/avatar_glow.dart';
import 'package:babyspark/controller/division_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../domain/custom_text_style.dart';
import '../../helper/app_color.dart';
import '../../helper/dialog_helper.dart';
import '../../widgets/control_icon_button.dart';
import '../../widgets/math_screen_app_bar.dart';

class DivisionScreen extends StatefulWidget {
  const DivisionScreen({super.key});

  @override
  State<DivisionScreen> createState() => _DivisionScreenState();
}

class _DivisionScreenState extends State<DivisionScreen> {
  final DivisionController divisionController = Get.put(DivisionController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// ---- Set up completion callback ----- ///
      divisionController.onCompletion = () {
        DialogHelper.showMathCompletionDialog(
          context: context,
          onRestartGame: divisionController.restartGame,
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
              isTablet: isTablet(context),
              size: size,
              title: "Division",
              onPress: () {
                Navigator.pop(context);
                divisionController.stopAll();
              },
            ),
          ),
          backgroundColor: Colors.white,

          /// ----------- Body ------------ ///
          body: PopScope(
            onPopInvokedWithResult: (didPop, result) {
              divisionController.stopAll();
            },
            child: Obx(() {
              if (divisionController.divisionProblems.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              /// ------- get current problem --------- ///
              final currentProblem = divisionController.divisionProblems[
                  divisionController.currentProblemIndex.value];

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
                          /// ------------ Division Visualization ---------  ///
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              /// Total Items (Dividend)
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

                              /// Division Symbol
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "÷",
                                    style: myTextStyle40(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              /// Groups (Divisor)
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    // Show the divisor number
                                    SizedBox(height: 6.h),
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

                              /// Result (Quotient)
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    // Visual representation of the result
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
                                            color: divisionController
                                                        .isCorrect.value ||
                                                    accepted.isNotEmpty
                                                ? Colors.green
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: divisionController
                                                          .isCorrect.value ||
                                                      accepted.isNotEmpty
                                                  ? Colors.green
                                                  : AppColors.primaryDark,
                                              width: 3,
                                            ),
                                          ),
                                          child: Center(
                                            child: divisionController
                                                        .isCorrect.value ||
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
                                                        color: AppColors
                                                            .primaryDark,
                                                        size: 25,
                                                      ),
                                                      if (divisionController
                                                                  .currentProblemIndex
                                                                  .value ==
                                                              0 &&
                                                          !divisionController
                                                              .isCorrect.value)
                                                        Text(
                                                          "Drag here",
                                                          style: myTextStyle12(
                                                            fontColor: AppColors
                                                                .primaryDark,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                          ),
                                        );
                                      },
                                      onAcceptWithDetails: (details) {
                                        divisionController
                                            .checkAnswer(details.data);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    /// -------------  Linear Progress bar  ------------- ///
                    LinearProgressIndicator(
                      minHeight: 1.h,
                      value:
                          (divisionController.currentProblemIndex.value + 1) /
                              divisionController.divisionProblems.length,
                      backgroundColor: Colors.grey.shade400,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    SizedBox(height: 2.h),

                    /// ------------ Options --------------------- ///
                    Wrap(
                      spacing: 2.h,
                      children: divisionController.currentOptions.map((number) {
                        final isCorrectOption = number == correctAnswer;
                        final isSelected =
                            divisionController.selectedAnswer.value == number;

                        return Draggable<String>(
                          data: number,
                          feedback: Material(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: divisionController.showHint.value &&
                                        isCorrectOption
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
                              divisionController.checkAnswer(number);
                            },
                            child:
                                // If selected and correct - GREEN
                                (isSelected &&
                                        divisionController.isCorrect.value)
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
                                    : divisionController.showHint.value &&
                                            isCorrectOption
                                        ? AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            transform: divisionController
                                                    .vibrateCorrectOption.value
                                                ? Matrix4.translationValues(
                                                    divisionController.random
                                                                .nextDouble() *
                                                            16 -
                                                        8,
                                                    divisionController.random
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
                          onPressed: divisionController.goToPreviousProblem,
                          borderColor: Colors.grey.shade700,
                          isRounded: false,
                        ),
                        AvatarGlow(
                          glowColor: divisionController.isSpeaking.value
                              ? Colors.amber
                              : AppColors.primaryColor,
                          glowRadiusFactor: 0.4,
                          animate: divisionController.isSpeaking.value,
                          child: ControlIconButton(
                            icon: divisionController.isSpeaking.value
                                ? Icons.pause_rounded
                                : Icons.volume_up_rounded,
                            iconSize: 24,
                            color: divisionController.isSpeaking.value
                                ? Colors.amber
                                : AppColors.primaryDark,
                            onPressed: divisionController.toggleAutoPlay,
                            borderColor: Colors.grey.shade700,
                          ),
                        ),
                        ControlIconButton(
                          icon: Icons.arrow_forward_rounded,
                          iconSize: 24,
                          color: AppColors.primaryDark,
                          onPressed: divisionController.goToNextProblem,
                          isRounded: false,
                          borderColor: Colors.grey.shade700,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              );
            }),
          )),
    );
  }
}
