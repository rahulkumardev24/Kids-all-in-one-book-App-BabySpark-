import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../helper/app_constant.dart';
import '../service/tts_service.dart';

class WeekController extends GetxController {
  final _isAutoPlaying = false.obs;
  final _currentSpeakingIndex = (-1).obs;
  final ScrollController scrollController = ScrollController();

  /// getter
  bool get isAutoPlaying => _isAutoPlaying.value;
  int get currentSpeakingIndex => _currentSpeakingIndex.value;

  @override
  void onInit() {
    super.onInit();
    TTSService.initTTS();
    toggleAutoPlay();
  }

  @override
  void dispose() {
    TTSService.stop();
    scrollController.dispose();
    super.dispose();
  }

  void playSound(String month) {
    TTSService.speak(month);
  }

  void _scrollToCurrentWeek(int index) {
    final double itemHeight = 1.5.h;
    final double scrollPosition = index * itemHeight;

    scrollController.animateTo(
      scrollPosition,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void toggleAutoPlay() async {
    if (_isAutoPlaying.value) {
      _isAutoPlaying.value = false;
      _currentSpeakingIndex.value = -1;
      TTSService.stop();
    } else {
      _isAutoPlaying.value = true;
      _currentSpeakingIndex.value = 0;

      for (int i = 0; i < AppConstant.weekDaysData.length; i++) {
        if (!_isAutoPlaying.value) break;

        _currentSpeakingIndex.value = i;

        // Scroll to the current month
        _scrollToCurrentWeek(i);

        final month = AppConstant.weekDaysData[i]["day"] as String;
        await TTSService.speak(month);

        // Wait a bit between months
        if (i < AppConstant.weekDaysData.length - 1 && _isAutoPlaying.value) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      _isAutoPlaying.value = false;
      _currentSpeakingIndex.value = -1;
    }
  }

  void selectMonth(int index) {
    if (_isAutoPlaying.value) {
      toggleAutoPlay();
    }
    playSound(AppConstant.weekDaysData[index]["day"] as String);
    _currentSpeakingIndex.value = index;
    _scrollToCurrentWeek(index);
  }
}
