import 'dart:async';
import 'package:babyspark/model/book_model.dart';
import 'package:babyspark/service/tts_service.dart';
import 'package:babyspark/widgets/primary_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../domain/custom_text_style.dart';
import '../../../helper/app_color.dart';
import '../../../widgets/control_icon_button.dart';
import '../../../widgets/footer_animation.dart';

class AlphabetsDetailsScreen extends StatefulWidget {
  final int currentIndex;
  final String collectionName;
  final List<BookModel> items;

  const AlphabetsDetailsScreen({
    super.key,
    required this.currentIndex,
    required this.collectionName,
    required this.items,
  });

  @override
  State<AlphabetsDetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<AlphabetsDetailsScreen>
    with TickerProviderStateMixin {
  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late ConfettiController _confettiController;
  late PageController _pageController;
  late int _currentIndex;

  bool _isAutoPlaying = false;
  Timer? _autoPlayTimer;


  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      playSound(widget.items[_currentIndex].title);
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _bounceController.dispose();
    _confettiController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextItem() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.items.length;
    });
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _playBounce();
  }

  void _previousItem() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.items.length) % widget.items.length;
    });
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _playBounce();
  }

  void _playBounce() {
    _bounceController
      ..stop()
      ..reset()
      ..forward();
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
      _nextItem();
    });
  }

  void playSound(String title) {
    if (title.isNotEmpty) {
      String firstLetter = title[0].toUpperCase();
      TTSService.speak("$firstLetter for $title");
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        /// --- App bar --- ///
        appBar: AppBar(
          toolbarHeight: size.height * 0.2,
          automaticallyImplyLeading: false,
          flexibleSpace: const PrimaryAppBar(title: "New Alphabets"),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,

        /// ---- Body ---- ///
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });

                  if (!_isAutoPlaying) {
                    _autoPlayTimer?.cancel();
                  }

                  playSound(widget.items[index].title);

                  _playBounce();
                },
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _bounceAnimation,
                          child: CachedNetworkImage(
                            imageUrl: item.image,
                            height: size.width * 0.7,
                            width: size.width * 0.7,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child: Text(
                                item.title[0],
                                style: myTextStyleCus(
                                  fontSize: isTablet(context) ? 200 : 150,
                                  fontWeight: FontWeight.bold,
                                  fontColor: AppColors.primaryDark
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              alignment: Alignment.center,
                              child: Text(
                                item.title[0],
                                style: myTextStyleCus(
                                  fontSize: isTablet(context) ? 150 : 100,
                                  fontWeight: FontWeight.bold,
                                    fontColor: AppColors.primaryDark
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          item.title,
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
                            onPressed: _previousItem,
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
                            onPressed: _nextItem,
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
