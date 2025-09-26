import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';
import '../controller/box_matching_controller.dart';
import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';
import '../widgets/navigation_button.dart';

class BoxMatchingGame extends StatelessWidget {
  BoxMatchingGame({super.key});

  final BoxMatchingController controller = Get.put(BoxMatchingController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isTablet(BuildContext context) {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide >= 600;
    }

    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          controller.stopAll();
        },
        child: Scaffold(
          backgroundColor: Colors.white,

          /// ----------- App bar ----------- ///
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: size.height * 0.2,
            backgroundColor: Colors.white,
            flexibleSpace: VxArc(
              height: 2.5.h,
              arcType: VxArcType.convey,
              child: Container(
                color: AppColors.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          NavigationButton(onTap: () {
                            Get.back();
                            controller.stopAll();
                          }),
                          SizedBox(height: 1.h),
                          Text(
                            "Find the matching Pairs",
                            style: myTextStyle21(),
                          ),
                        ],
                      ),
                      Lottie.asset(
                        "assets/lottie_animation_file/teady_bear.json",
                        fit: BoxFit.cover,
                        height: size.height * 0.15,
                        width: size.height * 0.15,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// ---------- Body ------------- ///
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Game grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 3,
                              color: AppColors.primaryDark,
                              radius: BorderRadius.horizontal(
                                  left: Radius.circular(21)),
                            ),
                          ),
                          SizedBox(width: 1.5.h),
                          Obx(() => Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: size.height * 0.08,
                                width: size.height * 0.08,
                                child: CircularProgressIndicator(
                                  value: controller.matchesFound.value / 10,
                                  strokeWidth: 6,
                                  backgroundColor: Colors.grey.withAlpha(70),
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              Text(
                                "${controller.matchesFound.value}/10",
                                style: myTextStyle21(fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                          SizedBox(width: 1.5.h),
                          const Expanded(
                            child: Divider(
                              thickness: 3,
                              color: AppColors.primaryDark,
                              radius: BorderRadius.horizontal(
                                  right: Radius.circular(21)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Obx(() => GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet(context) ? 5 : 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: controller.cards.length,
                        itemBuilder: (context, index) {
                          final card = controller.cards[index];
                          return GestureDetector(
                            onTap: () => controller.flipCard(index),
                            child: CardFlipAnimation(
                              showAll: controller.showAll.value,
                              isFlipped: card.isFlipped,
                              symbol: card.symbol,
                            ),
                          );
                        },
                      )),
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

// Separate widget for flip animation
class CardFlipAnimation extends StatefulWidget {
  final bool showAll;
  final bool isFlipped;
  final String symbol;

  const CardFlipAnimation({
    super.key,
    required this.showAll,
    required this.isFlipped,
    required this.symbol,
  });

  @override
  State<CardFlipAnimation> createState() => _CardFlipAnimationState();
}

class _CardFlipAnimationState extends State<CardFlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start animation if card should be flipped initially
    if (widget.showAll || widget.isFlipped) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CardFlipAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate when flip state changes
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    // Handle showAll state change
    if (widget.showAll != oldWidget.showAll) {
      if (widget.showAll) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi; // 0 to 180 degrees in radians

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(angle),
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: angle > pi / 2 ? Colors.white : AppColors.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: angle > pi / 2
                  ? Border.all(width: 1.5, color: Colors.grey.shade300)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: angle > pi / 2
                  ? Text(
                widget.symbol,
                style: TextStyle(
                  fontSize: 6.h,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              )
                  : Text(
                "?",
                style: TextStyle(
                  fontSize: 5.h,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}