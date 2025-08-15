import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  ];

  /// colors list
  static final List<Map<String, dynamic>> colorsList = [
    {
      "color": Colors.red,
      "name": "Red",
      "hindiName": "लाल",
      "emoji": "🍎",
      "sound": "red_sound.mp3"
    },
    {
      "color": Colors.blue,
      "name": "Blue",
      "hindiName": "नीला",
      "emoji": "🐳",
      "sound": "blue_sound.mp3"
    },
    {
      "color": Colors.green,
      "name": "Green",
      "hindiName": "हरा",
      "emoji": "🐸",
      "sound": "green_sound.mp3"
    },
    {
      "color": Colors.yellow,
      "name": "Yellow",
      "hindiName": "पीला",
      "emoji": "🍌",
      "sound": "yellow_sound.mp3"
    },
    {
      "color": Colors.orange,
      "name": "Orange",
      "hindiName": "नारंगी",
      "emoji": "🍊",
      "sound": "orange_sound.mp3"
    },
    {
      "color": Colors.purple,
      "name": "Purple",
      "hindiName": "बैंगनी",
      "emoji": "🍇",
      "sound": "purple_sound.mp3"
    },
    {
      "color": Colors.pink,
      "name": "Pink",
      "hindiName": "गुलाबी",
      "emoji": "🌸",
      "sound": "pink_sound.mp3"
    },
    {
      "color": Colors.brown,
      "name": "Brown",
      "hindiName": "भूरा",
      "emoji": "🐻",
      "sound": "brown_sound.mp3"
    },
    {
      "color": Colors.indigo,
      "name": "Indigo",
      "hindiName": "नील",
      "emoji": "👖",
      "sound": "indigo_sound.mp3"
    },
    {
      "color": Colors.teal,
      "name": "Teal",
      "hindiName": "टील",
      "emoji": "🦚",
      "sound": "teal_sound.mp3"
    },
    {
      "color": Colors.cyan,
      "name": "Cyan",
      "hindiName": "सियान",
      "emoji": "💧",
      "sound": "cyan_sound.mp3"
    },
    {
      "color": Colors.lime,
      "name": "Lime",
      "hindiName": "लाइम",
      "emoji": "🍈",
      "sound": "lime_sound.mp3"
    },
    {
      "color": Colors.amber,
      "name": "Amber",
      "hindiName": "अंबर",
      "emoji": "🍯",
      "sound": "amber_sound.mp3"
    },
    {
      "color": Colors.deepPurple,
      "name": "Deep Purple",
      "hindiName": "गहरा बैंगनी",
      "emoji": "🍆",
      "sound": "deep_purple_sound.mp3"
    },
    {
      "color": Colors.lightBlue,
      "name": "Light Blue",
      "hindiName": "हल्का नीला",
      "emoji": "🦋",
      "sound": "light_blue_sound.mp3"
    },
    {
      "color": Colors.deepOrange,
      "name": "Deep Orange",
      "hindiName": "गहरा नारंगी",
      "emoji": "🌅",
      "sound": "deep_orange_sound.mp3"
    },
    {
      "color": Colors.lightGreen,
      "name": "Light Green",
      "hindiName": "हल्का हरा",
      "emoji": "🍀",
      "sound": "light_green_sound.mp3"
    },
    {
      "color": Colors.grey,
      "name": "Gray",
      "hindiName": "स्लेटी",
      "emoji": "🐘",
      "sound": "gray_sound.mp3"
    },
    {
      "color": Colors.blueGrey,
      "name": "Blue Gray",
      "hindiName": "नीला स्लेटी",
      "emoji": "🌫️",
      "sound": "blue_gray_sound.mp3"
    },
    {
      "color": Colors.black,
      "name": "Black",
      "hindiName": "काला",
      "emoji": "⚫",
      "sound": "black_sound.mp3"
    },
    {
      "color": Colors.white,
      "name": "White",
      "hindiName": "सफेद",
      "emoji": "☁️",
      "sound": "white_sound.mp3"
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
}
