import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../helper/app_color.dart';
import '../service/tts_service.dart';
import '../widgets/control_icon_button.dart';

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
      _toggleAutoPlay();
    });
  }

  void _goToNextTable() {
    if (_selectedNumber < 20) {
      setState(() {
        _selectedNumber++;
        _currentSpeakingIndex = -1;
      });
      _stopAutoPlay();
    }
  }

  int _tableSpeakingTime() {
    if (_selectedNumber >= 15 && _selectedNumber <= 20) {
      return 15;
    } else if (_selectedNumber >= 10 && _selectedNumber < 15) {
      return 10;
    } else if (_selectedNumber >= 5 && _selectedNumber < 10) {
      return 8;
    } else if (_selectedNumber >= 1 && _selectedNumber < 5) {
      return 3;
    } else {
      return 20;
    }
  }

  void _goToPreviousTable() {
    if (_selectedNumber > 1) {
      setState(() {
        _selectedNumber--;
        _currentSpeakingIndex = -1;
      });
      _stopAutoPlay();
    }
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  void _toggleAutoPlay() {
    if (_isSpeaking && !_isAutoPlaying) {
      _stopAutoPlay();
      return;
    }

    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
    });

    if (_isAutoPlaying && !_isSpeaking) {
      _startAutoPlayWithSpeech();
    } else {
      _stopAutoPlay();
    }
  }




  void _startAutoPlayWithSpeech() {
    _currentAutoPlayIndex = 0;

    setState(() {
      _isSpeaking = true;
      _isAutoPlaying = true;
      _currentSpeakingIndex = 0;
    });

    _speakCurrentLine();

    _autoPlayTimer =
        Timer.periodic(Duration(seconds: _tableSpeakingTime()), (timer) {
      if (!_isAutoPlaying || !mounted || _currentAutoPlayIndex == 10) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isSpeaking = false;
            _isAutoPlaying = false;
            _currentSpeakingIndex = -1;
          });
        }
        return;
      }
      _speakCurrentLine();
    });
  }

  void _speakCurrentLine() {
    if (_currentAutoPlayIndex >= 10) return;

    final multiplier = _currentAutoPlayIndex + 1;
    final result = _selectedNumber * multiplier;
    String line = "$_selectedNumber times $multiplier equals $result";

    setState(() {
      _currentSpeakingIndex = _currentAutoPlayIndex;
    });

    TTSService.speak(line).then((_) {
      if (_currentAutoPlayIndex >= 9) {
        if (mounted) {
          setState(() {
            _isSpeaking = false;
            _isAutoPlaying = false;
            _currentSpeakingIndex = -1;
          });
        }
      }
      _currentAutoPlayIndex++;
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    TTSService.stop();
    setState(() {
      _isAutoPlaying = false;
      _isSpeaking = false;
      _currentAutoPlayIndex = 0;
      _currentSpeakingIndex = -1;
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    TTSService.stop();
    super.dispose();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiplication Tables'),
        backgroundColor: currentColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              currentColor.withValues(alpha: 0.1),
              currentColor.withValues(alpha: 0.3),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            SizedBox(
              height: size.height * 0.08,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
            ),

            /// --- Multiplication Table --- ///
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
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
                    margin: EdgeInsets.symmetric(vertical: 0.2.h),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isCurrentlySpeaking
                          ? Colors.amber
                          : itemColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isCurrentlySpeaking
                          ? [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
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
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ControlIconButton(
                    icon: Icons.arrow_back_rounded,
                    iconSize: isTablet(context) ? 32 : 24,
                    color: AppColors.primaryDark,
                    onPressed: _goToPreviousTable,
                    isRounded: false,
                  ),
                  AvatarGlow(
                    glowColor:
                        _isSpeaking ? Colors.amber : AppColors.primaryDark,
                    glowRadiusFactor: 0.4,
                    animate: _isSpeaking,
                    child: ControlIconButton(
                      icon: getIcon(),
                      iconSize: isTablet(context) ? 32 : 24,
                      color: getIconColor(),
                      onPressed: _toggleAutoPlay,
                    ),
                  ),
                  ControlIconButton(
                    icon: Icons.arrow_forward_rounded,
                    iconSize: isTablet(context) ? 32 : 24,
                    color: AppColors.primaryDark,
                    onPressed: _goToNextTable,
                    isRounded: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h)
          ],
        ),
      ),
    );
  }
}
