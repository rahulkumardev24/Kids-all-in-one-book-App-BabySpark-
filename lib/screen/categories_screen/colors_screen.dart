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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
    _scrollController = ScrollController();

    /// Center the initial selected item in the ListView
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
    // Calculate the offset to center the selected item
    if (_scrollController.hasClients) {
      const itemWidth = 50.0 + 16.0;
      final offset = selectedIndex * itemWidth -
          (MediaQuery.of(context).size.width - itemWidth) / 2;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      /// --- app bar --- ///
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
              fontFamily: "mainSecond", fontSize: size.width * 0.08),
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
              /// Main Color Display with PageView
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
                              /// Color Circle with Emoji
                              GestureDetector(
                                onTap: playColorSound,
                                child: Container(
                                  width: 250,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: colorData["color"],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            colorData["color"].withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
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
                              // Color Names with fade transition
                              FadeTransition(
                                opacity: AlwaysStoppedAnimation(_pageController
                                        .position.haveDimensions
                                    ? (1 -
                                        (_pageController.page! - index).abs())
                                    : 1.0),
                                child: Column(
                                  children: [
                                    Text(
                                      colorData["name"],
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: colorData["color"],
                                        fontFamily: 'Baloo2',
                                      ),
                                    ),
                                    Text(
                                      colorData["hindiName"],
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: colorData["color"],
                                        fontFamily: 'BalooBhai2',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              ),

              /// Bottom Color Palette with Curved ListView
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
                      /// --- color list --- ///
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
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
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: selectedIndex == index
                                    ? size.width * 0.25
                                    : size.width * 0.15,
                                margin: const EdgeInsets.all(12),
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
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      /*   /// Auto Play Button
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton.icon(
                          icon: Icon(
                            isAutoPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          label: Text(
                            isAutoPlaying ? "Stop" : "Auto Play",
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myColorList[selectedIndex]
                                ["color"],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: toggleAutoPlay,
                        ),
                      ),*/
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
