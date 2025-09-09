import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../service/tts_service.dart';

class SubtractionController extends GetxController {
  final subtractionProblems = <Map<String, dynamic>>[].obs;
  final currentProblemIndex = 0.obs;
  final isAutoPlaying = false.obs;
  final isSpeaking = false.obs;
  final isCorrect = false.obs;
  final showHint = false.obs;
  final vibrateAnswerBox = false.obs;
  final vibrateCorrectOption = false.obs;
  final currentOptions = <String>[].obs;
  final selectedAnswer = ''.obs;

  /// Completion callback
  VoidCallback? onCompletion;

  /// Audio players
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer effectsPlayer = AudioPlayer();

  // Timers
  Timer? hintTimer;
  Timer? vibrationTimer;
  int speechSessionId = 0;
  final Random random = Random();

  @override
  void onInit() {
    super.onInit();
    generateRandomProblems();
    final correctAnswer =
        subtractionProblems[currentProblemIndex.value]['result'].toString();
    currentOptions.value = generateOptions(correctAnswer);
    startAutoPlayWithSpeech();
    startHintTimer();
  }

  @override
  void onClose() {
    stopAutoPlay();
    hintTimer?.cancel();
    vibrationTimer?.cancel();
    audioPlayer.dispose();
    effectsPlayer.dispose();
    super.onClose();
  }

  /// Generate Random Problem
  void generateRandomProblems() {
    subtractionProblems.clear();

    for (int i = 0; i < 15; i++) {
      int num1, num2;

      if (i < 5) {
        // For first 5 problems: ensure meaningful subtraction (difference >= 1)
        do {
          num1 = 2 + random.nextInt(4); // 2-5 (minimum 2 to ensure num1 > num2)
          num2 = 1 + random.nextInt(num1 - 1); // 1 to (num1 - 1)
        } while (num1 - num2 < 1); // Ensure difference is at least 1
      } else if (i < 10) {
        // For next 5 problems: medium difficulty
        do {
          num1 = 5 + random.nextInt(6); // 5-10
          num2 = 2 + random.nextInt(num1 - 3); // 2 to (num1 - 2)
        } while (num1 - num2 < 2); // Ensure difference is at least 2
      } else {
        // For last 5 problems: harder problems
        do {
          num1 = 8 + random.nextInt(7); // 8-14
          num2 = 3 + random.nextInt(num1 - 5); // 3 to (num1 - 3)
        } while (num1 - num2 < 3); // Ensure difference is at least 3
      }

      subtractionProblems
          .add({'num1': num1, 'num2': num2, 'result': num1 - num2});
    }
  }

  void checkAnswer(String selectedOption) {
    selectedAnswer.value = selectedOption;

    final problem = subtractionProblems[currentProblemIndex.value];
    final correctAnswer = problem['result'].toString();

    if (selectedOption == correctAnswer) {
      isCorrect.value = true;
      showHint.value = false;
      vibrateAnswerBox.value = false;
      vibrateCorrectOption.value = false;

      effectsPlayer.play(AssetSource("audio/correct.mp3"));

      Future.delayed(const Duration(seconds: 1), () {
        if (currentProblemIndex.value < subtractionProblems.length - 1) {
          goToNextProblem();
        } else {
          // Trigger completion callback
          if (onCompletion != null) {
            onCompletion!();
          }
        }
        selectedAnswer.value = '';
      });
    } else {
      effectsPlayer.play(AssetSource("audio/wrong.mp3"));

      vibrateAnswerBox.value = true;
      showHint.value = true;
      vibrateCorrectOption.value = true;

      startVibrationAnimation();

      Future.delayed(const Duration(milliseconds: 500), () {
        vibrateAnswerBox.value = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        selectedAnswer.value = '';
      });
    }
  }

  List<String> generateOptions(String correctAnswer) {
    final correct = int.parse(correctAnswer);
    final options = <String>[correctAnswer];

    while (options.length < 4) {
      int randomOption;
      do {
        randomOption = 1 + random.nextInt(10);
      } while (
          options.contains(randomOption.toString()) || randomOption == correct);

      options.add(randomOption.toString());
    }

    options.shuffle();
    return options;
  }

