import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_color.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/screen/categories_screen/book_grid_screen.dart';
import 'package:babyspark/screen/color/color_grid_screen.dart';
import 'package:babyspark/screen/number/number_screen.dart';
import 'package:babyspark/widgets/my_categories_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/home_carousel_slider.dart';
import 'color/colors_screen.dart';
import 'math/math_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        /// ---- App bar ---- ///
        appBar: AppBar(
          toolbarHeight: size.height * 0.12,
          backgroundColor: AppColors.primaryColor,
          flexibleSpace: SizedBox(
            width: size.width,
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hello Little Explorer!",
                        style: myTextStyleCus(
                          fontFamily: "secondary",
                          fontSize: isTablet(context) ? 30 : 21,
                        ),
                      ),
                      Text(
                        "What shall we learn today?",
                        style: myTextStyleCus(
                            fontSize: isTablet(context) ? 27 : 18,
                            fontFamily: "primary",
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: -1.5.h,
                  child: Lottie.asset(
                    "assets/lottie_animation_file/animal animation.json",
                    height: size.height * 0.18,
                    width: size.height * 0.18,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),

        /// ---- Body ------ ///
        body: Container(
          decoration: const BoxDecoration(color: AppColors.primaryColor),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// ------ Carousel Slider ------- ///
                const HomeCarouselSlider(
                  viewportFraction: 0.9,
                ),

                SizedBox(
                  height: 1.h,
                ),

                /// Categories Grid - Removed Expanded and added Container with fixed height
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: GridView.builder(
                      itemCount: AppConstant.categories.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true, // Important for scrollable content
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
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
                                      builder: (_) => const ColorGridScreen(
                                          appBarTitle: "Colours")));
                            }

                            /// --- Shapes --- ///
                            else if (categories["title"] == "Shapes") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: "shape_data",
                                            appBarTitle: "Shapes",
                                          )));
                            } else if (categories["title"] == "Number") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const NumberScreen()));
                            }

                            /// --- Fruits --- ///
                            else if (categories["title"] == "Fruits") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: 'fruits_data',
                                            appBarTitle: "Fruits",
                                          )));
                            }

                            /// --- Vegetables --- ///
                            else if (categories["title"] == "Vegetables") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: 'vegetables_data',
                                            appBarTitle: "Fruits",
                                          )));
                            }

                            /// --- Body Parts --- ///
                            else if (categories["title"] == "Body Parts") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: 'body_parts_data',
                                            appBarTitle: "Body Parts",
                                          )));
                            }

                            /// --- Flowers --- ///
                            else if (categories["title"] == "Flowers") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: 'flowers_data',
                                            appBarTitle: "Flowers",
                                          )));
                            }

                            /// ----- Math ------- ///
                            else if (categories["title"] == "Maths") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const MathDashboardScreen()));
                            }

                            /// --- Vehicles --- ///
                            else if (categories["title"] == "Vehicles") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: 'vehicles_data',
                                            appBarTitle: "Vehicles",
                                          )));
                            }

                            /// --- Music --- ///
                            else if (categories["title"] == "Music") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName:
                                                'music_instrument_data',
                                            appBarTitle: "Music",
                                          )));
                            }

                            /// --- Birds --- ///
                            else if (categories["title"] == "Birds") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: 'birds_data',
                                            appBarTitle: "Birds",
                                          )));
                            }

                            /// --- animal --- ///
                            else if (categories["title"] == "Animals") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: 'animal_data',
                                            appBarTitle: "Animals",
                                          )));
                            }

                            /// --- Alphabets --- ///
                            else if (categories["title"] == "Alphabets") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: "alphabets_data",
                                            appBarTitle: "Alphabets",
                                          )));
                            }

                            /// ------- Emoji --------- ///
                            else if (categories["title"] == "Emoji") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BookGridScreen(
                                            collectionName: "emoji_data",
                                            appBarTitle: "Emoji",
                                          )));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
