import 'dart:async';

import 'package:babyspark/helper/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../domain/custom_text_style.dart';
import '../../helper/app_color.dart';
import '../../widgets/control_icon_button.dart';

class NumberDetailScreen extends StatefulWidget {
  final int initialNumber;
  final int maxNumber;

  const NumberDetailScreen({
    super.key,
    required this.initialNumber,
    required this.maxNumber,
  });

  @override
  _NumberDetailScreenState createState() => _NumberDetailScreenState();
}

class _NumberDetailScreenState extends State<NumberDetailScreen> {
  late PageController _pageController;
  late int currentPage;
  bool _isMuted = false;
  Timer? _timer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialNumber;
    _pageController = PageController(initialPage: widget.initialNumber);
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentPage < widget.maxNumber - 1) {
        currentPage++;
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _stopAutoPlay();
      }
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildNumberPage(int number) {
    String numberWord = _getNumberWord(number);
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$number',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              Text(
                numberWord,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Number ${currentPage + 1}',
            style: myTextStyle22(fontFamily: "secondary")),
        backgroundColor: Colors.lightBlue[100],
        actions: [
          IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
            onPressed: () {
              setState(() => _isMuted = !_isMuted);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue[100]!, Colors.orange.shade100],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: _buildNumberPage(index + 1),
                  );
                },
                itemCount: widget.maxNumber,
              ),
            ),

            /// --- Footer part --- ///
            Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie_animation_file/water_wave.json",
                  fit: BoxFit.cover,
                  width: size.width,
                ),
                Positioned(
                    left: 0,

                    child: Lottie.asset("assets/lottie_animation_file/fishing_new.json" ,
                        height: size.height * 0.3
                    )),

                Positioned(
                  bottom: -20,
                  child: Lottie.asset(
                    "assets/lottie_animation_file/Fish Animation.json",
                    fit: BoxFit.cover,
                    width: size.width,
                  ),
                ),



                Positioned(
                  right: -120,
                  bottom: -50,
                  child: Lottie.asset("assets/lottie_animation_file/Palm Tree Leaf Animation.json" ,
                    height: size.height * 0.3
                  ),
                ),


                /// control button
                Positioned(
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ControlIconButton(
                            icon: Icons.arrow_back_rounded,
                            iconSize: isTablet(context) ? 32 : 21,
                            color: AppColors.primaryDark,
                            isRounded: false,
                            onPressed: currentPage > 0
                                ? () {
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
                          ),
                          ControlIconButton(
                            color: _isPlaying ? Colors.green : Colors.black,
                            icon: _isPlaying
                                ? CupertinoIcons.pause_solid
                                : CupertinoIcons.play_arrow_solid,
                            iconSize: isTablet(context) ? 36 : 27,
                            iconColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                _isPlaying = !_isPlaying;
                                if (_isPlaying) {
                                  _startAutoPlay();
                                } else {
                                  _stopAutoPlay();
                                }
                              });
                            },
                          ),
                          ControlIconButton(
                            icon: Icons.arrow_forward_rounded,
                            iconSize: isTablet(context) ? 32 : 21,
                            color: AppColors.primaryDark,
                            isRounded: false,
                            onPressed: currentPage < widget.maxNumber - 1
                                ? () {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getNumberWord(int number) {
    return AppConstant.numberWords[number];
  }
}
