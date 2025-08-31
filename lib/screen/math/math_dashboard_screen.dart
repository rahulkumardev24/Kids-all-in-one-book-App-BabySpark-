import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/screen/math/addition_screen.dart';
import 'package:babyspark/screen/math/subtraction_screen.dart';
import 'package:babyspark/screen/multiplication_table_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'division_screen.dart';
import 'multiplication_screen.dart';

class MathDashboardScreen extends StatefulWidget {
  const MathDashboardScreen({super.key});

  @override
  State<MathDashboardScreen> createState() => _MathDashboardScreenState();
}

class _MathDashboardScreenState extends State<MathDashboardScreen> {
  // List of math categories with icons and colors
  final List<Map<String, dynamic>> _mathCategories = [
    {
      'title': 'Multiplication\nTable',
      'icon': Iconsax.calculator,
      'color': const Color(0xFFE91E63),
      'screen': const MultiplicationTableScreen(),
      'image': 'assets/images/multiplication.png',
    },
    {
      'title': 'Counting\nNumbers',
      'icon': Iconsax.hashtag,
      'color': const Color(0xFF9C27B0),
      'screen': null, // You can create a CountingNumbersScreen
      'image': 'assets/images/counting.png',
    },
    {
      'title': 'Shapes &\nPatterns',
      'icon': Iconsax.shapes,
      'color': const Color(0xFF673AB7),
      'screen': null, // You can create a ShapesScreen
      'image': 'assets/images/shapes.png',
    },
    {
      'title': 'Simple\nAddition',
      'icon': Iconsax.add,
      'color': const Color(0xFF3F51B5),
      'screen': null, // You can create a AdditionScreen
      'image': 'assets/images/addition.png',
    },
    {
      'title': 'Simple\nSubtraction',
      'icon': Iconsax.minus,
      'color': const Color(0xFF2196F3),
      'screen': null, // You can create a SubtractionScreen
      'image': 'assets/images/subtraction.png',
    },
    {
      'title': 'Number\nRecognition',
      'icon': Iconsax.note_1,
      'color': const Color(0xFF009688),
      'screen': null, // You can create a NumberRecognitionScreen
      'image': 'assets/images/numbers.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      /// ---- Appbar ------ ///
      appBar: AppBar(
        title: Text(
          "Learn Math",
          style: myTextStyle25(
            fontWeight: FontWeight.bold,
            fontColor: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0288D1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Math Adventure",
                    style: myTextStyle22(
                      fontWeight: FontWeight.bold,
                      fontColor: const Color(0xFF01579B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Explore fun math activities!",
                    style: myTextStyle18(
                      fontColor: const Color(0xFF0277BD),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ---- Multiplication Table ----- ///
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MultiplicationTableScreen())),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            "Multiplication\nTable",
                            textAlign: TextAlign.center,
                            style: myTextStyle30(
                              fontFamily: "secondary",
                            ),
                          )),
                      Image.asset(
                        "assets/images/multiplication.png",
                        height: size.width * 0.3,
                        width: size.width * 0.3,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
              ),
            ) ,
            const SizedBox(height: 20),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => AdditionScreen()));
              },
                child: const Text("Addition") ) ,
            const SizedBox(height: 100,),

            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SubtractionScreen()));
                },
                child: const Text("Subtraction") ) ,

            const SizedBox(height: 100,),

            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>const MultiplicationScreen()));
                },
                child: const Text("Multiplication") ) ,

            const SizedBox(height: 100,),
            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>const DivisionScreen()));
                },
                child: const Text("Multiplication") ) ,

          ],
        ),
      ),
    );
  }

}