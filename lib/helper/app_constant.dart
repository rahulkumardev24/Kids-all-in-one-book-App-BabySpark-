import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/math/addition_screen.dart';
import '../screen/math/division_screen.dart';
import '../screen/math/multiplication_screen.dart';
import '../screen/math/subtraction_screen.dart';
import 'app_color.dart';

class AppConstant {
  static final List<Map<String, dynamic>> categories = [
    {
      "title": "Alphabets",
      "path": "assets/images/abc.png",
      "color": const Color(0xFFFF9AA2),
    },
    {
      "title": "Number",
      "path": "assets/images/123.webp",
      "color": const Color(0xFFFF9AA2),
    },
    {
      "title": "Maths",
      "path": "assets/images/math.png",
      "color": const Color(0xFFFFB7B2),
    },
    {
      "title": "Animals",
      "path": "assets/images/dog.png",
      "color": const Color(0xFFFFDAC1),
    },
    {
      "title": "Birds",
      "path": "assets/images/bird.png",
      "color": const Color(0xFFE2F0CB),
    },
    {
      "title": "Vegetables",
      "path": "assets/images/vegetables.png",
      "color": const Color(0xFFB5EAD7),
    },
    {
      "title": "Fruits",
      "path": "assets/images/apple.png",
      "color": const Color(0xFFADBCF6),
    },
    {
      "title": "Flowers",
      "path": "assets/images/rose.png",
      "color": const Color(0xFFFFD3B6),
    },
    {
      "title": "Shapes",
      "path": "assets/images/shape.png",
      "color": const Color(0xFFFABFEF),
    },
    {
      "title": "Colors",
      "path": "assets/images/colorplat.webp",
      "color": const Color(0xFFA2D7D8),
    },
    {
      "title": "Body Parts",
      "path": "assets/images/body.png",
      "color": const Color(0xFFF8B195),
    },
    {
      "title": "Music",
      "path": "assets/images/musicinstrumnet.webp",
      "color": const Color(0xFFF67280),
    },
    {
      "title": "Vehicles",
      "path": "assets/images/car.png",
      "color": const Color(0xFFD3F8B1),
    },
    {
      "title": "Emoji",
      "path": "assets/images/emoji.webp",
      "color": const Color(0xFFF8ECB1),
    },
  ];

  /// colors list
  static final List<Map<String, dynamic>> colorsList = [
    {
      "color": Colors.red,
      "name": "Red",
    },
    {
      "color": Colors.blue,
      "name": "Blue",
    },
    {
      "color": Colors.green,
      "name": "Green",
    },
    {
      "color": Colors.yellow,
      "name": "Yellow",
    },
    {
      "color": Colors.orange,
      "name": "Orange",
    },
    {
      "color": Colors.purple,
      "name": "Purple",
    },
    {
      "color": Colors.pink,
      "name": "Pink",
    },
    {
      "color": Colors.brown,
      "name": "Brown",
    },
    {
      "color": Colors.indigo,
      "name": "Indigo",
    },
    {
      "color": Colors.teal,
      "name": "Teal",
    },
    {
      "color": Colors.cyan,
      "name": "Cyan",
    },
    {
      "color": Colors.lime,
      "name": "Lime",
    },
    {
      "color": Colors.amber,
      "name": "Amber",
    },
    {
      "color": Colors.deepPurple,
      "name": "Deep Purple",
    },
    {
      "color": Colors.lightBlue,
      "name": "Light Blue",
    },
    {
      "color": Colors.deepOrange,
      "name": "Deep Orange",
    },
    {
      "color": Colors.lightGreen,
      "name": "Light Green",
    },
    {
      "color": Colors.grey,
      "name": "Gray",
    },
    {
      "color": Colors.blueGrey,
      "name": "Blue Gray",
    },
    {
      "color": Colors.black,
      "name": "Black",
    },
  ];

