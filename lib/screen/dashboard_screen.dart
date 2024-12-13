import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/widgets/my_categories_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// here we create list for all categories
  /// data change according to your requirement
  List<Map<String, dynamic>> categories = [
    {
      "title": "Alphabets",
      "path": "assets/lottie_animation_file/onetwothree.json"
    },
    {"title": "Maths", "path": "assets/lottie_animation_file/math.json"},
    {"title": "Animals", "path": "assets/lottie_animation_file/cat.json"},
    {"title": "Birds", "path": "assets/lottie_animation_file/birds.json"},

    /// you can add more

    {
      "title": "Vegetables",
      "path": "assets/lottie_animation_file/vegatable.json"
    },

    {"title": "Fruits", "path": "assets/lottie_animation_file/apple.json"},
    {"title": "Flowers", "path": "assets/lottie_animation_file/flower.json"},

    {"title": "Shapes", "path": "assets/lottie_animation_file/shape.json"},

    {"title": "Colors", "path": "assets/lottie_animation_file/colors.json"},

    {
      "title": "Body Part",
      "path": "assets/lottie_animation_file/body parts.json"
    },

    {
      "title": "Music Instrument",
      "path": "assets/lottie_animation_file/music instrument.json"
    },
    {"title": "Vehicles", "path": "assets/lottie_animation_file/car.json"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: double.infinity,
            height: 130,
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello",
                        style: myTextStyle25(),
                      ),
                      Text(
                        "Little World",
                        style: myTextStyle28(fontFamily: "Third"),
                      )
                    ],
                  ),
                ),

                /// bear animation a
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Lottie.asset(
                        "assets/lottie_animation_file/bear_hi.json",
                        height: 200))
              ],
            ),
          ),

          /// here we create grid view to show categories of study
          Expanded(
            child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  /// Create custom Card view for showing categorises
                  /// here we call
                  return MyCategoriesCard(
                    title: categories[index]["title"],
                    animationPath: categories[index]["path"],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

/// THIS IS DASH BOARD SCREEN
///  ----------------- DONE --------------------------///
