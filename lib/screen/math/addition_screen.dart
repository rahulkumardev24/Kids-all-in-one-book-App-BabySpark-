import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/service/tts_service.dart';
import 'package:babyspark/widgets/control_icon_button.dart';
import 'package:babyspark/widgets/navigation_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';

import '../../helper/app_color.dart';

class AdditionScreen extends StatefulWidget {
  const AdditionScreen({super.key});

  @override
  State<AdditionScreen> createState() => _AdditionScreenState();
}

class _AdditionScreenState extends State<AdditionScreen> {
  final List<Map<String, dynamic>> _additionProblems = [
    {'num1': 1, 'num2': 1, 'result': 2},
    {'num1': 1, 'num2': 2, 'result': 3},
    {'num1': 1, 'num2': 3, 'result': 4},
    {'num1': 1, 'num2': 4, 'result': 5},
    {'num1': 1, 'num2': 5, 'result': 6},
    {'num1': 2, 'num2': 2, 'result': 4},
    {'num1': 2, 'num2': 3, 'result': 5},
    {'num1': 2, 'num2': 4, 'result': 6},
    {'num1': 2, 'num2': 5, 'result': 7},
    {'num1': 3, 'num2': 3, 'result': 6},
    {'num1': 3, 'num2': 4, 'result': 7},
    {'num1': 3, 'num2': 5, 'result': 8},
    {'num1': 4, 'num2': 4, 'result': 8},
    {'num1': 4, 'num2': 5, 'result': 9},
    {'num1': 5, 'num2': 5, 'result': 10},
  ];

  int _currentProblemIndex = 0;
  bool _isAutoPlaying = false;
  bool _isSpeaking = false;
  int _speechSessionId = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _effectsPlayer = AudioPlayer();

  // Variables for drag and drop
  bool _isCorrect = false;
  bool _showCelebration = false;
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
      // Generate options for the first problem
      final correctAnswer =
          _additionProblems[_currentProblemIndex]['result'].toString();
      _currentOptions = _generateOptions(correctAnswer);
      _startAutoPlayWithSpeech();
      _startHintTimer();
    });
  }

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

  void _goToNextProblem() {
    if (_currentProblemIndex < _additionProblems.length - 1) {
      setState(() {
        _currentProblemIndex++;
        _isCorrect = false;
        _showCelebration = false;
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
    }
  }

  void _goToPreviousProblem() {
    if (_currentProblemIndex > 0) {
      setState(() {
        _currentProblemIndex--;
        _isCorrect = false;
        _showCelebration = false;
        _showHint = false;
        _vibrateAnswerBox = false;
        _vibrateCorrectOption = false;
      });

      // Generate options for the previous problem
      final correctAnswer =
          _additionProblems[_currentProblemIndex]['result'].toString();
      _currentOptions = _generateOptions(correctAnswer);

      _hintTimer?.cancel();
      _vibrationTimer?.cancel();
      _startHintTimer();
      _startAutoPlayWithSpeech();
    }
  }

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

  void _checkAnswer(String draggedNumber) {
    final problem = _additionProblems[_currentProblemIndex];
    final correctAnswer = problem['result'].toString();

    if (draggedNumber == correctAnswer) {
      // Correct answer
      setState(() {
        _isCorrect = true;
        _showCelebration = true;
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

    IconData getIcon() {
      if (_isAutoPlaying) return Icons.pause_rounded;
      if (_isSpeaking) return Icons.volume_up_rounded;
      return Icons.volume_up_rounded;
    }

    Color getIconColor() {
      if (_isSpeaking) return Colors.amber;
      return const Color(0xFF01579B);
    }

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
        body: Stack(
          children: [
            Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: LinearProgressIndicator(
                    value:
                        (_currentProblemIndex + 1) / _additionProblems.length,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(currentColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
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
                ),

                const SizedBox(height: 20),

                // Addition problem display
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Visual representation with objects
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < currentProblem['num1']; i++)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  "assets/images/apple.png",
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "+",
                              style: myTextStyle40(
                                fontWeight: FontWeight.bold,
                                fontColor: currentColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < currentProblem['num2']; i++)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  "assets/images/apple.png",
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Hint message
                        if (_showHint && !_isCorrect)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber),
                            ),
                            child: Text(
                              "Drag ${correctAnswer} here!",
                              style: myTextStyle18(
                                fontWeight: FontWeight.bold,
                                fontColor: Colors.amber.shade800,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Equation with drag target
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: currentColor, width: 3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${currentProblem['num1']}",
                                style: myTextStyle30(
                                  fontWeight: FontWeight.bold,
                                  fontColor: currentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "+",
                                style: myTextStyle30(
                                  fontWeight: FontWeight.bold,
                                  fontColor: currentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${currentProblem['num2']}",
                                style: myTextStyle30(
                                  fontWeight: FontWeight.bold,
                                  fontColor: currentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "=",
                                style: myTextStyle30(
                                  fontWeight: FontWeight.bold,
                                  fontColor: currentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Apply the same animation to the correct answer box
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
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: _isCorrect
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(15),
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
                                                  fontWeight: FontWeight.bold,
                                                  fontColor: Colors.white,
                                                ),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                        fontColor: currentColor,
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

                        const SizedBox(height: 30),

                        // Answer options (draggable numbers)
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
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
                                      duration:
                                          const Duration(milliseconds: 100),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                      ],
                    ),
                  ),
                ),

                /// --- Navigation controls Button --- ///
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ControlIconButton(
                        icon: Icons.arrow_back_rounded,
                        iconSize: 24,
                        color: const Color(0xFF01579B),
                        onPressed: _goToPreviousProblem,
                        isRounded: true,
                        borderColor: Colors.grey.shade700,
                      ),
                      AvatarGlow(
                        glowColor: _isSpeaking
                            ? Colors.amber
                            : const Color(0xFF01579B),
                        glowRadiusFactor: 0.4,
                        animate: _isSpeaking,
                        child: ControlIconButton(
                          icon: getIcon(),
                          iconSize: 24,
                          color: getIconColor(),
                          onPressed: _toggleAutoPlay,
                          borderColor: Colors.grey.shade700,
                        ),
                      ),
                      ControlIconButton(
                        icon: Icons.arrow_forward_rounded,
                        iconSize: 24,
                        color: const Color(0xFF01579B),
                        onPressed: _goToNextProblem,
                        borderColor: Colors.grey.shade700,
                        isRounded: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Celebration animation
            if (_showCelebration)
              IgnorePointer(
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/celebration.gif",
                          width: 200,
                          height: 200,
                        ),
                        Text(
                          "Great Job!",
                          style: myTextStyle30(
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
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
