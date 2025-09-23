import 'dart:async';
import 'package:babyspark/controller/loading_controller.dart';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/widgets/primary_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../helper/app_color.dart';
import '../../service/tts_service.dart';
import '../../widgets/control_icon_button.dart';
import '../../widgets/footer_animation.dart';

@immutable
class ColorsScreen extends StatefulWidget {
  late int selectedIndex;
  ColorsScreen({super.key, required this.selectedIndex});

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  bool isSpeaking = false;
  bool isAutoPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _autoPlayTimer;
  late PageController _pageController;
  late ScrollController _scrollController;
  final myColorList = AppConstant.colorsList;
  late Size size;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedIndex);
    _scrollController = ScrollController();

    Future.delayed(const Duration(milliseconds: 500), () {
      playColorSound();
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _audioPlayer.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void playColorSound() {
    final colorName = myColorList[widget.selectedIndex]["name"];
    TTSService.speak(colorName);
  }

  void nextColor() {
    if (widget.selectedIndex < myColorList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        playColorSound();
      });
    }
  }

  void previousColor() {
    if (widget.selectedIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        playColorSound();
      });
    }
  }

  void toggleAutoPlay() {
    if (isAutoPlaying) {
      // Stop autoplay
      _autoPlayTimer?.cancel();
      setState(() {
        isAutoPlaying = false;
      });
    } else {
      // Start autoplay
      _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (widget.selectedIndex < myColorList.length - 1) {
          widget.selectedIndex++;
        } else {
          widget.selectedIndex = 0;
        }

        _pageController.animateToPage(
          widget.selectedIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        isAutoPlaying = true;
      });

      setState(() {
        isAutoPlaying = true;
      });
    }
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        /// --- App bar --- ///
        appBar: AppBar(
          toolbarHeight: size.height * 0.2,
          flexibleSpace: const PrimaryAppBar(title: "Colours"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),

        backgroundColor: Colors.white,

        /// --- Body --- ///
        body: SafeArea(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                previousColor();
              } else if (details.primaryVelocity! < 0) {
                nextColor();
              }
            },
            child: Column(
              children: [
                /// Main Color Display
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        widget.selectedIndex = index;
                      });
                      if (isAutoPlaying) playColorSound();
                    },
                    itemCount: myColorList.length,
                    itemBuilder: (context, index) {
                      final colorData = myColorList[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Color Circle
                          Container(
                            width: size.width * 0.6,
                            height: size.width * 0.6,
                            decoration: BoxDecoration(
                              color: colorData["color"],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Column(
                            children: [
                              /// --- color  name --- ///
                              Text(
                                colorData["name"],
                                style: myTextStyleCus(
                                    fontColor: colorData["color"],
                                    fontSize: isTablet(context) ? 80 : 50),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                /// --- Bottom part --- ///
                SizedBox(
                  height: size.height * 0.25,
                  child: Stack(
                    children: [
                      const FooterAnimation(),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ControlIconButton(
                                icon: Icons.arrow_back_rounded,
                                iconSize: isTablet(context) ? 32 : 24,
                                color: AppColors.primaryDark,
                                onPressed: previousColor,
                                isRounded: false,
                              ),
                              const SizedBox(width: 20),
                              ControlIconButton(
                                color:
                                    isAutoPlaying ? Colors.green : Colors.black,
                                icon: isAutoPlaying
                                    ? CupertinoIcons.pause_solid
                                    : CupertinoIcons.play_arrow_solid,
                                iconSize: isTablet(context) ? 36 : 28,
                                iconColor: Colors.white,
                                onPressed: toggleAutoPlay,
                              ),
                              const SizedBox(width: 20),
                              ControlIconButton(
                                icon: Icons.arrow_forward_rounded,
                                iconSize: isTablet(context) ? 32 : 24,
                                color: AppColors.primaryDark,
                                onPressed: nextColor,
                                isRounded: false,
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
        ),
      ),
    );
  }
}
