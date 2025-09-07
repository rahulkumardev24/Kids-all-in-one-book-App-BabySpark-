// lib/screen/math/daily_challenge_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babyspark/helper/daily_question_manager.dart';

class DailyChallengeScreen extends StatefulWidget {
  final Function(int) onProgressUpdate;
  final int initialProgress;

  const DailyChallengeScreen({
    super.key,
    required this.onProgressUpdate,
    required this.initialProgress,
  });

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    try {
      // Load today's questions (same set throughout the day)
      final questions = await DailyQuestionManager.getTodaysQuestions();

      // Load user's progress for today
      final prefs = await SharedPreferences.getInstance();
      final int savedProgress = prefs.getInt('today_progress') ?? 0;
      final int savedQuestionIndex = prefs.getInt('current_question_index') ?? 0;

      setState(() {
        _questions = questions;
        _score = widget.initialProgress;
        _currentQuestionIndex = savedQuestionIndex;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback if there's an error
      setState(() {
        _questions = _getFallbackQuestions();
        _score = widget.initialProgress;
        _isLoading = false;
      });
    }
  }

  void _checkAnswer(int selectedIndex) async {
    if (_currentQuestionIndex >= _questions.length) return;

    final currentQuestion = _questions[_currentQuestionIndex];
    final bool isCorrect = selectedIndex == currentQuestion['correctIndex'];

    if (isCorrect) {
      setState(() {
        _score++;
      });

      // Save progress
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('today_progress', _score);

      // Update parent component
      widget.onProgressUpdate(_score);

      // Move to next question or complete
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
        // Save current question index
        await prefs.setInt('current_question_index', _currentQuestionIndex);
      } else {
        _showCompletionDialog();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Try again! 🌟'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 Amazing! 🎉'),
          content: Text('You completed today\'s challenge!\nScore: $_score/${_questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFallbackQuestions() {
    return [
      {
        'question': 'How many apples?',
        'emoji': '🍎🍎',
        'options': ['1', '2', '3', '4'],
        'correctIndex': 1,
      },
      {
        'question': 'What is 1 + 1?',
        'emoji': '➕',
        'options': ['1', '2', '3', '4'],
        'correctIndex': 1,
      }
    ];
  }

  void _resetDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('today_progress');
    await prefs.remove('current_question_index');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily Challenge')),
        body: const Center(child: Text('No questions available today.')),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenge'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            const SizedBox(height: 20),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion['question'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion['emoji'],
              style: const TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: List.generate(
                  currentQuestion['options'].length,
                      (index) => ElevatedButton(
                    onPressed: () => _checkAnswer(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      currentQuestion['options'][index],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $_score/${_questions.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up when screen is disposed
    super.dispose();
  }
}