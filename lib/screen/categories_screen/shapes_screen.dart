import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ShapesScreen extends StatefulWidget {
  const ShapesScreen({super.key});

  @override
  State<ShapesScreen> createState() => _ShapesScreenState();
}

class _ShapesScreenState extends State<ShapesScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> shapes = [
    {
      'name': 'Circle',
      'color': Colors.red,
      'icon': Icons.circle,
      'animal': '🐘',
      'bgColor': Colors.red[50],
    },
    {
      'name': 'Square',
      'color': Colors.blue,
      'icon': Icons.square,
      'animal': '🦁',
      'bgColor': Colors.blue[50],
    },
    {
      'name': 'Triangle',
      'color': Colors.green,
      'icon': Icons.change_history,
      'animal': '🐵',
      'bgColor': Colors.green[50],
    },
    {
      'name': 'Star',
      'color': Colors.amber,
      'icon': Icons.star,
      'animal': '🐶',
      'bgColor': Colors.amber[50],
    },
    {
      'name': 'Heart',
      'color': Colors.pink,
      'icon': Icons.favorite,
      'animal': '🐰',
      'bgColor': Colors.pink[50],
    },
  ];

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late ConfettiController _confettiController;
  int _currentIndex = 0;
  int _tapCount = 0;
  bool _isAutoPlaying = false;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _bounceAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
      ],
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _nextShape() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % shapes.length;
      _tapCount = 0;
    });
    _bounceController.forward(from: 0.0);
  }

  void _previousShape() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % shapes.length;
      if (_currentIndex < 0) _currentIndex = shapes.length - 1;
      _tapCount = 0;
    });
    _bounceController.forward(from: 0.0);
  }

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
      if (_isAutoPlaying) {
        _startAutoPlay();
      }
    });
  }

  void _startAutoPlay() async {
    while (_isAutoPlaying && mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!_isAutoPlaying || !mounted) return;
      _nextShape();
    }
  }

  void _handleShapeTap() {
    setState(() {
      _tapCount++;
      if (_tapCount >= 3) {
        _confettiController.play();
        _tapCount = 0;
      }
    });
    _bounceController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final currentShape = shapes[_currentIndex];
    final screenSize = MediaQuery.of(context).size;
    final shapeSize = screenSize.width * 0.7;

    return Stack(
      children: [
        // Background with gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                currentShape['bgColor'],
                Colors.white,
              ],
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                // Animal character header
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    currentShape['animal'],
                    style: const TextStyle(fontSize: 80),
                  ),
                ),

                // Shape display area
                Expanded(
                  child: GestureDetector(
                    onTap: _handleShapeTap,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Bouncing shape with shadow
                          ScaleTransition(
                            scale: _bounceAnimation,
                            child: Container(
                              width: shapeSize,
                              height: shapeSize,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: currentShape['name'] == 'Circle'
                                    ? BoxShape.circle
                                    : BoxShape.rectangle,
                                borderRadius:
                                    _getBorderRadius(currentShape['name']),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        currentShape['color'].withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                                border: Border.all(
                                  color: currentShape['color'],
                                  width: 8,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  currentShape['icon'],
                                  size: shapeSize * 0.7,
                                  color: currentShape['color'],
                                ),
                              ),
                            ),
                          ),

                          // Shape name with cute style
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              currentShape['name'],
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: currentShape['color'],
                                fontFamily: 'ComicNeue',
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(3, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous button
                      FloatingActionButton(
                        backgroundColor: currentShape['color'],
                        onPressed: _previousShape,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      // Auto-play toggle button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAutoPlaying
                              ? Colors.green
                              : currentShape['color'],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        onPressed: _toggleAutoPlay,
                        child: Text(
                          _isAutoPlaying ? 'AUTO ON' : 'AUTO OFF',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Next button
                      FloatingActionButton(
                        backgroundColor: currentShape['color'],
                        onPressed: _nextShape,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Confetti celebration
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.pink,
              Colors.purple
            ],
          ),
        ),
      ],
    );
  }

  BorderRadius? _getBorderRadius(String shapeName) {
    switch (shapeName) {
      case 'Circle':
        return null;
      case 'Triangle':
        return BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: const Radius.circular(30),
          bottomRight: const Radius.circular(30),
        );
      default:
        return BorderRadius.circular(30);
    }
  }
}
