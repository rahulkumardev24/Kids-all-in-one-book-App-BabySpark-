import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../domain/custom_text_style.dart';
import '../../helper/app_color.dart';
import '../../service/tts_service.dart';
import '../../widgets/control_icon_button.dart';
import '../../widgets/footer_animation.dart';
import '../../widgets/primary_app_bar.dart';

class NumberDetailScreen extends StatefulWidget {
  final int initialNumber;
  final int maxNumber;

  const NumberDetailScreen({
    super.key,
    required this.initialNumber,
    required this.maxNumber,
  });

  @override
  State<NumberDetailScreen> createState() => _NumberDetailScreenState();
}

class _NumberDetailScreenState extends State<NumberDetailScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int currentPage;
  Timer? _timer;
  bool _isPlaying = false;

  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialNumber;
    _pageController = PageController(initialPage: widget.initialNumber);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(_bounceController);

    Future.delayed(const Duration(milliseconds: 400), () {
      playSound(currentPage + 1);
      _playBounce();
    });
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentPage < widget.maxNumber - 1) {
        currentPage++;
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _stopAutoPlay();
      }
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  void playSound(int number) {
    TTSService.stop();
    TTSService.speak("$number");
  }

  void _playBounce() {
    _bounceController
      ..stop()
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    _bounceController.dispose();
    TTSService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isTablet(BuildContext context) {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return SafeArea(
      child: Scaffold(
        /// ----------- Appbar ----------- ///
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: size.height * 0.2,
          flexibleSpace: const PrimaryAppBar(title: "Number"),
        ),
        backgroundColor: Colors.white,

        /// ---------- Body ----------- ///
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() => currentPage = page);
                  playSound(page + 1);
                  _playBounce();
                },
                itemCount: widget.maxNumber,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      playSound(index + 1);
                      _playBounce();
                    },
                    child: Center(
                      child: _numberPage(
                          number: index + 1, isTablet: isTablet(context)),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 1.h,
            ),

            /// --------- Footer Controls -------- ///
            SizedBox(
              height: size.height * 0.25,
              child: Stack(
                children: [
                  const FooterAnimation(),
                  Positioned(
                    top: 1.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Previous Button
                          ControlIconButton(
                            icon: Icons.arrow_back_rounded,
                            iconSize: isTablet(context) ? 32 : 21,
                            color: AppColors.primaryDark,
                            isRounded: false,
                            onPressed: currentPage > 0
                                ? () {
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
                          ),
                          SizedBox(width: 4.h),

                          /// Play / Pause AutoPlay
                          AvatarGlow(
                            glowColor: AppColors.primaryDark,
                            glowRadiusFactor: 0.4,
                            animate: _isPlaying,
                            child: ControlIconButton(
                              color: _isPlaying
                                  ? Colors.amber
                                  : AppColors.primaryDark,
                              icon: _isPlaying
                                  ? CupertinoIcons.pause_solid
                                  : Icons.volume_up_rounded,
                              iconSize: isTablet(context) ? 36 : 27,
                              iconColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                  if (_isPlaying) {
                                    _startAutoPlay();
                                  } else {
                                    _stopAutoPlay();
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 4.h),

                          /// Next Button
                          ControlIconButton(
                            icon: Icons.arrow_forward_rounded,
                            iconSize: isTablet(context) ? 32 : 21,
                            color: AppColors.primaryDark,
                            isRounded: false,
                            onPressed: currentPage < widget.maxNumber - 1
                                ? () {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberPage({required int number, required bool isTablet}) {
    String numberWord = AppConstant.numberWords[number];
    return Center(
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: isTablet ? Get.width * 0.4 : Get.width * 0.5,
                fontFamily: "primary",
                color: AppColors.primaryDark,
                shadows: const [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(1.5, 1.5))
                ],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            numberWord,
            style: myTextStyleCus(fontSize:  isTablet ? 8.h : 5.h , fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
