// lib/helper/daily_question_manager.dart
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuestionManager {
  static final Random _random = Random();

  // Simple question templates
  static final List<Map<String, dynamic>> _questionTemplates = [
    {
      'type': 'Counting',
      'template': (data) => 'How many ${data['emoji']} do you see?',
      'emoji': const ['🐶', '🐱', '🐰', '🐻', '🐼'],
      'countRange': const [2, 5]
    },
    {
      'type': 'Addition',
      'template': (data) => 'What is ${data['a']} + ${data['b']}?',
      'range': const [1, 4]
    },
    {
      'type': 'Subtraction',
      'template': (data) => 'What is ${data['a']} - ${data['b']}?',
      'range': const [3, 5]
    },
    {
      'type': 'Number Recognition',
      'template': (data) => 'Find the number ${data['number']}',
      'range': const [1, 6]
    }
  ];

  // Get or create today's questions
  static Future<List<Map<String, dynamic>>> getTodaysQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayKey = _getTodayKey();

    // Check if we already have questions for today
    final String? savedQuestions = prefs.getString('questions_$todayKey');

    if (savedQuestions != null) {
      // Parse and return saved questions
      try {
        final List<dynamic> questionsJson = json.decode(savedQuestions);
        return questionsJson.map((q) => Map<String, dynamic>.from(q)).toList();
      } catch (e) {
        // If parsing fails, generate new questions
        return _generateAndSaveQuestions(prefs, todayKey);
      }
    } else {
      // Generate and save new questions for today
      return _generateAndSaveQuestions(prefs, todayKey);
    }
  }

  // Generate and save questions for today
  static List<Map<String, dynamic>> _generateAndSaveQuestions(
      SharedPreferences prefs, String todayKey) {
    final questions = _generateQuestions(10); // Generate 10 questions
    prefs.setString('questions_$todayKey', json.encode(questions));
    return questions;
  }

  // Generate unique key for today's date
  static String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  // Generate questions
  static List<Map<String, dynamic>> _generateQuestions(int count) {
    final List<Map<String, dynamic>> questions = [];

    for (int i = 0; i < count; i++) {
      final template = _questionTemplates[_random.nextInt(_questionTemplates.length)];
      questions.add(_createQuestionFromTemplate(template));
    }

    return questions;
  }

  // Create a question from template
  static Map<String, dynamic> _createQuestionFromTemplate(Map<String, dynamic> template) {
    switch (template['type']) {
      case 'Counting':
        return _createCountingQuestion(template);
      case 'Addition':
        return _createAdditionQuestion(template);
      case 'Subtraction':
        return _createSubtractionQuestion(template);
      case 'Number Recognition':
        return _createNumberRecognitionQuestion(template);
      default:
        return _createCountingQuestion(template);
    }
  }

  static Map<String, dynamic> _createCountingQuestion(Map<String, dynamic> template) {
    final emoji = template['emoji'][_random.nextInt(template['emoji'].length)];
    final countRange = template['countRange'] as List<int>;
    final count = countRange[0] + _random.nextInt(countRange[1] - countRange[0] + 1);

    final correctAnswer = count;
    final options = _generateOptions(correctAnswer, 1, countRange[1] + 2);

    return {
      'type': 'Counting',
      'question': 'How many $emoji do you see?',
      'emoji': List.generate(count, (index) => emoji).join(),
      'options': options.map((n) => n.toString()).toList(),
      'correctIndex': options.indexOf(correctAnswer),
    };
  }

  static Map<String, dynamic> _createAdditionQuestion(Map<String, dynamic> template) {
    final range = template['range'] as List<int>;
    final a = range[0] + _random.nextInt(range[1] - range[0] + 1);
    final b = range[0] + _random.nextInt(range[1] - range[0] + 1);
    final correctAnswer = a + b;
    final options = _generateOptions(correctAnswer, 2, range[1] * 2 + 2);

    return {
      'type': 'Addition',
      'question': 'What is $a + $b?',
      'emoji': '➕',
      'options': options.map((n) => n.toString()).toList(),
      'correctIndex': options.indexOf(correctAnswer),
    };
  }

  static Map<String, dynamic> _createSubtractionQuestion(Map<String, dynamic> template) {
    final range = template['range'] as List<int>;
    final a = range[0] + _random.nextInt(range[1] - range[0] + 1);
    final b = _random.nextInt(a - 1) + 1; // Ensure b is less than a
    final correctAnswer = a - b;
    final options = _generateOptions(correctAnswer, 1, a + 2);

    return {
      'type': 'Subtraction',
      'question': 'What is $a - $b?',
      'emoji': '➖',
      'options': options.map((n) => n.toString()).toList(),
      'correctIndex': options.indexOf(correctAnswer),
    };
  }

  static Map<String, dynamic> _createNumberRecognitionQuestion(Map<String, dynamic> template) {
    final range = template['range'] as List<int>;
    final correctNumber = range[0] + _random.nextInt(range[1] - range[0] + 1);
    final options = _generateOptions(correctNumber, 1, range[1] + 2);

    return {
      'type': 'Number Recognition',
      'question': 'Find the number $correctNumber',
      'emoji': '🔢',
      'options': options.map((n) => n.toString()).toList(),
      'correctIndex': options.indexOf(correctNumber),
    };
  }

  static List<int> _generateOptions(int correctAnswer, int min, int max) {
    final Set<int> options = {correctAnswer};

    while (options.length < 4) {
      final option = min + _random.nextInt(max - min + 1);
      if (!options.contains(option)) {
        options.add(option);
      }
    }

    final List<int> optionList = options.toList();
    optionList.shuffle();
    return optionList;
  }
}