import 'package:audioplayers/audioplayers.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:flutter/material.dart';

import '../../domain/custom_text_style.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialNumber;
    _pageController = PageController(initialPage: widget.initialNumber);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playNumberSound(int number) async {
    if (!_isMuted) {
      await _audioPlayer.play(AssetSource('sounds/number_$number.mp3'));
    }
  }

  Widget _buildNumberPage(int number) {
    String numberWord = _getNumberWord(number);

    return GestureDetector(
      onTap: () => playNumberSound(number),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.3),
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
                  playNumberSound(page + 1);
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: _buildNumberPage(index + 1),
                  );
                },
                itemCount: widget.maxNumber,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 40),
                    onPressed: currentPage > 0
                        ? () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                        : null,
                    color: currentPage > 0 ? Colors.blue : Colors.grey,
                  ),
                const  SizedBox(width: 40),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 40),
                    onPressed: currentPage < widget.maxNumber - 1
                        ? () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                        : null,
                    color: currentPage < widget.maxNumber - 1 ? Colors.blue : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNumberWord(int number) {
    return AppConstant.numberWords[number];
  }
}