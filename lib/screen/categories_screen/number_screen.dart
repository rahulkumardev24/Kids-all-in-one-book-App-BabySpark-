import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import '../../helper/app_color.dart';
import '../../widgets/number_tile.dart';
import '../number/number_detail_screen.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Color> _numberColors = [
    Colors.redAccent,
    Colors.indigo,
    Colors.blue,
    Colors.orange
  ];

  List<int> _displayedNumbers = List.generate(20, (index) => index + 1);
  bool _isLoadingMore = false;
  bool _isPlayingSound = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playNumberSound(int number) async {
    if (_isPlayingSound) return;

    setState(() => _isPlayingSound = true);
    try {
      await _audioPlayer.play(AssetSource('sounds/number_$number.mp3'));
    } finally {
      if (mounted) {
        setState(() => _isPlayingSound = false);
      }
    }
  }

  void _loadMoreNumbers() {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        final lastNumber = _displayedNumbers.last;
        _displayedNumbers
            .addAll(List.generate(20, (index) => lastNumber + index + 1));
        _isLoadingMore = false;
      });
    });
  }

  void _navigateToNumberDetail(BuildContext context, int number) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NumberDetailScreen(
          initialNumber: number - 1,
          maxNumber: _displayedNumbers.last,
        ),
      ),
    );
  }

  /// Tablet
  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            /// Header
            Container(
              color: AppColors.babyBlue.withValues(alpha: 0.5),
              height: size.height * 0.2,
              child: Stack(
                children: [
                  /// navigation button -> back button
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Number",
                          style: myTextStyleCus(
                            fontSize: isTablet(context) ? 32 : 24,
                            fontFamily: "primary",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Lottie.asset(
                      "assets/lottie_animation_file/Birds_in_the_sky.json"),

                  /// rainbow
                  Positioned(
                    bottom: -10,
                    child: Lottie.asset(
                      "assets/lottie_animation_file/Sunrise - Breathe in Breathe out.json",
                      width: size.width,
                      fit: BoxFit.cover,
                    ),
                  ),

                  NavigationButton(onTap: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: _displayedNumbers.length,
                itemBuilder: (context, index) {
                  return NumberTile(
                    number: _displayedNumbers[index],
                    color: _numberColors[index % _numberColors.length],
                    isTablet: isTablet(context),
                    onTap: () {
                      _playNumberSound(_displayedNumbers[index]);
                      _navigateToNumberDetail(
                          context, _displayedNumbers[index]);
                    },
                  );
                },
              ),
            ),
            _isLoadingMore
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _loadMoreNumbers,
                    child: const Text(
                      'Learn More Numbers',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
