import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/widgets/primary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../helper/app_color.dart';
import '../../service/tts_service.dart';
import '../../widgets/control_icon_button.dart';
import '../../widgets/navigation_button.dart';

class MultiplicationTableScreen extends StatefulWidget {
  const MultiplicationTableScreen({super.key});

  @override
  State<MultiplicationTableScreen> createState() =>
      _MultiplicationTableScreenState();
}

class _MultiplicationTableScreenState extends State<MultiplicationTableScreen> {
  int _selectedNumber = 1;
  final List<int> _numbers = List.generate(20, (index) => index + 1);
  bool _isAutoPlaying = false;
  bool _isSpeaking = false;
  Timer? _autoPlayTimer;
  int _currentAutoPlayIndex = 0;
  int _currentSpeakingIndex = -1;
  int _speechSessionId = 0;
  final AudioPlayer bgPlayer = AudioPlayer();

  ///------ Colors for different tables --------- ///
  final List<Color> _tableColors = [
    Colors.pink,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.amber.shade700,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.blueGrey,
    Colors.yellow.shade700,
    Colors.red,
    Colors.pinkAccent,
    Colors.greenAccent.shade700,
    Colors.cyanAccent.shade700,
    Colors.deepOrange,
    Colors.indigo.shade800
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPlayWithSpeech();
    });
  }

  void _goToNextTable() {
    if (_selectedNumber < 20) {
      setState(() {
        _selectedNumber++;
        _currentSpeakingIndex = -1;
      });
      _startAutoPlayWithSpeech();
    }
  }

  void _goToPreviousTable() {
    if (_selectedNumber > 1) {
      setState(() {
        _selectedNumber--;
        _currentSpeakingIndex = -1;
      });
      _startAutoPlayWithSpeech();
    }
  }

  /// table speaking time
  int _tableSpeakingTime() {
    if (_selectedNumber >= 15 && _selectedNumber <= 20) {
      return 5;
    } else if (_selectedNumber >= 10 && _selectedNumber < 15) {
      return 4;
    } else if (_selectedNumber >= 5 && _selectedNumber < 10) {
      return 3;
    } else if (_selectedNumber >= 1 && _selectedNumber < 5) {
      return 3;
    } else {
      return 5;
    }
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  void _toggleAutoPlay() {
    if (_isAutoPlaying) {
      _stopAutoPlay();
    } else {
      _startAutoPlayWithSpeech();
    }
  }

  /// Invalidate currently running speech sequences by advancing session id.
  void _invalidateSpeechSession() {
    _speechSessionId++;
  }

  /// Start autoplay + speech for current selected table.
  void _startAutoPlayWithSpeech() {
    _stopAutoPlay();

    _speechSessionId++;
    final int session = _speechSessionId;

    _currentAutoPlayIndex = 0;
    _currentSpeakingIndex = -1;

    if (mounted) {
      setState(() {
        _isSpeaking = true;
        _isAutoPlaying = true;
        _currentSpeakingIndex = 0;
      });
    }

    /// ----- Start background music ----- ///
    bgPlayer.setReleaseMode(ReleaseMode.loop);
    bgPlayer.play(AssetSource("audio/table_background.mp3"), volume: 0.2);
    _speakCurrentLine(session);
  }

  void _stopAutoPlay() {
    _invalidateSpeechSession();

    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;

    try {
      TTSService.stop();
    } catch (_) {}

    /// ------- Stop background music ------ ///
    bgPlayer.stop();

    if (mounted) {
      setState(() {
        _isAutoPlaying = false;
        _isSpeaking = false;
        _currentAutoPlayIndex = 0;
        _currentSpeakingIndex = -1;
      });
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    try {
      TTSService.stop();
    } catch (_) {}

    /// ----- Ensure background music is stopped ---- ///
    bgPlayer.stop();
    bgPlayer.dispose();
    super.dispose();
  }

  Future<void> _speakCurrentLine(int session) async {
    if (session != _speechSessionId) return;

    if (_currentAutoPlayIndex >= 10) {
      // finished table
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _isAutoPlaying = false;
          _currentSpeakingIndex = -1;
        });
      }
      return;
    }

    final multiplier = _currentAutoPlayIndex + 1;
    final result = _selectedNumber * multiplier;
    final line = "$_selectedNumber times $multiplier equals $result";

    if (session != _speechSessionId) return;

    if (mounted) {
      setState(() {
        _currentSpeakingIndex = _currentAutoPlayIndex;
      });
    }

    try {
      await TTSService.stop();
    } catch (_) {}

    final start = DateTime.now();
    try {
      final speakFuture = TTSService.speak(line);
      await speakFuture;

      final elapsed = DateTime.now().difference(start);
      if (elapsed < const Duration(milliseconds: 600)) {
        // speak returned too fast — fallback wait
        await Future.delayed(Duration(seconds: _tableSpeakingTime()));
      }
    } catch (e) {
      await Future.delayed(Duration(seconds: _tableSpeakingTime()));
    }

    if (!mounted || session != _speechSessionId || !_isAutoPlaying) {
      return;
    }

    if (_currentAutoPlayIndex >= 9) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _isAutoPlaying = false;
          _currentSpeakingIndex = -1;
        });
      }
      return;
    } else {
      _currentAutoPlayIndex++;
      _speakCurrentLine(session);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentColor =
        _tableColors[(_selectedNumber - 1) % _tableColors.length];
    final size = MediaQuery.of(context).size;

    IconData getIcon() {
      if (_isAutoPlaying) return Icons.pause_rounded;
      if (_isSpeaking) return Icons.volume_up_rounded;
      return Icons.volume_up_rounded;
    }

    Color getIconColor() {
      if (_isSpeaking) return Colors.amber;
      return AppColors.primaryDark;
    }

    return SafeArea(
      child: Scaffold(
        /// --- App bar ---- ///
        appBar: AppBar(
          toolbarHeight: size.height * 0.13,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: VxArc(
            height: 2.h,
            arcType: VxArcType.convey,
            child: Stack(
              children: [
                Container(
                  color: AppColors.primaryDark,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NavigationButton(
                              onTap: () => Navigator.pop(context),
                            ),
                            Text(
                              "Multiplication Table",
                              style: myTextStyle21(fontFamily: "primary"),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 2.h,
                  bottom: 0,
                  child: Lottie.asset(
                    "assets/lottie_animation_file/bear_hi.json",
                    fit: BoxFit.cover,
                    height: size.width * 0.35,
                    width: size.width * 0.35,
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,

        /// --- Body ------ ///
        body: Column(
          children: [
            SizedBox(
              height: 1.h,
            ),

            ///  Grid of numbers
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: _numbers.length,
              itemBuilder: (context, index) {
                final number = _numbers[index];
                final numberColor =
                    _tableColors[(number - 1) % _tableColors.length];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedNumber = number;
                      _currentSpeakingIndex = -1;
                    });
                    _startAutoPlayWithSpeech();
                  },
                  child: Animate(
                    effects: [
                      ScaleEffect(duration: 300.ms, delay: (index * 50).ms),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedNumber == number
                            ? numberColor
                            : numberColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: numberColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: myTextStyle18(
                            fontWeight: FontWeight.bold,
                            fontColor: _selectedNumber == number
                                ? Colors.white
                                : numberColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            /// ------- Table Number --------- ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Divider(thickness: 2, color: currentColor)),
                  SizedBox(width: 2.h),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: currentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_selectedNumber',
                      style: myTextStyle25(
                          fontWeight: FontWeight.bold,
                          fontColor: Colors.white,
                          fontFamily: "secondary"),
                    ),
                  ),
                  SizedBox(width: 2.h),
                  Expanded(child: Divider(thickness: 2, color: currentColor)),
                ],
              ),
            ),

            /// --- Multiplication Table --- ///
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final multiplier = index + 1;
                    final result = _selectedNumber * multiplier;
                    final itemColor = currentColor;
                    final isCurrentlySpeaking = _currentSpeakingIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(vertical: 0.1.h),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isCurrentlySpeaking
                            ? Colors.amber
                            : itemColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$_selectedNumber',
                              style: myTextStyle21(
                                  fontWeight: FontWeight.bold,
                                  fontColor: isCurrentlySpeaking
                                      ? Colors.black
                                      : Colors.white,
                                  fontFamily: "primary")),
                          Text(' × ',
                              style: myTextStyle21(
                                  fontWeight: FontWeight.bold,
                                  fontColor: isCurrentlySpeaking
                                      ? Colors.black
                                      : Colors.white,
                                  fontFamily: "primary")),
                          Text('$multiplier',
                              style: myTextStyle21(
                                  fontWeight: FontWeight.bold,
                                  fontColor: isCurrentlySpeaking
                                      ? Colors.black
                                      : Colors.white,
                                  fontFamily: "primary")),
                          Text(' = ',
                              style: myTextStyle21(
                                  fontWeight: FontWeight.bold,
                                  fontColor: isCurrentlySpeaking
                                      ? Colors.black
                                      : Colors.white,
                                  fontFamily: "primary")),
                          Text('$result',
                              style: myTextStyle25(
                                  fontWeight: FontWeight.bold,
                                  fontColor: isCurrentlySpeaking
                                      ? Colors.black
                                      : Colors.white,
                                  fontFamily: "primary")),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(
              height: size.height * 0.15,
              child: Stack(
                children: [
                  /// Car animation at the bottom
                  Positioned(
                    top: -1.1.h,
                    child: SizedBox(
                      child: Lottie.asset(
                        "assets/lottie_animation_file/Car insurance offers loading page.json",
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  ///  --- Control buttons at the bottom --- ///
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ControlIconButton(
                          icon: Icons.arrow_back_rounded,
                          iconSize: isTablet(context) ? 32 : 24,
                          color: AppColors.primaryDark,
                          onPressed: _goToPreviousTable,
                          isRounded: false,
                          borderColor: Colors.grey.shade700,
                        ),
                        AvatarGlow(
                          glowColor: _isSpeaking
                              ? Colors.amber
                              : AppColors.primaryDark,
                          glowRadiusFactor: 0.4,
                          animate: _isSpeaking,
                          child: ControlIconButton(
                            icon: getIcon(),
                            iconSize: isTablet(context) ? 32 : 24,
                            color: getIconColor(),
                            onPressed: _toggleAutoPlay,
                            borderColor: Colors.grey.shade700,
                          ),
                        ),
                        ControlIconButton(
                          icon: Icons.arrow_forward_rounded,
                          iconSize: isTablet(context) ? 32 : 24,
                          color: AppColors.primaryDark,
                          onPressed: _goToNextTable,
                          borderColor: Colors.grey.shade700,
                          isRounded: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
