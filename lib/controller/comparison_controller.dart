import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:babyspark/service/tts_service.dart';
import 'package:get/get.dart';

class ComparisonController extends GetxController {
  /// Reactive variables
  final comparisonProblems = <Map<String, dynamic>>[].obs;
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
    currentOptions.value = ['>', '<', '='];
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

  void generateRandomProblems() {
    comparisonProblems.clear();

    for (int i = 0; i < 15; i++) {
      int num1, num2;
      String correctSymbol;

      if (i < 5) {
        // Easy problems (small numbers)
        num1 = 1 + random.nextInt(5);
        num2 = 1 + random.nextInt(5);
      } else if (i < 10) {
        // Medium problems
        num1 = 4 + random.nextInt(6);
        num2 = 4 + random.nextInt(6);
      } else {
        // Hard problems (larger numbers)
        num1 = 8 + random.nextInt(2);
        num2 = 8 + random.nextInt(2);
      }

      // Determine the correct comparison symbol
      if (num1 > num2) {
        correctSymbol = '>';
      } else if (num1 < num2) {
        correctSymbol = '<';
      } else {
        correctSymbol = '=';
      }

      comparisonProblems
          .add({'num1': num1, 'num2': num2, 'correctSymbol': correctSymbol});
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
    currentOptions.value = ['>', '<', '='];

    hintTimer?.cancel();
    vibrationTimer?.cancel();
    startHintTimer();
    startAutoPlayWithSpeech();
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

  void goToNextProblem() {
    if (!isCorrect.value) {
      effectsPlayer.play(AssetSource("audio/wrong.mp3"));
      return;
    }

    if (currentProblemIndex.value < comparisonProblems.length - 1) {
      currentProblemIndex.value++;
      isCorrect.value = false;
      showHint.value = false;
      vibrateAnswerBox.value = false;
      vibrateCorrectOption.value = false;
      selectedAnswer.value = '';

      currentOptions.value = ['>', '<', '='];

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
      currentOptions.value = ['>', '<', '='];

      hintTimer?.cancel();
      vibrationTimer?.cancel();
      startHintTimer();
      startAutoPlayWithSpeech();
    }
  }

  void toggleAutoPlay() {
    if (isAutoPlaying.value) {
      stopAutoPlay();
    } else {
      startAutoPlayWithSpeech();
    }
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

  Future<void> speakCurrentProblem(int session) async {
    if (session != speechSessionId) return;

    final problem = comparisonProblems[currentProblemIndex.value];
    final num1 = problem['num1'];
    final num2 = problem['num2'];
    final correctSymbol = problem['correctSymbol'];

    String comparisonText;
    if (correctSymbol == '>') {
      comparisonText = "$num1 is greater than $num2";
    } else if (correctSymbol == '<') {
      comparisonText = "$num1 is less than $num2";
    } else {
      comparisonText = "$num1 is equal to $num2";
    }

    if (session != speechSessionId) return;

    isSpeaking.value = true;

    try {
      await TTSService.stop();
    } catch (_) {}

    try {
      await TTSService.speak(comparisonText);
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

  void checkAnswer(String selectedOption) {
    selectedAnswer.value = selectedOption;

    final problem = comparisonProblems[currentProblemIndex.value];
    final correctAnswer = problem['correctSymbol'];

    if (selectedOption == correctAnswer) {
      isCorrect.value = true;
      showHint.value = false;
      vibrateAnswerBox.value = false;
      vibrateCorrectOption.value = false;

      effectsPlayer.play(AssetSource("audio/correct.mp3"));

      Future.delayed(const Duration(seconds: 1), () {
        if (currentProblemIndex.value < comparisonProblems.length - 1) {
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
}
