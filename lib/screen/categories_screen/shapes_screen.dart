import 'dart:async';

import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import '../../helper/app_color.dart';
import '../../widgets/control_icon_button.dart';

class ShapesScreen extends StatefulWidget {
  const ShapesScreen({super.key});

  @override
  State<ShapesScreen> createState() => _ShapesScreenState();
}

class _ShapesScreenState extends State<ShapesScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late ConfettiController _confettiController;
  int _currentIndex = 0;
  int _tapCount = 0;
  bool _isAutoPlaying = false;
  Timer? _autoPlayTimer;

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  final shapes = AppConstant.shapes;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _bounceAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 10),
        TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 10),
      ],
    ).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _nextShape() {
    if (!mounted) return;

    setState(() {
      if (_currentIndex + 1 >= shapes.length) {
        _currentIndex = 0;
        _isAutoPlaying = false;
        _autoPlayTimer?.cancel();
      } else {
        _currentIndex++;
      }
      _tapCount = 0;
    });

    _bounceController.stop();
    _bounceController.reset();
    _bounceController.forward();
  }

  void _previousShape() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % shapes.length;
      if (_currentIndex < 0) _currentIndex = shapes.length - 1;
      _tapCount = 0;
    });

    _bounceController.stop();
    _bounceController.reset();
    _bounceController.forward();
  }

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
    });

    if (_isAutoPlaying) {
      _startAutoPlay();
    } else {
      _autoPlayTimer?.cancel();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isAutoPlaying || !mounted) {
        timer.cancel();
        return;
      }
      _nextShape();
    });
  }

  void _handleShapeTap() {
    setState(() {
      _tapCount++;
      if (_tapCount >= 3) {
        _confettiController.play();
        _tapCount = 0;
      }
    });

    _bounceController.stop();
    _bounceController.reset();
    _bounceController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final currentShape = shapes[_currentIndex];
    final size = MediaQuery.of(context).size;
    final shapeSize = size.width * 0.7;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            /// Main section
            Container(
              width: size.width,
              height: size.height,
              decoration:
                  const BoxDecoration(gradient: AppColors.backgroundGradient),
              child: Column(
                children: [
                  /// Shape display area
                  Expanded(
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        onTap: _handleShapeTap,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: size.height * 0.2),
                            ScaleTransition(
                              scale: _bounceAnimation,
                              child: SizedBox(
                                width: shapeSize,
                                height: shapeSize,
                                child: Center(
                                  child: Icon(
                                    currentShape['icon'],
                                    size: shapeSize * 0.8,
                                    color: currentShape['color'],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              currentShape['name'],
                              style: myTextStyleCus(
                                fontSize: isTablet(context) ? 80 : 42,
                                fontFamily: "primary",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Navigation buttons
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ControlIconButton(
                          icon: Icons.arrow_back_rounded,
                          iconSize: isTablet(context) ? 32 : 21,
                          color: AppColors.primaryDark,
                          isRounded: false,
                          onPressed: _previousShape,
                        ),
                        ControlIconButton(
                          color: _isAutoPlaying ? Colors.green : Colors.black,

                          icon: _isAutoPlaying
                              ? CupertinoIcons.pause_solid
                              : CupertinoIcons.play_arrow_solid,
                          iconSize: isTablet(context) ? 36 : 27,
                          iconColor:Colors.white ,
                          onPressed: _toggleAutoPlay,
                        ),
                        ControlIconButton(
                          icon: Icons.arrow_forward_rounded,
                          iconSize: isTablet(context) ? 32 : 21,
                          color: AppColors.primaryDark,
                          isRounded: false,
                          onPressed: _nextShape,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Header
            SizedBox(
              height: size.height * 0.2,
              width: size.width,
              child: ClipPath(
                clipper: _BabyWaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.backspace_rounded,
                                color: AppColors.navigationColor,
                                size: isTablet(context) ? 32 : 21,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Let's Learn Shapes!",
                              style: myTextStyleCus(
                                fontSize: isTablet(context) ? 42 : 21,
                                fontFamily: "secondary",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: size.width * 0.09,
                        bottom: size.height * 0.03,
                        child: Lottie.asset(
                          "assets/lottie_animation_file/rabbit.json",
                          height: size.height * 0.18,
                          width: size.height * 0.15,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BabyWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.6,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
