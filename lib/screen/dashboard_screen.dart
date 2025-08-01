import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/screen/categories_screen/shapes_screen.dart';
import 'package:babyspark/widgets/my_categories_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import 'categories_screen/colors_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFCE4EC),
                Color(0xFFF8BBD0),
                Color(0xFFF48FB1),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                child: Stack(

                  children: [



                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello Little Explorer!",
                            style: myTextStyleCus(
                                fontFamily: "secondary",
                                fontSize: size.width * 0.1),
                          ),
                          Text(
                            "What shall we learn today?",
                            style: myTextStyleCus(
                                fontSize: size.width * 0.05,
                                fontFamily: "primary",
                                fontWeight: FontWeight.w500
                               ),
                          ),
                          SizedBox(height: size.height * 0.03,),

                        ],
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom:-10,
                      child: Lottie.asset(
                        "assets/lottie_animation_file/bear_hi.json",
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                        fit: BoxFit.contain,
                      ),
                    ),

                  ],
                ),
              ),


              /// Categories Grid
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 12),
                    child: GridView.builder(
                      itemCount: AppConstant.categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final categories = AppConstant.categories[index];
                        return MyCategoriesCard(
                          color: categories["color"],
                          title: categories["title"],
                          animationPath: categories["path"],
                          onTap: () {
                            if (categories["title"] == "Colors") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ColorsScreen()));
                            }  else if (categories["title"] == "Shapes") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ShapesScreen()));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
