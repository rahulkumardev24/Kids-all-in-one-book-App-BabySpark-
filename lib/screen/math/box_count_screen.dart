import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class BoxCountScreen extends StatefulWidget {
  const BoxCountScreen({super.key});

  @override
  State<BoxCountScreen> createState() => _BoxCountScreenState();
}

class _BoxCountScreenState extends State<BoxCountScreen> {
  final Random _random = Random();

  int boxCount = 0;
  List<int> options = [];
  int? selectedAnswer;
  bool? isCorrect;
  int questionIndex = 1;
  int totalQuestions = 10;
  int score = 0;
  List<Color> boxColors = [];

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    setState(() {
      boxCount = _random.nextInt(10) + 1;
      options = [];
      options.add(boxCount);

      ///------ Generate 3 wrong answers ----- ///
      while (options.length < 4) {
        int wrong = _random.nextInt(5) + 1;
        if (!options.contains(wrong)) {
          options.add(wrong);
        }
      }

      options.shuffle();
      selectedAnswer = null;
      isCorrect = null;

    });
  }


  void checkAnswer(int answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = (answer == boxCount);

      if (isCorrect!) {
        score++;
      }
    });

    // Move to next question after delay
    Timer(const Duration(seconds: 2), () {
      if (questionIndex < totalQuestions) {
        setState(() {
          questionIndex++;
        });
        generateQuestion();
      } else {
        // Game completed
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return GameCompletedDialog(
                score: score, totalQuestions: totalQuestions);
          },
        );
      }
    });
  }

  void restartGame() {
    setState(() {
      questionIndex = 1;
      score = 0;
    });
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size ;
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,

      /// --------- Appbar --------------- ///
      appBar: AppBar(
        title: const Text("Count And Select Number"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "Score: $score",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          /// Progress bar and question counter - FIXED LAYOUT
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.pink.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question $questionIndex/$totalQuestions",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: LinearProgressIndicator(
                      value: questionIndex / totalQuestions,
                      backgroundColor: Colors.white,
                      color: Colors.purple,
                      minHeight: 15,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Instruction text
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "How many boxes do you see?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                /// Show Boxes with fun animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      boxCount,
                      (index) => Image.asset(
                          height: size.height * 0.11,
                          width: size.height * 0.11,
                          fit: BoxFit.cover,
                          "assets/images/ball.webp"),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// --- Show options --- ///
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: options.map((e) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAnswer == e
                            ? (isCorrect == true ? Colors.green : Colors.red)
                            : Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed:
                          selectedAnswer == null ? () => checkAnswer(e) : null,
                      child: Text(
                        e.toString(),
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Correct / Wrong Indicator with fun animations
                if (isCorrect != null)
                  AnimatedScale(
                    scale: isCorrect! ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      isCorrect! ? "🎉 Yay! Correct!" : "😢 Try again!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isCorrect! ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      /// Play Again Button
      floatingActionButton: questionIndex == totalQuestions
          ? FloatingActionButton.extended(
              onPressed: restartGame,
              icon: const Icon(Icons.refresh),
              label: const Text("Play Again"),
              backgroundColor: Colors.pinkAccent,
            )
          : null,
    );
  }
}

class GameCompletedDialog extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const GameCompletedDialog({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Game Completed!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "You got $score out of $totalQuestions correct!",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.emoji_events,
              size: 100,
              color: score > totalQuestions / 2 ? Colors.amber : Colors.blue,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Restart game by popping the dialog and letting the floating action button handle restart
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: const Text("Play Again"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
