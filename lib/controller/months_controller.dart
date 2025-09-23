import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../helper/app_constant.dart';
import '../service/tts_service.dart';

class MonthsController extends GetxController {
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
  void onClose() {
    TTSService.stop();
    scrollController.dispose();
    super.onClose();
  }

  void playSound(String month) {
    TTSService.speak(month);
  }

  /// Auto scroll
  void _scrollToCurrentMonth(int index) {
    final double itemHeight = 6.5.h;
    final double scrollPosition = index * itemHeight;

    scrollController.animateTo(
      scrollPosition,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  /// toggle auto play
  void toggleAutoPlay() async {
    if (_isAutoPlaying.value) {
      _isAutoPlaying.value = false;
      _currentSpeakingIndex.value = -1;
      TTSService.stop();
    } else {
      _isAutoPlaying.value = true;
      _currentSpeakingIndex.value = 0;

      // Play all months sequentially
      for (int i = 0; i < AppConstant.monthsData.length; i++) {
        if (!_isAutoPlaying.value) break;

        _currentSpeakingIndex.value = i;

        // Scroll to the current month
        _scrollToCurrentMonth(i);

        final month = AppConstant.monthsData[i]["day"] as String;
        await TTSService.speak(month);

        // Wait a bit between months
        if (i < AppConstant.monthsData.length - 1 && _isAutoPlaying.value) {
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
    playSound(AppConstant.monthsData[index]["day"] as String);
    _currentSpeakingIndex.value = index;
    _scrollToCurrentMonth(index);
  }
  void stopAllSpeech() {
    _isAutoPlaying.value = false;
    _currentSpeakingIndex.value = -1;
    Get.delete<MonthsController>() ;
    TTSService.stop();
  }
}