  void goToNextProblem() {
    if (!isCorrect.value) {
      effectsPlayer.play(AssetSource("audio/wrong.mp3"));
      return;
    }

    if (currentProblemIndex.value < subtractionProblems.length - 1) {
      currentProblemIndex.value++;
      isCorrect.value = false;
      showHint.value = false;
      vibrateAnswerBox.value = false;
      vibrateCorrectOption.value = false;
      selectedAnswer.value = '';

      final correctAnswer =
          subtractionProblems[currentProblemIndex.value]['result'].toString();
      currentOptions.value = generateOptions(correctAnswer);

      hintTimer?.cancel();
      vibrationTimer?.cancel();
      startHintTimer();
      startAutoPlayWithSpeech();
    }
  }

  void goToPreviousProblem() {
    if (currentProblemIndex.value > 0) {
      currentProblemIndex.value--;
      isCorrect.value = false;
      showHint.value = false;
      vibrateAnswerBox.value = false;
      vibrateCorrectOption.value = false;
      selectedAnswer.value = '';

      final correctAnswer =
          subtractionProblems[currentProblemIndex.value]['result'].toString();
      currentOptions.value = generateOptions(correctAnswer);

      hintTimer?.cancel();
      vibrationTimer?.cancel();
      startHintTimer();
      startAutoPlayWithSpeech();
    }
  }

  void startHintTimer() {
    hintTimer?.cancel();
    hintTimer = Timer(const Duration(seconds: 5), () {
      if (!isCorrect.value) {
        showHint.value = true;
        vibrateCorrectOption.value = true;
        startVibrationAnimation();
      }
    });
  }

  void startVibrationAnimation() {
    vibrationTimer?.cancel();
    const vibrationDuration = Duration(seconds: 2);
    const vibrationInterval = Duration(milliseconds: 100);

    vibrationTimer = Timer.periodic(vibrationInterval, (timer) {
      update();
    });

    Future.delayed(vibrationDuration, () {
      vibrateCorrectOption.value = false;
      vibrationTimer?.cancel();
    });
  }

  void invalidateSpeechSession() {
    speechSessionId++;
  }

  void startAutoPlayWithSpeech() {
    stopAutoPlay();

    speechSessionId++;
    final int session = speechSessionId;

    isSpeaking.value = true;
    isAutoPlaying.value = true;

    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.play(AssetSource("audio/table_background.mp3"), volume: 0.2);
    speakCurrentProblem(session);
  }

  void stopAutoPlay() {
    invalidateSpeechSession();

    try {
      TTSService.stop();
    } catch (_) {}

    audioPlayer.stop();

    isAutoPlaying.value = false;
    isSpeaking.value = false;
  }

  void toggleAutoPlay() {
    if (isAutoPlaying.value) {
      stopAutoPlay();
    } else {
      startAutoPlayWithSpeech();
    }
  }

  void restartGame() {
    currentProblemIndex.value = 0;
    isCorrect.value = false;
    showHint.value = false;
    vibrateAnswerBox.value = false;
    vibrateCorrectOption.value = false;
    selectedAnswer.value = '';

    generateRandomProblems();
    final correctAnswer =
        subtractionProblems[currentProblemIndex.value]['result'].toString();
    currentOptions.value = generateOptions(correctAnswer);

    hintTimer?.cancel();
    vibrationTimer?.cancel();
    startHintTimer();
    startAutoPlayWithSpeech();
  }

  Future<void> speakCurrentProblem(int session) async {
    if (session != speechSessionId) return;

    final problem = subtractionProblems[currentProblemIndex.value];
    final num1 = problem['num1'];
    final num2 = problem['num2'];
    final result = problem['result'];
    final line = "$num1 plus $num2 equals $result";

    if (session != speechSessionId) return;

    isSpeaking.value = true;

    try {
      await TTSService.stop();
    } catch (_) {}

    try {
      await TTSService.speak(line);
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      await Future.delayed(const Duration(seconds: 3));
    }

    if (session != speechSessionId || !isAutoPlaying.value) {
      return;
    }

    isSpeaking.value = false;
    isAutoPlaying.value = false;
  }

  void stopAll() {
    audioPlayer.stop();
    effectsPlayer.stop();
    isSpeaking.value = false;
    isAutoPlaying.value = false;
    TTSService.stop();
    Get.delete<SubtractionController>();
  }
}
