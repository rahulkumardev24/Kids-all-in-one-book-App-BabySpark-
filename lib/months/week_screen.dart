import 'package:babyspark/domain/custom_text_style.dart';
import 'package:flutter/material.dart';

import '../helper/app_color.dart';

class WeekScreen extends StatelessWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weekData = [
      {
        "day": "Monday",
        "color": const Color(0xFF4DD0E1),
        "image": "assets/images/emoji.webp"
      },
      {
        "day": "Tuesday",
        "color": const Color(0xFF8BC34A),
        "image": "assets/images/emoji.webp"
      },
      {
        "day": "Wednesday",
        "color": const Color(0xFF42A5F5),
        "image": "assets/images/emoji.webp"
      },
      {
        "day": "Thursday",
        "color": const Color(0xFFFF7043),
        "image": "assets/images/emoji.webp"
      },
      {
        "day": "Friday",
        "color": const Color(0xFFFFEB3B),
        "image": "assets/images/emoji.webp"
      },
      {
        "day": "Saturday",
        "color": const Color(0xFFFFEB3B),
        "image": "assets/images/emoji.webp"
      },
      {
        "day": "Sunday",
        "color": const Color(0xFF4A6CF7),
        "image": "assets/images/emoji.webp"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Days of the Week"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: weekData.length,
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (context, index) {
          final item = weekData[index];
          return Stack(
            alignment: Alignment.center,
            children: [
              /// Timeline Line
              if (index != weekData.length - 1)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 4,
                    height: 50,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),

              /// Day Card
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  /// --- Number ---- ///
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                          border: BoxBorder.all(
                              width: 2, color: AppColors.primaryDark)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${index + 1}",
                          style: myTextStyle21(),
                        ),
                      )),
                  Container(
                    height: 8,
                    width: 80,
                    decoration: BoxDecoration(color: item["color"] as Color),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      decoration: BoxDecoration(
                        color: item["color"] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item["day"] as String,
                            style: TextStyle(
                              color: item["day"] == "Friday"
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(
                            item["image"] as String,
                            height: 50,
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
