import 'package:audioplayers/audioplayers.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/service/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:async';

import '../widgets/simple_text_button.dart';

class BoxMatchingController extends GetxController {
  // Reactive variables
  var cards = <CardItem>[].obs;
  var flippedCount = 0.obs;
  var matchesFound = 0.obs;
  var showAll = true.obs;
  var moves = 0.obs;

  // Non-reactive variables
  CardItem? firstCard;
  CardItem? secondCard;
  Timer? showAllTimer;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    initGame();

    ///
    TTSService.speak("Find the matching Pairs");
  }

  @override
  void onClose() {
    showAllTimer?.cancel();
    audioPlayer.dispose(); // Dispose audio player
    super.onClose();
  }

  /// Initialize the game
  void initGame() {
    // Create pairs of cards
    List<String> gameSymbols = [];
    gameSymbols.addAll(AppConstant.pairSymbols);
    gameSymbols.addAll(AppConstant.pairSymbols);
    gameSymbols.shuffle();

    showAllTimer?.cancel();

    cards.value = gameSymbols
        .map((symbol) =>
            CardItem(symbol: symbol, isFlipped: false, isMatched: false))
        .toList();

    flippedCount.value = 0;
    firstCard = null;
    secondCard = null;
    matchesFound.value = 0;
    moves.value = 0;
    showAll.value = true;

    // Show all cards for 3 seconds before flipping them back
    showAllTimer = Timer(const Duration(seconds: 3), () {
      showAll.value = false;
      for (var card in cards) {
        card.isFlipped = false;
      }
      cards.refresh();
    });
  }

  // stop all
  void stopAll() {
    TTSService.stop();
    audioPlayer.stop(); // Stop any playing audio
    Get.delete<BoxMatchingController>();
  }

  // Handle card flip
  void flipCard(int index) {
    // Don't allow flipping if already matched or if two cards are already flipped
    if (cards[index].isMatched ||
        cards[index].isFlipped ||
        (firstCard != null && secondCard != null)) {
      return;
    }

    // Play click sound
    audioPlayer.play(AssetSource("audio/tap.mp3"));

    cards[index].isFlipped = true;
    cards.refresh();

    flippedCount.value++;

    if (firstCard == null) {
      firstCard = cards[index];
    } else {
      secondCard = cards[index];
      moves.value++;
      checkMatch();
    }
  }

  void checkMatch() {
    if (firstCard != null && secondCard != null) {
      if (firstCard!.symbol == secondCard!.symbol) {
        audioPlayer.play(AssetSource("audio/correct.mp3"));
        // Match found
        firstCard!.isMatched = true;
        secondCard!.isMatched = true;
        matchesFound.value++;

        // Check if game is complete
        if (matchesFound.value == AppConstant.pairSymbols.length) {
          // Game completed
          Timer(const Duration(seconds: 1), () {
            audioPlayer.play(AssetSource("audio/complete.mp3"));
            Get.dialog(
              AlertDialog(
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
                              SizedBox(
                                width: Get.width * 0.3,
                                child: SimpleTextButton(
                                    onPress: () {
                                      Get.back();
                                      Get.back();
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
                                      Get.back();
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
        flippedCount.value = 0;
        cards.refresh();
      } else {
        // No match - flip cards back after a delay
        audioPlayer.play(AssetSource("audio/wrong.mp3"));

        Timer(const Duration(milliseconds: 800), () {
          firstCard!.isFlipped = false;
          secondCard!.isFlipped = false;
          firstCard = null;
          secondCard = null;
          flippedCount.value = 0;
          cards.refresh();
        });
      }
    }
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
