import 'package:avatar_glow/avatar_glow.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/widgets/control_icon_button.dart';
import 'package:babyspark/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';
import '../service/tts_service.dart';

class MonthsScreen extends StatefulWidget {
  const MonthsScreen({super.key});

  @override
  State<MonthsScreen> createState() => _MonthsScreenState();
}

class _MonthsScreenState extends State<MonthsScreen> {
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
    final double itemHeight = 6.5.h;
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

      // Play all months sequentially
      for (int i = 0; i < AppConstant.monthsData.length; i++) {
        if (!_isAutoPlaying) break;

        setState(() {
          _currentSpeakingIndex = i;
        });

        // Scroll to the current month
        _scrollToCurrentMonth(i);

        final month = AppConstant.monthsData[i]["day"] as String;
        await TTSService.speak(month);

        // Wait a bit between months
        if (i < AppConstant.monthsData.length - 1 && _isAutoPlaying) {
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
    final monthsData = AppConstant.monthsData;

    return SafeArea(
      child: Scaffold(
        /// ---------- Appbar -------------- ///
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: size.height * 0.2,
          flexibleSpace: const SecondaryAppBar(title: "Months"),
          elevation: 0,
        ),

        /// ------------ Body -------------- ///
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: monthsData.length,
                  itemBuilder: (context, index) {
                    final item = monthsData[index];
                    final isCurrentSpeaking = _currentSpeakingIndex == index;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          /// Month Card
                          InkWell(
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
                                    left: Radius.circular(11))
                                .copyWith(
                                    topRight: const Radius.circular(100),
                                    bottomRight: const Radius.circular(100)),
                            child: Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 2.h, top: 0.5.h, bottom: 0.5.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 2.h),
                                  margin: const EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                    color: isCurrentSpeaking
                                        ? AppColors.primaryDark
                                        : item["color"] as Color,
                                    borderRadius: const BorderRadius.horizontal(
                                            right: Radius.circular(100))
                                        .copyWith(
                                            bottomLeft:
                                                const Radius.circular(11),
                                            topLeft: const Radius.circular(11)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.h),
                                        child: Text(
                                          item["day"] as String,
                                          style: myTextStyle30(
                                            fontFamily: "secondary",
                                            fontColor: isCurrentSpeaking
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          if (isCurrentSpeaking)
                                            Icon(
                                              Icons.volume_up,
                                              color: Colors.white54,
                                              size: 3.h,
                                            ),
                                          SizedBox(
                                            width: 1.h,
                                          ),
                                          Image.asset(
                                            item["image"] as String,
                                            height: 5.h,
                                            width: 5.h,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ///--------- Month number badge ------- ///
                          Positioned(
                            left: -2.h,
                            child: Container(
                              height: size.width * 0.25,
                              width: size.width * 0.25,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/month_card.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 3.h),
                                child: Text(
                                  "${index + 1}",
                                  style: myTextStyle32(
                                    fontFamily: "secondary",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
              icon: _isAutoPlaying
                  ? Icons.pause_rounded
                  : Icons.volume_up_rounded,
              iconSize: 32,
              onPressed: toggleAutoPlay),
        ),
      ),
    );
  }
}
