import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import '../helper/app_color.dart';

class BoxMatchingGame extends StatefulWidget {
  const BoxMatchingGame({super.key});

  @override
  _BoxMatchingGameState createState() => _BoxMatchingGameState();
}

class _BoxMatchingGameState extends State<BoxMatchingGame>
    with TickerProviderStateMixin {
  // Game items with baby-friendly emojis
  final List<String> symbols = ['🐶', '🐱', '🐰', '🐻', '🐼', '🐯', '🦁', '🐮'];

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
      
        /// ----------- App bar ----------- ///
        appBar: AppBar(
          title: Text("Baby Memory Game"),
          backgroundColor: Color(0xFFe91e63),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: initGame,
              tooltip: "New Game",
            ),
          ],
        ),
      
        /// ---------- Body ------------- ///
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Color(0xFFf8bbd0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Matches: $matchesFound/${symbols.length}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Moves: $moves",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
      
            // Game grid
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
                                          width: 1.5, color: Colors.grey.shade300)
                                      : null),
                              child: Center(
                                child: angle > pi / 2
                                    ? Text(
                                        cards[index].symbol,
                                        style: const TextStyle(fontSize: 30),
                                      )
                                    : const Text(
                                        "?",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
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
      
            // Instructions
            Container(
              padding: EdgeInsets.all(16),
              color: Color(0xFFf8bbd0),
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
