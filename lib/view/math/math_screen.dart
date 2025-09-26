import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MathScreen extends StatelessWidget {
  const MathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF0F7), Color(0xFFFFE4C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Let's Play with Math!",
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: isTablet ? 36 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    Image.network(
                      "https://cdn-icons-png.flaticon.com/512/1998/1998617.png",
                      height: isTablet ? 80 : 60,
                    ),
                  ],
                ),
              ),

              /// Grid Buttons
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(20),
                  crossAxisCount: isTablet ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMathCard(
                        context,
                        "Numbers",
                        "https://cdn-icons-png.flaticon.com/512/4221/4221797.png",
                        Colors.redAccent),
                    _buildMathCard(
                        context,
                        "Counting",
                        "https://cdn-icons-png.flaticon.com/512/3125/3125788.png",
                        Colors.orangeAccent),
                    _buildMathCard(
                        context,
                        "Shapes",
                        "https://cdn-icons-png.flaticon.com/512/3933/3933043.png",
                        Colors.teal),
                    _buildMathCard(
                        context,
                        "Comparison",
                        "https://cdn-icons-png.flaticon.com/512/1807/1807317.png",
                        Colors.purple),
                    _buildMathCard(
                        context,
                        "Patterns",
                        "https://cdn-icons-png.flaticon.com/512/11363/11363345.png",
                        Colors.green),
                    _buildMathCard(
                        context,
                        "Addition",
                        "https://cdn-icons-png.flaticon.com/512/8031/8031733.png",
                        Colors.blueAccent),
                    _buildMathCard(
                        context,
                        "Time",
                        "https://cdn-icons-png.flaticon.com/512/1870/1870036.png",
                        Colors.indigo),
                    _buildMathCard(
                        context,
                        "Money",
                        "https://cdn-icons-png.flaticon.com/512/3989/3989768.png",
                        Colors.brown),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMathCard(
      BuildContext context, String title, String imageUrl, Color color) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return GestureDetector(
      onTap: () {
// Navigate to the respective screen
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: isTablet ? 100 : 70,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: isTablet ? 22 : 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
