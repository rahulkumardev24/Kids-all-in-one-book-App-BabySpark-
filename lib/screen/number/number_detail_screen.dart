import 'dart:async';
import 'package:babyspark/helper/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  _NumberDetailScreenState createState() => _NumberDetailScreenState();
}

class _NumberDetailScreenState extends State<NumberDetailScreen> {
  late PageController _pageController;
  late int currentPage;
  Timer? _timer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialNumber;
    _pageController = PageController(initialPage: widget.initialNumber);

    Future.delayed(const Duration(milliseconds: 500), () {
      playSound(currentPage + 1);
    });
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
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
    TTSService.speak("$number");
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: size.height * 0.2,
          flexibleSpace: const PrimaryAppBar(title: "Number"),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                  playSound(page + 1);
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: _numberPage(index + 1),
                  );
                },
                itemCount: widget.maxNumber,
              ),
            ),
            SizedBox(
              height: size.height * 0.25,
              child: Stack(
                children: [
                  const FooterAnimation(),
                  Positioned(
                    top: 0,
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
                          SizedBox(width: size.width * 0.05),

                          /// Play / Pause AutoPlay
                          ControlIconButton(
                            color: _isPlaying ? Colors.green : Colors.black,
                            icon: _isPlaying
                                ? CupertinoIcons.pause_solid
                                : CupertinoIcons.play_arrow_solid,
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
                          SizedBox(width: size.width * 0.05),

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

  Widget _numberPage(int number) {
    String numberWord = AppConstant.numberWords[number];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$number',
            style: myTextStyleCus(
              fontSize: 200,
              fontFamily: "primary",
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            numberWord,
            style: myTextStyle40(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