  /// number words
  static final numberWords = [
    'Zero',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
    'Twenty',
    'Twenty-One',
    'Twenty-Two',
    'Twenty-Three',
    'Twenty-Four',
    'Twenty-Five',
    'Twenty-Six',
    'Twenty-Seven',
    'Twenty-Eight',
    'Twenty-Nine',
    'Thirty',
    'Thirty-One',
    'Thirty-Two',
    'Thirty-Three',
    'Thirty-Four',
    'Thirty-Five',
    'Thirty-Six',
    'Thirty-Seven',
    'Thirty-Eight',
    'Thirty-Nine',
    'Forty',
    'Forty-One',
    'Forty-Two',
    'Forty-Three',
    'Forty-Four',
    'Forty-Five',
    'Forty-Six',
    'Forty-Seven',
    'Forty-Eight',
    'Forty-Nine',
    'Fifty',
    'Fifty-One',
    'Fifty-Two',
    'Fifty-Three',
    'Fifty-Four',
    'Fifty-Five',
    'Fifty-Six',
    'Fifty-Seven',
    'Fifty-Eight',
    'Fifty-Nine',
    'Sixty',
    'Sixty-One',
    'Sixty-Two',
    'Sixty-Three',
    'Sixty-Four',
    'Sixty-Five',
    'Sixty-Six',
    'Sixty-Seven',
    'Sixty-Eight',
    'Sixty-Nine',
    'Seventy',
    'Seventy-One',
    'Seventy-Two',
    'Seventy-Three',
    'Seventy-Four',
    'Seventy-Five',
    'Seventy-Six',
    'Seventy-Seven',
    'Seventy-Eight',
    'Seventy-Nine',
    'Eighty',
    'Eighty-One',
    'Eighty-Two',
    'Eighty-Three',
    'Eighty-Four',
    'Eighty-Five',
    'Eighty-Six',
    'Eighty-Seven',
    'Eighty-Eight',
    'Eighty-Nine',
    'Ninety',
    'Ninety-One',
    'Ninety-Two',
    'Ninety-Three',
    'Ninety-Four',
    'Ninety-Five',
    'Ninety-Six',
    'Ninety-Seven',
    'Ninety-Eight',
    'Ninety-Nine',
    'One Hundred',
  ];

  /// List of math categories with icons and colors
  static final List<Map<String, dynamic>> mathCategories = [
    {
      'title': 'Addition',
      'color': const Color(0xFF80DEEA),
      'screen': const AdditionScreen(),
      'image': 'assets/images/add_icon.png',
    },
    {
      'title': 'Subtraction',
      'color': const Color(0xFFCE93D8),
      'screen': const SubtractionScreen(),
      'image': 'assets/images/subtraction_icon.png',
    },
    {
      'title': 'Multiplication',
      'color': const Color(0xFFFFF59D),
      'screen': const MultiplicationScreen(),
      'image': 'assets/images/multiplication_icon.png',
    },
    {
      'title': 'Division',
      'color': const Color(0xFFA5D6A7),
      'screen': const DivisionScreen(),
      'image': 'assets/images/division_icon.png',
    },
  ];

  static final List<Color> numberColors = [
    Colors.redAccent,
    Colors.indigo,
    Colors.blue,
    Colors.orange
  ];

  static final List<String> pairSymbols = [
    '🐶',
    '🐱',
    '🐰',
    '🏀',
    '🐼',
    '✈️',
    '🦁',
    '❤️',
    '🌳',
    '🏠'
  ];

  static final weekDaysData = [
    {
      "day": "Monday",
      "color": Colors.blueAccent.shade100,
    },
    {
      "day": "Tuesday",
      "color": Colors.greenAccent.shade100,
    },
    {
      "day": "Wednesday",
      "color": Colors.yellow[300],
    },
    {
      "day": "Thursday",
      "color": Colors.orangeAccent.shade100,
    },
    {
      "day": "Friday",
      "color": Colors.pinkAccent.shade100,
    },
    {
      "day": "Saturday",
      "color": Colors.tealAccent.shade100,
    },
    {
      "day": "Sunday",
      "color": Colors.redAccent.shade100,
    },
  ];

  static final monthsData = [
    {
      "day": "January",
      "color": const Color(0xffE0F0FA),
    },
    {
      "day": "February",
      "color": const Color(0xffF8D7DA),
    },
    {
      "day": "March",
      "color": const Color(0xffD4F1D5),
    },
    {
      "day": "April",
      "color": const Color(0xfFE9D4FA),
    },
    {
      "day": "May",
      "color": const Color(0xffFFEAA7),
    },
    {
      "day": "June",
      "color": const Color(0xffFFC8C8),
    },
    {
      "day": "July",
      "color": const Color(0xffF2D6D6),
    },
    {
      "day": "August",
      "color": const Color(0xffFFD8A8),
    },
    {
      "day": "September",
      "color": const Color(0xb5f0ff8d),
    },
    {
      "day": "October",
      "color": const Color(0xffE6C8A5),
    },
    {
      "day": "November",
      "color": const Color(0xffb3ffd2),
    },
    {
      "day": "December",
      "color": const Color(0xffD4E2E6),
    },
  ];

  ///------ Colors for different tables --------- ///
  static final List<Color> tableColors = [
    Colors.pink,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.amber.shade700,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.blueGrey,
    Colors.yellow.shade700,
    Colors.red,
    Colors.pinkAccent,
    Colors.greenAccent.shade700,
    Colors.cyanAccent.shade700,
    Colors.deepOrange,
    Colors.indigo.shade800
  ];
}
