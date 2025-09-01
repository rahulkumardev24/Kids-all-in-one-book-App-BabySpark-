// controllers/loading_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';

/// --- This controller manages loading states and shows/hides loading overlay --- ///
class LoadingController extends GetxController {
  /// ----- Get the singleton instance of this controller ---- ///
  static LoadingController get instance => Get.find();

  /// Observable boolean to track loading state
  var isLoading = false.obs;

  /// OverlayEntry to manage the loading overlay
  OverlayEntry? _overlayEntry;

  /// Timer to ensure minimum showing time
  Timer? _minimumShowTimer;

  /// Track when loading was shown
  DateTime? _loadingShownAt;

  /// Show loading overlay if not already showing
  void showLoading() {
    if (!isLoading.value && Get.overlayContext != null) {
      isLoading.value = true;
      _loadingShownAt = DateTime.now();
      _showOverlayLoading();

      // Set minimum show time
      _minimumShowTimer = Timer(const Duration(seconds: 1), () {
      });
    }
  }

  /// Private method to create and display the loading overlay
  void _showOverlayLoading() {
    try {
      if (Get.overlayContext == null) return;
      _overlayEntry = OverlayEntry(
        builder: (context) => Material(
          color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Lottie animation for loading
                  Lottie.asset(
                    "assets/lottie_animation_file/cat_loading.json",
                    width: 20.h,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 2.h),

                  /// Loading text
                  Text(
                    "Loading...",
                    style: myTextStyleCus(
                      fontSize: 21,
                      fontColor: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Insert the overlay into the overlay state
      Overlay.of(Get.overlayContext!).insert(_overlayEntry!);
    } catch (e) {
      // Handle any errors that might occur
      print('Error showing loading: $e');
      isLoading.value = false;
    }
  }

  // Hide the loading overlay if it's visible (with minimum show time check)
  void hideLoading() {
    if (isLoading.value) {
      // Check if minimum 1 seconds
      if (_loadingShownAt != null) {
        final timeElapsed = DateTime.now().difference(_loadingShownAt!);
        final timeRemaining = const Duration(seconds: 1) - timeElapsed;

        if (timeRemaining > Duration.zero) {
          Timer(timeRemaining, () {
            _actuallyHideLoading();
          });
          return;
        }
      }

      // Hide immediately if more than 2 seconds have passed
      _actuallyHideLoading();
    }
  }

  // Actually hide the loading overlay
  void _actuallyHideLoading() {
    if (isLoading.value) {
      isLoading.value = false;
      _overlayEntry?.remove();
      _overlayEntry = null;
      _minimumShowTimer?.cancel();
      _minimumShowTimer = null;
      _loadingShownAt = null;
    }
  }

  // Clean up when controller is closed
  @override
  void onClose() {
    _actuallyHideLoading();
    super.onClose();
  }
}
