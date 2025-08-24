import 'dart:math';
import 'package:babyspark/domain/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../helper/app_color.dart';

class MultiplicationTableScreen extends StatefulWidget {
  const MultiplicationTableScreen({super.key});

  @override
  State<MultiplicationTableScreen> createState() =>
      _MultiplicationTableScreenState();
}

class _MultiplicationTableScreenState extends State<MultiplicationTableScreen> {
  int _selectedNumber = 1;
  final List<int> _numbers = List.generate(20, (index) => index + 1);
  final Random _random = Random();

  // Colors for different tables
  final List<Color> _tableColors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.red,
    Colors.brown,
    Colors.blueGrey,
    Colors.lime,
    Colors.yellow,
    Colors.pinkAccent,
    Colors.purpleAccent,
  ];

  void _goToNextTable() {
    if (_selectedNumber < 20) {
      setState(() {
        _selectedNumber++;
      });
    }
  }

  void _goToPreviousTable() {
    if (_selectedNumber > 1) {
      setState(() {
        _selectedNumber--;
      });
    }
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(200),
      _random.nextInt(200),
      _random.nextInt(200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentColor =
        _tableColors[(_selectedNumber - 1) % _tableColors.length];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      /// ------------- App Bar --------------- ///
      appBar: AppBar(
        title: const Text('Multiplication Tables'),
        backgroundColor: currentColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      /// ------------- Body ---------------- ///
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              currentColor.withValues(alpha: 0.1),
              currentColor.withValues(alpha: 0.3),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 2.h),

            /// Number grid with all 20 numbers
            SizedBox(
              height: size.height * 0.1,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _numbers.length,
                itemBuilder: (context, index) {
                  final number = _numbers[index];
                  final numberColor =
                      _tableColors[(number - 1) % _tableColors.length];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedNumber = number;
                      });
                    },
                    child: Animate(
                      effects: [
                        ScaleEffect(duration: 300.ms, delay: (index * 50).ms),
                      ],
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedNumber == number
                              ? numberColor
                              : numberColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: numberColor,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: numberColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$number',
                            style: myTextStyle18(
                              fontWeight: FontWeight.bold,
                              fontColor: _selectedNumber == number
                                  ? Colors.white
                                  : numberColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Previous button
                  const Expanded(
                      child:
                          Divider(thickness: 2, color: AppColors.primaryDark)),
                  SizedBox(
                    width: 2.h,
                  ),

                  /// Current number display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: currentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_selectedNumber',
                      style: myTextStyle25(
                          fontWeight: FontWeight.bold,
                          fontColor: Colors.white,
                          fontFamily: "secondary"),
                    ),
                  ),
                  SizedBox(
                    width: 2.h,
                  ),
                  const Expanded(
                      child: Divider(
                    thickness: 2,
                    color: AppColors.primaryDark,
                  )),
                ],
              ),
            ),

            /// ------- Multiplication table -------------- ///
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final multiplier = index + 1;
                    final result = _selectedNumber * multiplier;
                    final itemColor = _getRandomColor();

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 0.2.h),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: itemColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_selectedNumber',
                            style: myTextStyle18(
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            ),
                          ),
                          Text(
                            ' × ',
                            style: myTextStyle18(
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            ),
                          ),
                          Text(
                            '$multiplier',
                            style: myTextStyle18(
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            ),
                          ),
                          Text(
                            ' = ',
                            style: myTextStyle18(
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            )),
                          Text(
                            '$result',
                            style: myTextStyle25(
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            /// Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Previous button
                  ElevatedButton.icon(
                    onPressed: _goToPreviousTable,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: Text(
                      'Prev',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// Current number display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: currentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      '$_selectedNumber',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /// Next button
                  ElevatedButton.icon(
                    onPressed: _goToNextTable,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h)
          ],
        ),
      ),
    );
  }
}
