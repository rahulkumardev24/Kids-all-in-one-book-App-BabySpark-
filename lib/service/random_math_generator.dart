// Update lib/helper/random_math_generator.dart
import 'dart:math';

class RandomMathGenerator {
  static final Random _random = Random();

  // Use simple lists instead of complex objects
  static const List<String> _countingEmojis = ['🐶', '🐱', '🐰', '🐻', '🐼'];
  static const List<String> _fruitEmojis = ['🍎', '🍐', '🍊', '🍋', '🍌'];

  // Simplified question types with lower weights
  static const List<Map<String, dynamic>> _questionTypes = [
    {'type': 'Counting', 'weight': 3},
    {'type': 'Addition', 'weight': 2},
    {'type': 'Subtraction', 'weight': 2},
    {'type': 'Number Recognition', 'weight': 1},
  ];

  static Map<String, dynamic> generateRandomQuestion() {
    try {
      // Randomly select a question type based on weights
      String selectedType = _selectRandomType();

      // Generate question based on type
      switch (selectedType) {
        case 'Counting':
          return _generateCountingQuestion();
        case 'Addition':
          return _generateAdditionQuestion();
        case 'Subtraction':
          return _generateSubtractionQuestion();
        case 'Number Recognition':
          return _generateNumberRecognitionQuestion();
        default:
          return _generateCountingQuestion();
      }
    } catch (e) {
      // Fallback to a simple question if anything fails
      return {
        'type': 'Counting',
        'question': 'How many apples?',
        'emoji': '🍎🍎',
        'options': ['1', '2', '3', '4'],
        'correctIndex': 1,
      };
    }
  }

  static String _selectRandomType() {
    int totalWeight = _questionTypes.fold(0, (sum, type) => sum + (type['weight'] as int));
    int randomWeight = _random.nextInt(totalWeight);

    int cumulativeWeight = 0;
    for (var type in _questionTypes) {
      cumulativeWeight += type['weight'] as int;
      if (randomWeight < cumulativeWeight) {
        return type['type'] as String;
      }
    }

    return 'Counting'; // Fallback
  }

  static Map<String, dynamic> _generateCountingQuestion() {
    int count = _random.nextInt(3) + 2; // 2 to 4 items (reduced complexity)
    int correctAnswer = count;
    String emoji = _countingEmojis[_random.nextInt(_countingEmojis.length)];

    List<int> options = _generateOptions(correctAnswer, 1, 6);

    return {
      'type': 'Counting',
      'question': 'How many ${emoji} do you see?',
      'emoji': List.generate(count, (index) => emoji).join(),
      'options': options.map((n) => n.toString()).toList(),
      'correctIndex': options.indexOf(correctAnswer),
    };
  }

  static Map<String, dynamic> _generateAdditionQuestion() {
    int a = _random.nextInt(3) + 1; // 1 to 3
    int b = _random.nextInt(3) + 1; // 1 to 3
    int correctAnswer = a + b;
    String emoji = _fruitEmojis[_random.nextInt(_fruitEmojis.length)];

    List<int> options = _generateOptions(correctAnswer, 2, 6);

    return {
      'type': 'Addition',
      'question': 'What is $a + $b?',
      'emoji': '${List.generate(a, (index) => emoji).join()} + ${List.generate(b, (index) => emoji).join()}',
      'options': options.map((n) => n.toString()).toList(),
      'correctIndex': options.indexOf(correctAnswer),
    };
  }

  static Map<String, dynamic> _generateSubtractionQuestion() {
    int a = _random.nextInt(2) + 3; // 3 to 4
    int b = _random.nextInt(2) + 1; // 1 to 2
    int correctAnswer = a - b;
    String emoji = _fruitEmojis[_random.nextInt(_fruitEmojis.length)];

    List<int> options = _generateOptions(correctAnswer, 1, 4);

    return {
      'type': 'Subtraction',
      'question': 'What is $a - $b?',
      'emoji': '${List.generate(a, (index) => emoji).join()} - ${List.generate(b, (index) => emoji).join()}',
      'options': options.map((n) => n.toString()).toList(),
      'correctIndex': options.indexOf(correctAnswer),
    };
  }

  static Map<String, dynamic> _generateNumberRecognitionQuestion() {
    int correctNumber = _random.nextInt(5) + 1; // 1 to 5
    List<int> options = _generateOptions(correctNumber, 1, 6);

    return {
      'type': 'Number Recognition',
      'question': 'Find the number $correctNumber',
      'emoji': '🔢',
      'options': options.map((n) => n.toString()).toList(),
      'correctIndex': options.indexOf(correctNumber),
    };
  }

  static List<int> _generateOptions(int correctAnswer, int min, int max) {
    Set<int> options = {correctAnswer};

    while (options.length < 4) {
      int option;
      // Generate options that are different from correct answer
      do {
        int offset = _random.nextInt(3) - 1; // -1 to +1 range (simpler)
        option = correctAnswer + offset;
        if (option < min) option = min;
        if (option > max) option = max;
      } while (options.contains(option));

      options.add(option);
    }

    List<int> optionList = options.toList();
    optionList.shuffle();
    return optionList;
  }

  static List<Map<String, dynamic>> getDailyQuestions() {
    List<Map<String, dynamic>> questions = [];

    // REDUCED from 20 to 8 questions to prevent memory issues
    for (int i = 0; i < 10; i++) {
      questions.add(generateRandomQuestion());
    }

    return questions;
  }
}