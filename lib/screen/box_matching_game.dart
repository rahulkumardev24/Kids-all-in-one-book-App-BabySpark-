import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:async';
import 'dart:math';

import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';
import '../widgets/navigation_button.dart';

class BoxMatchingGame extends StatefulWidget {
  const BoxMatchingGame({super.key});

  @override
  _BoxMatchingGameState createState() => _BoxMatchingGameState();
}

class _BoxMatchingGameState extends State<BoxMatchingGame>
    with TickerProviderStateMixin {
  // Game items with baby-friendly emojis
  final List<String> symbols = [
    '🐶',
    '🐱',
    '🐰',
    '🏀',
    '🐼',
    '✈️',
    '🦁',
    '❤️',
    '🌳',
    '🏠'
  ];

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
    gameSymbols.addAll(symbols);
    gameSymbols.addAll(symbols);
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
    showAllTimer = Timer(Duration(seconds: 3), () {
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
          if (matchesFound == symbols.length) {
            // Game completed
            Timer(Duration(seconds: 1), () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Yay! You won! 🎉"),
                  content: Text("You found all matches in $moves moves!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        initGame();
                      },
                      child: Text("Play Again"),
                    ),
                  ],
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
        Timer(Duration(milliseconds: 800), () {
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavigationButton(onTap: () => Navigator.pop(context)),
                        Text(
                          "Find Pari",
                          style: myTextStyle21(),
                        ),

                        /// Progress bar and question counter - FIXED LAYOUT
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade500),
                              borderRadius: BorderRadiusGeometry.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.04,
                                        width: size.height * 0.04,
                                        child: CircularProgressIndicator(
                                          value: matchesFound / 10,
                                          strokeWidth: 4,
                                          backgroundColor:
                                          Colors.grey.withAlpha(70),
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                      Text(
                                        "$matchesFound/$moves",
                                        style: myTextStyle12(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Questions",
                                  style: myTextStyle21(
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Lottie.asset(
                      "assets/lottie_animation_file/Boy looking .json",
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Game grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
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
                              ..setEntry(3, 2, 0.001) // Perspective
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
                                        style:  TextStyle(fontSize:7.h),
                                      )
                                    : const Text(
                                        "?",
                                        style: TextStyle(
                                          fontSize:30 ,
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
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Color(0xFFf8bbd0),
                  borderRadius: BorderRadiusGeometry.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: const Text(
                "Find the matching pairs!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
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
