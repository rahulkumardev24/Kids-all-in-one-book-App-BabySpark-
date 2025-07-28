import 'dart:async';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:velocity_x/velocity_x.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({super.key});

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  int selectedIndex = 0;
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
    _pageController = PageController(initialPage: selectedIndex);
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    // Center the initial selected item after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedIndex();
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

  void playColorSound() async {
    setState(() => isSpeaking = true);
    await _audioPlayer.stop();
    await _audioPlayer
        .play(AssetSource('sounds/${myColorList[selectedIndex]["sound"]}'));
    setState(() => isSpeaking = false);
  }

  void nextColor() {
    if (selectedIndex < myColorList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousColor() {
    if (selectedIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void toggleAutoPlay() {
    setState(() {
      isAutoPlaying = !isAutoPlaying;
      if (isAutoPlaying) {
        playColorSound();
        _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (_) {
          if (selectedIndex < AppConstant.colorsList.length - 1) {
            nextColor();
          } else {
            setState(() => isAutoPlaying = false);
            _autoPlayTimer?.cancel();
          }
        });
      } else {
        _autoPlayTimer?.cancel();
      }
    });
  }

  void _scrollToSelectedIndex() {
    if (_scrollController.hasClients) {
      const itemWidth = 100.0; // Fixed width for each color circle
      const itemMargin = 8.0; // Margin between items
      const totalItemWidth = itemWidth + itemMargin * 2;

      // Calculate the position to center the selected item
      final viewportWidth = _scrollController.position.viewportDimension;
      final targetPosition =
          selectedIndex * totalItemWidth - (viewportWidth / 2 - itemWidth / 2);

      // Ensure we don't scroll beyond the list boundaries
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final adjustedPosition = targetPosition.clamp(0.0, maxScrollExtent);

      _scrollController.animateTo(
        adjustedPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: size.height * 0.15,
        flexibleSpace: VxArc(
          height: size.height * 0.02,
          child: Container(
            color: myColorList[selectedIndex]["color"].withOpacity(0.8),
          ),
        ),
        title: Text(
          "Let's Learn Colors!",
          style: myTextStyleCus(
            fontFamily: "mainSecond",
            fontSize: size.width * 0.08,
          ),
        ),
      ),
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
                      selectedIndex = index;
                      _scrollToSelectedIndex();
                    });
                    if (isAutoPlaying) playColorSound();
                  },
                  itemCount: myColorList.length,
                  itemBuilder: (context, index) {
                    final colorData = myColorList[index];
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }
                        return Transform.scale(
                          scale: Curves.easeOut.transform(value),
                          child: child,
                        );
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Color Circle
                            GestureDetector(
                              onTap: playColorSound,
                              child: Container(
                                width: size.width * 0.6,
                                height: size.width * 0.6,
                                decoration: BoxDecoration(
                                  color: colorData["color"],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    colorData["emoji"],
                                    style: const TextStyle(fontSize: 100),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Color Names
                            FadeTransition(
                              opacity: AlwaysStoppedAnimation(
                                _pageController.position.haveDimensions
                                    ? (1 -
                                        (_pageController.page! - index).abs())
                                    : 1.0,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    colorData["name"],
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: colorData["color"],
                                      fontFamily: 'secondary',
                                    ),
                                  ),
                                  Text(
                                    colorData["hindiName"],
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: colorData["color"],
                                      fontFamily: 'secondary',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () => previousColor(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Icon(Icons.arrow_back_ios_rounded),
                      )),
                  ElevatedButton(
                      onPressed: () => toggleAutoPlay(),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Icon(
                            isAutoPlaying ? Icons.pause : Icons.play_arrow),
                      )),
                  ElevatedButton(
                      onPressed: () => nextColor(),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Icon(Icons.arrow_forward_ios_rounded),
                      )),
                ],
              ),
              SizedBox(
                height: size.height * 0.05,
              ),

              /// Bottom Color Palette
              VxArc(
                height: size.height * 0.04,
                arcType: VxArcType.convex,
                edge: VxEdge.top,
                child: Container(
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                    color: myColorList[selectedIndex]["color"].withOpacity(0.3),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.1,
                          ),
                          itemCount: myColorList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                width: selectedIndex == index
                                    ? size.width * 0.25
                                    : size.width * 0.2,
                                height: selectedIndex == index
                                    ? size.width * 0.25
                                    : size.width * 0.2,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: myColorList[index]["color"],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedIndex == index
                                          ? Colors.black
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      myColorList[index]["emoji"],
                                      style: TextStyle(
                                        fontSize:
                                            selectedIndex == index ? 30 : 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
