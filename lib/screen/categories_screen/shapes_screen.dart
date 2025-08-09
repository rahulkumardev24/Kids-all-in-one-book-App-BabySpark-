import 'dart:async';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/widgets/footer_animation.dart';
import 'package:babyspark/widgets/primary_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
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
  late PageController _pageController;

  int _currentIndex = 0;
  bool _isAutoPlaying = false;
  Timer? _autoPlayTimer;

  final shapes = AppConstant.shapes;

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 10),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _bounceController.dispose();
    _confettiController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Move to next shape
  void _nextShape() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % shapes.length;
    });
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _playBounce();
  }

  /// Move to previous shape
  void _previousShape() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + shapes.length) % shapes.length;
    });
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _playBounce();
  }

  /// Bounce animation trigger
  void _playBounce() {
    _bounceController
      ..stop()
      ..reset()
      ..forward();
  }

  /// Toggle auto play
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

  /// Start auto play
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        /// App Bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: size.height * 0.2,
          flexibleSpace: const PrimaryAppBar(title: "Let's Learn Shapes!"),
        ),

        /// Body
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: shapes.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  if (!_isAutoPlaying) {
                    _autoPlayTimer?.cancel();
                  }

                  _playBounce();
                },
                itemBuilder: (context, index) {
                  final shape = shapes[index];
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _bounceAnimation,
                          child: Icon(
                            shape['icon'],
                            size: size.width * 0.7,
                            color: shape['color'],
                          ),
                        ),
                        Text(
                          shape['name'],
                          style: myTextStyleCus(
                            fontSize: isTablet(context) ? 60 : 36,
                            fontFamily: "primary",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Footer
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
                            onPressed: _previousShape,
                            isRounded: false,
                          ),
                          const SizedBox(width: 20),
                          ControlIconButton(
                            color: _isAutoPlaying ? Colors.green : Colors.black,
                            icon: _isAutoPlaying
                                ? CupertinoIcons.pause_solid
                                : CupertinoIcons.play_arrow_solid,
                            iconSize: isTablet(context) ? 36 : 28,
                            iconColor: Colors.white,
                            onPressed: _toggleAutoPlay,
                          ),
                          const SizedBox(width: 20),
                          ControlIconButton(
                            icon: Icons.arrow_forward_rounded,
                            iconSize: isTablet(context) ? 32 : 24,
                            color: AppColors.primaryDark,
                            onPressed: _nextShape,
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
    );
  }
}

