import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/service/tts_service.dart';
import 'package:babyspark/widgets/control_icon_button.dart';
import 'package:babyspark/widgets/navigation_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';

import '../../helper/app_color.dart';

class AdditionScreen extends StatefulWidget {
  const AdditionScreen({super.key});

  @override
  State<AdditionScreen> createState() => _AdditionScreenState();
}

class _AdditionScreenState extends State<AdditionScreen> {
  final List<Map<String, dynamic>> _additionProblems = [];
  int _currentProblemIndex = 0;
  bool _isAutoPlaying = false;
  bool _isSpeaking = false;
  int _speechSessionId = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _effectsPlayer = AudioPlayer();

  // Variables for drag and drop
  bool _isCorrect = false;
  Timer? _hintTimer;
  bool _showHint = false;
  bool _vibrateAnswerBox = false;
  bool _vibrateCorrectOption = false;
  List<String> _currentOptions = [];
  Timer? _vibrationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Generate random addition problems
      _generateRandomProblems();

      /// ------ Generate options for the first problem -------- ///
      final correctAnswer =
          _additionProblems[_currentProblemIndex]['result'].toString();
      _currentOptions = _generateOptions(correctAnswer);
      _startAutoPlayWithSpeech();
      _startHintTimer();
    });
  }

  /// ---- Generate random addition problems ---- ///
  void _generateRandomProblems() {
    final random = Random();
    _additionProblems.clear();

    // Generate 15 random problems
    for (int i = 0; i < 15; i++) {
      int maxRange;

      // For first 5 problems, use numbers 1-4
      if (i < 5) {
        maxRange = 4;
      } else {
        maxRange = 7;
      }

      int num1 = 1 + random.nextInt(maxRange);
      int num2 = 1 + random.nextInt(maxRange);
      _additionProblems
          .add({'num1': num1, 'num2': num2, 'result': num1 + num2});
    }
  }

  /// ---- Start Hint Timer ---- ///
  void _startHintTimer() {
    _hintTimer?.cancel();
    _hintTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_isCorrect) {
        setState(() {
          _showHint = true;
          _vibrateCorrectOption = true;
        });
        // Play hint sound
        _effectsPlayer.play(AssetSource("audio/hint.mp3"));

        // Start vibration animation for correct option
        _startVibrationAnimation();
      }
    });
  }

  /// --- Vibration Animation ---- ///
  void _startVibrationAnimation() {
    _vibrationTimer?.cancel();
    const vibrationDuration = Duration(seconds: 3); // Vibrate for 3 seconds
    const vibrationInterval =
        Duration(milliseconds: 100); // Vibrate every 100ms

    _vibrationTimer = Timer.periodic(vibrationInterval, (timer) {
      if (mounted) {
        setState(() {
          // This will trigger the animation by changing the state
        });
      }
    });

    // Stop vibration after the duration
    Future.delayed(vibrationDuration, () {
      if (mounted) {
        setState(() {
          _vibrateCorrectOption = false;
        });
      }
      _vibrationTimer?.cancel();
    });
  }

  /// ----- Go to next problem ---- ///
  void _goToNextProblem() {
    if (_currentProblemIndex < _additionProblems.length - 1) {
      setState(() {
        _currentProblemIndex++;
        _isCorrect = false;
        _showHint = false;
        _vibrateAnswerBox = false;
        _vibrateCorrectOption = false;
      });

      // Generate new options for the next problem
      final correctAnswer =
          _additionProblems[_currentProblemIndex]['result'].toString();
      _currentOptions = _generateOptions(correctAnswer);

      _hintTimer?.cancel();
      _vibrationTimer?.cancel();
      _startHintTimer();
      _startAutoPlayWithSpeech();
    } else {
      // If we're at the last problem, generate new random problems
      _generateRandomProblems();
      setState(() {
        _currentProblemIndex = 0;
        _isCorrect = false;
        _showHint = false;
        _vibrateAnswerBox = false;
        _vibrateCorrectOption = false;
      });

      // Generate new options for the first problem
      final correctAnswer =
          _additionProblems[_currentProblemIndex]['result'].toString();
      _currentOptions = _generateOptions(correctAnswer);

      _hintTimer?.cancel();
      _vibrationTimer?.cancel();
      _startHintTimer();
      _startAutoPlayWithSpeech();
    }
  }

  /// -------- Go to previous problem -------- ///
  void _goToPreviousProblem() {
    if (_currentProblemIndex > 0) {
      setState(() {
        _currentProblemIndex--;
        _isCorrect = false;
        _showHint = false;
        _vibrateAnswerBox = false;
        _vibrateCorrectOption = false;
      });

      /// ---- Generate options for the previous problem ------- ///
      final correctAnswer =
          _additionProblems[_currentProblemIndex]['result'].toString();
      _currentOptions = _generateOptions(correctAnswer);

      _hintTimer?.cancel();
      _vibrationTimer?.cancel();
      _startHintTimer();
      _startAutoPlayWithSpeech();
    }
  }

  /// ---------- Toggle Auto Play ----------- ///
  void _toggleAutoPlay() {
    if (_isAutoPlaying) {
      _stopAutoPlay();
    } else {
      _startAutoPlayWithSpeech();
    }
  }

  void _invalidateSpeechSession() {
    _speechSessionId++;
  }

  void _startAutoPlayWithSpeech() {
    _stopAutoPlay();

    _speechSessionId++;
    final int session = _speechSessionId;

    if (mounted) {
      setState(() {
        _isSpeaking = true;
        _isAutoPlaying = true;
      });
    }

    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource("audio/table_background.mp3"), volume: 0.2);
    _speakCurrentProblem(session);
  }

  /// ------ Stop Auto Play ------- ///
  void _stopAutoPlay() {
    _invalidateSpeechSession();

    try {
      TTSService.stop();
    } catch (_) {}

    _audioPlayer.stop();

    if (mounted) {
      setState(() {
        _isAutoPlaying = false;
        _isSpeaking = false;
      });
    }
  }

  Future<void> _speakCurrentProblem(int session) async {
    if (session != _speechSessionId) return;

    final problem = _additionProblems[_currentProblemIndex];
    final num1 = problem['num1'];
    final num2 = problem['num2'];
    final result = problem['result'];
    final line = "$num1 plus $num2 equals $result";

    if (session != _speechSessionId) return;

    if (mounted) {
      setState(() {
        _isSpeaking = true;
      });
    }

    try {
      await TTSService.stop();
    } catch (_) {}

    try {
      await TTSService.speak(line);
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      await Future.delayed(const Duration(seconds: 3));
    }

    if (!mounted || session != _speechSessionId || !_isAutoPlaying) {
      return;
    }

    if (mounted) {
      setState(() {
        _isSpeaking = false;
        _isAutoPlaying = false;
      });
    }
  }

  /// ----- Check Answer ------- ///
  void _checkAnswer(String draggedNumber) {
    final problem = _additionProblems[_currentProblemIndex];
    final correctAnswer = problem['result'].toString();

    if (draggedNumber == correctAnswer) {
      // Correct answer
      setState(() {
        _isCorrect = true;
        _showHint = false;
        _vibrateAnswerBox = false;
        _vibrateCorrectOption = false;
      });

      // Play success sound
      _effectsPlayer.play(AssetSource("audio/success.mp3"));

      // Auto move to next problem after delay
      Future.delayed(const Duration(seconds: 2), () {
        if (_currentProblemIndex < _additionProblems.length - 1) {
          _goToNextProblem();
        } else {
          // If it's the last problem, generate new problems and reset
          _generateRandomProblems();
          setState(() {
            _currentProblemIndex = 0;
            _isCorrect = false;
            _showHint = false;
            _vibrateAnswerBox = false;
            _vibrateCorrectOption = false;
          });

          // Generate options for the first problem
          final correctAnswer =
              _additionProblems[_currentProblemIndex]['result'].toString();
          _currentOptions = _generateOptions(correctAnswer);

          _hintTimer?.cancel();
          _vibrationTimer?.cancel();
          _startHintTimer();
          _startAutoPlayWithSpeech();
        }
      });
    } else {
      // Wrong answer
      _effectsPlayer.play(AssetSource("audio/error.mp3"));

      // Vibrate the answer box
      setState(() {
        _vibrateAnswerBox = true;
        _showHint = true;
        _vibrateCorrectOption = true;
      });

      // Start vibration animation for correct option
      _startVibrationAnimation();

      // Stop vibration after a short duration
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _vibrateAnswerBox = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _hintTimer?.cancel();
    _vibrationTimer?.cancel();
    _audioPlayer.dispose();
    _effectsPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProblem = _additionProblems[_currentProblemIndex];
    final currentColor = AppColors.primaryDark;
    final size = MediaQuery.of(context).size;

    final correctAnswer = currentProblem['result'].toString();

    return SafeArea(
      child: Scaffold(
        /// ----- App bar ---- ///
        appBar: AppBar(
          toolbarHeight: size.height * 0.13,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: VxArc(
            height: 20,
            arcType: VxArcType.convey,
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFF0288D1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NavigationButton(
                              onTap: () => Navigator.pop(context),
                            ),
                            Text(
                              "Addition Fun",
                              style: myTextStyle21(
                                fontFamily: "primary",
                                fontColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        backgroundColor: const Color(0xFFE1F5FE),

        /// ----------------- Body -------------------- ///
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  // Progress indicator
                  LinearProgressIndicator(
                    value:
                        (_currentProblemIndex + 1) / _additionProblems.length,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(currentColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Problem ${_currentProblemIndex + 1} of ${_additionProblems.length}",
                        style: myTextStyle14(
                          fontColor: const Color(0xFF0277BD),
                        ),
                      ),
                      Text(
                        "${((_currentProblemIndex + 1) / _additionProblems.length * 100).round()}%",
                        style: myTextStyle14(
                          fontWeight: FontWeight.bold,
                          fontColor: const Color(0xFF0288D1),
                        ),
                      ),
                    ],
                  ),

                  /// ------- Addition Section (Bear) ---- ////
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// ------------ First Bear ------------ ///
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
                                          "assets/images/trady_bear.png",
                                          width: 6.h,
                                          height: 6.h,
                                          fit: BoxFit.cover,
                                        );
                                      }),

                                  SizedBox(
                                    height: 1.h,
                                  ),

                                  /// ----- First Number ---- ///
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
                            Expanded(
                              child: Text(
                                "+",
                                style: myTextStyle40(
                                  fontWeight: FontWeight.bold,
                                  fontColor: currentColor,
                                ),
                              ),
                            ),
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
                                      itemCount: currentProblem['num2'],
                                      itemBuilder: (context, index) {
                                        return Image.asset(
                                          "assets/images/trady_bear.png",
                                          width: 6.h,
                                          height: 6.h,
                                          fit: BoxFit.cover,
                                        );
                                      }),
                                  SizedBox(
                                    height: 1.h,
                                  ),
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
                            Expanded(
                              child: Text(
                                "=",
                                style: myTextStyle40(
                                  fontWeight: FontWeight.bold,
                                  fontColor: currentColor,
                                ),
                              ),
                            ),
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
                                        "assets/images/trady_bear.png",
                                        width: 6.h,
                                        height: 6.h,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    transform: _vibrateAnswerBox
                                        ? Matrix4.translationValues(
                                            Random().nextInt(6) - 3,
                                            Random().nextInt(6) - 3,
                                            0,
                                          )
                                        : Matrix4.identity(),
                                    child: DragTarget<String>(
                                      builder: (
                                        BuildContext context,
                                        List<dynamic> accepted,
                                        List<dynamic> rejected,
                                      ) {
                                        return Container(
                                          height: 8.h,
                                          width: 8.h,
                                          decoration: BoxDecoration(
                                            color: _isCorrect
                                                ? Colors.green
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: _isCorrect
                                                  ? Colors.green
                                                  : currentColor,
                                              width: 3,
                                            ),
                                          ),
                                          child: Center(
                                            child: _isCorrect
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
                                                      Icon(
                                                        Icons.arrow_circle_up,
                                                        color: currentColor,
                                                        size: 25,
                                                      ),
                                                      if (_currentProblemIndex ==
                                                              0 &&
                                                          !_isCorrect)
                                                        Text(
                                                          "Drag here",
                                                          style: myTextStyle12(
                                                            fontColor:
                                                                currentColor,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                          ),
                                        );
                                      },
                                      onAccept: (data) {
                                        _checkAnswer(data);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5.h),

                  /// --------- Answer options ---------- ///
                  Wrap(
                    spacing: 2.h,
                    children: _currentOptions.map((number) {
                      final isCorrectOption = number == correctAnswer;
                      return Draggable<String>(
                        data: number,
                        feedback: Material(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: _showHint && isCorrectOption
                                  ? Colors.amber.shade100
                                  : currentColor,
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

                        /// --- When dragging --- ///
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

                        child: _showHint && isCorrectOption
                            ? AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                transform: _vibrateCorrectOption
                                    ? Matrix4.translationValues(
                                        Random().nextInt(6) - 3,
                                        Random().nextInt(6) - 3,
                                        0,
                                      )
                                    : Matrix4.identity(),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 3,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      number,
                                      style: myTextStyle30(
                                        fontWeight: FontWeight.bold,
                                        fontColor: currentColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: _showHint && isCorrectOption
                                      ? Colors.amber.shade100
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: _showHint && isCorrectOption
                                        ? Colors.amber
                                        : currentColor,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    number,
                                    style: myTextStyle30(
                                      fontWeight: FontWeight.bold,
                                      fontColor: currentColor,
                                    ),
                                  ),
                                ),
                              ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),

                  /// --- Navigation controls Button --- ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ControlIconButton(
                        icon: Icons.arrow_back_rounded,
                        iconSize: 24,
                        color: AppColors.primaryDark,
                        onPressed: _goToPreviousProblem,
                        borderColor: Colors.grey.shade700,
                        isRounded: false,
                      ),
                      AvatarGlow(
                        glowColor:
                            _isSpeaking ? Colors.amber : AppColors.primaryColor,
                        glowRadiusFactor: 0.4,
                        animate: _isSpeaking,
                        child: ControlIconButton(
                          icon: _isSpeaking
                              ? Icons.pause_rounded
                              : Icons.volume_up_rounded,
                          iconSize: 24,
                          color: _isSpeaking
                              ? Colors.amber
                              : AppColors.primaryDark,
                          onPressed: _toggleAutoPlay,
                          borderColor: Colors.grey.shade700,
                        ),
                      ),
                      ControlIconButton(
                        icon: Icons.arrow_forward_rounded,
                        iconSize: 24,
                        color: AppColors.primaryDark,
                        onPressed: _goToNextProblem,
                        isRounded: false,
                        borderColor: Colors.grey.shade700,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 2.h,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _generateOptions(String correctAnswer) {
    final correct = int.parse(correctAnswer);
    final options = <String>[correctAnswer];

    // Generate 3 random wrong answers
    while (options.length < 4) {
      int randomOption;
      do {
        // Generate a random number between 1 and 10
        randomOption = 1 + Random().nextInt(10);
      } while (
          options.contains(randomOption.toString()) || randomOption == correct);

      options.add(randomOption.toString());
    }

    // Shuffle the options
    options.shuffle();
    return options;
  }
}
