import 'package:avatar_glow/avatar_glow.dart';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/service/tts_service.dart';
import 'package:babyspark/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../helper/app_color.dart';
import '../widgets/control_icon_button.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  bool _isAutoPlaying = false;
  int _currentSpeakingIndex = -1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    TTSService.initTTS();
  }

  @override
  void dispose() {
    TTSService.stop();
    _scrollController.dispose();
    super.dispose();
  }

  void playSound(String month) {
    TTSService.speak(month);
  }

  void _scrollToCurrentMonth(int index) {
    final double itemHeight = 1.5.h;
    final double scrollPosition = index * itemHeight;

    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void toggleAutoPlay() async {
    if (_isAutoPlaying) {
      setState(() {
        _isAutoPlaying = false;
        _currentSpeakingIndex = -1;
      });
      TTSService.stop();
    } else {
      setState(() {
        _isAutoPlaying = true;

        _currentSpeakingIndex = 0;
      });

      for (int i = 0; i < AppConstant.weekDaysData.length; i++) {
        if (!_isAutoPlaying) break;

        setState(() {
          _currentSpeakingIndex = i;
        });

        // Scroll to the current month
        _scrollToCurrentMonth(i);

        final month = AppConstant.weekDaysData[i]["day"] as String;
        await TTSService.speak(month);

        // Wait a bit between months
        if (i < AppConstant.weekDaysData.length - 1 && _isAutoPlaying) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      if (mounted) {
        setState(() {
          _isAutoPlaying = false;
          _currentSpeakingIndex = -1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final weekData = AppConstant.weekDaysData;
    bool isTablet(BuildContext context) {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide >= 600;
    }

    return SafeArea(
        child: Scaffold(
      ///------------- Appbar ------------ ///
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: size.height * 0.2,
        flexibleSpace: const SecondaryAppBar(title: "Week"),
        elevation: 0,
      ),

      /// -------------- Body --------------- ///
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ListView.builder(
                itemCount: weekData.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = weekData[index];
                  final isCurrentSpeaking = _currentSpeakingIndex == index;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      /// Timeline Line
                      if (index != weekData.length)
                        Positioned(
                          bottom: 0,
                          left: 1.5.h,
                          child: Container(
                            width: 4,
                            height: 500,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ),

                      /// Day Card
                      Row(
                        children: [
                          /// --- Number ---- ///
                          Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                  border: BoxBorder.all(
                                      width: 2, color: AppColors.primaryDark)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${index + 1}",
                                  style: myTextStyleCus(
                                      fontSize: isTablet(context) ? 32 : 27),
                                ),
                              )),

                          /// ---- line ----- ///
                          Container(
                            height: 8,
                            width: 60,
                            decoration: BoxDecoration(
                                border: BoxBorder.symmetric(
                                    horizontal: BorderSide(
                                        color: item["color"] as Color))),
                          ),

                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (_isAutoPlaying) {
                                  toggleAutoPlay();
                                }
                                playSound(item["day"] as String);
                                setState(() {
                                  _currentSpeakingIndex = index;
                                });
                                _scrollToCurrentMonth(index);
                              },
                              borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(100))
                                  .copyWith(
                                      topRight: const Radius.circular(11),
                                      bottomRight: const Radius.circular(11)),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: isCurrentSpeaking
                                      ? AppColors.primaryDark
                                      : item["color"] as Color,
                                  borderRadius: BorderRadius.circular(12)
                                      .copyWith(
                                          topLeft: const Radius.circular(100),
                                          bottomLeft:
                                              const Radius.circular(100)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item["day"] as String,
                                      style: myTextStyle30(
                                          fontFamily: "secondary",
                                          fontColor: isCurrentSpeaking
                                              ? Colors.white
                                              : Colors.black),
                                    ),

                                    /// ------ Image ------ ///
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          if (isCurrentSpeaking)
                                            Icon(
                                              Icons.volume_up,
                                              color: Colors.white54,
                                              size: 3.h,
                                            ),
                                          Image.asset(
                                            "assets/images/white_bear.png",
                                            height: size.height * 0.08,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),

      /// ------- Floating action button ----- ///
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        glowColor: _isAutoPlaying ? Colors.amber : AppColors.primaryDark,
        glowRadiusFactor: 0.4,
        animate: _isAutoPlaying,
        child: ControlIconButton(
            color: _isAutoPlaying ? Colors.amber : AppColors.primaryDark,
            icon:
                _isAutoPlaying ? Icons.pause_rounded : Icons.volume_up_rounded,
            iconSize: 32,
            onPressed: toggleAutoPlay),
      ),
    ));
  }
}
