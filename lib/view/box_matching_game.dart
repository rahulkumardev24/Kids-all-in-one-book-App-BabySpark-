import 'package:babyspark/helper/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:async';
import 'dart:math';
import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';
import '../widgets/navigation_button.dart';
import '../widgets/simple_text_button.dart';

class BoxMatchingGame extends StatefulWidget {
  const BoxMatchingGame({super.key});

  @override
  _BoxMatchingGameState createState() => _BoxMatchingGameState();
}

class _BoxMatchingGameState extends State<BoxMatchingGame>
    with TickerProviderStateMixin {
  // Game state
  List<CardItem> cards = [];
  int flippedCount = 0;
  CardItem? firstCard;
  CardItem? secondCard;
  int matchesFound = 0;
  bool showAll = true;
  Timer? showAllTimer;
  int moves = 0;

  // Animation controllers for each card
  List<AnimationController> controllers = [];

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  void dispose() {
    showAllTimer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Initialize the game
  void initGame() {
    // Create pairs of cards
    List<String> gameSymbols = [];
    gameSymbols.addAll(AppConstant.pairSymbols);
    gameSymbols.addAll(AppConstant.pairSymbols);
    gameSymbols.shuffle();

    // Dispose existing controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();

    setState(() {
      cards = gameSymbols
          .map((symbol) =>
              CardItem(symbol: symbol, isFlipped: false, isMatched: false))
          .toList();

      // Create animation controllers for each card
      for (int i = 0; i < cards.length; i++) {
        controllers.add(AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: this,
        ));
      }

      flippedCount = 0;
      firstCard = null;
      secondCard = null;
      matchesFound = 0;
      moves = 0;
      showAll = true;
    });

    // Show all cards for 3 seconds before flipping them back
    showAllTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        showAll = false;
        for (var card in cards) {
          card.isFlipped = false;
        }

        // Flip all cards back with animation
        for (int i = 0; i < controllers.length; i++) {
          controllers[i].reverse();
        }
      });
    });
  }

  // Handle card flip
  void flipCard(int index) {
    // Don't allow flipping if already matched or if two cards are already flipped
    if (cards[index].isMatched ||
        cards[index].isFlipped ||
        (firstCard != null && secondCard != null)) {
      return;
    }

    // Start flip animation for this specific card
    controllers[index].forward();

    setState(() {
      cards[index].isFlipped = true;
      flippedCount++;

      if (firstCard == null) {
        firstCard = cards[index];
      } else {
        secondCard = cards[index];
        moves++;
        checkMatch();
      }
    });
  }

  // Check if the two flipped cards match
  void checkMatch() {
    if (firstCard != null && secondCard != null) {
      if (firstCard!.symbol == secondCard!.symbol) {
        // Match found
        setState(() {
          firstCard!.isMatched = true;
          secondCard!.isMatched = true;
          matchesFound++;

          // Check if game is complete
          if (matchesFound == AppConstant.pairSymbols.length) {
            // Game completed
            Timer(const Duration(seconds: 1), () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: SizedBox(
                    height: 40.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Lottie.asset("assets/lottie_animation_file/win.json"),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/images/winner_cup.png",
                              height: 20.h,
                            ),

                            /// ------- Buttons --------- ///
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SimpleTextButton(
                                      onPress: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      btnBackgroundColor: Colors.grey.shade400,
                                      btnText: "Exit"),
                                ),
                                SizedBox(
                                  width: 2.h,
                                ),
                                Expanded(
                                  child: SimpleTextButton(
                                      btnText: "Play Again",
                                      onPress: () {
                                        initGame();
                                        Navigator.pop(context);
                                      }),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          }

          firstCard = null;
          secondCard = null;
          flippedCount = 0;
        });
      } else {
        // No match - flip cards back after a delay
        Timer(const Duration(milliseconds: 800), () {
          // Find the indices of the first and second cards
          int firstIndex = cards.indexWhere((card) => card == firstCard);
          int secondIndex = cards.indexWhere((card) => card == secondCard);

          if (firstIndex != -1) controllers[firstIndex].reverse();
          if (secondIndex != -1) controllers[secondIndex].reverse();

          setState(() {
            firstCard!.isFlipped = false;
            secondCard!.isFlipped = false;
            firstCard = null;
            secondCard = null;
            flippedCount = 0;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isTablet(BuildContext context) {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide >= 600;
    }

    return SafeArea(
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
                        NavigationButton(onTap: () => Navigator.pop(context)),

                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Find the matching Pairs",
                          style: myTextStyle21(),
                        ),

                        /// Progress bar and question counter - FIXED LAYOUT
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
                        SizedBox(
                          width: 1.5.h,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: size.height * 0.08,
                              width: size.height * 0.08,
                              child: CircularProgressIndicator(
                                value: matchesFound / 10,
                                strokeWidth: 6,
                                backgroundColor: Colors.grey.withAlpha(70),
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text(
                              "$matchesFound/10",
                              style: myTextStyle21(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 1.5.h,
                        ),
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
                    SizedBox(
                      height: 3.h,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet(context) ? 5 : 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => flipCard(index),
                          child: AnimatedBuilder(
                            animation: controllers[index],
                            builder: (context, child) {
                              // Calculate flip animation value
                              double angle = controllers[index].value * pi;

                              // If we're showing all cards at the beginning, show them flipped
                              if (showAll) {
                                angle = pi;
                              }

                              return Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(angle),
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: angle > pi / 2
                                          ? Colors.white
                                          : AppColors.primaryDark,
                                      borderRadius: BorderRadius.circular(10),
                                      border: angle > pi / 2
                                          ? BoxBorder.all(
                                              width: 1.5,
                                              color: Colors.grey.shade300)
                                          : null),
                                  child: Center(
                                    child: angle > pi / 2
                                        ? Text(
                                            cards[index].symbol,
                                            style: TextStyle(fontSize: 6.h),
                                          )
                                        : const Text(
                                            "?",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textColor,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardItem {
  final String symbol;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.symbol,
    required this.isFlipped,
    required this.isMatched,
  });
}
