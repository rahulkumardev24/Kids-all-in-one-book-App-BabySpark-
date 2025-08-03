import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:babyspark/domain/custom_text_style.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Numbers', style: myTextStyle22(fontFamily: "secondary")),
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
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
          children: [
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
