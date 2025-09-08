import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/screen/math/multiplication_table_screen.dart';
import 'package:babyspark/widgets/navigation_button.dart';
import 'package:babyspark/widgets/simple_text_button.dart';
import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../helper/app_color.dart';
import '../../widgets/home_carousel_slider.dart';

class MathDashboardScreen extends StatefulWidget {
  const MathDashboardScreen({super.key});

  @override
  State<MathDashboardScreen> createState() => _MathDashboardScreenState();
}

class _MathDashboardScreenState extends State<MathDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryLight,

        /// -------- App bar -------- ///
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: size.height * 0.15,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadiusGeometry.only(bottomRight: Radius.circular(100))),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(32))),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ---- Back Button ------ ///
                      NavigationButton(onTap: () {
                        Navigator.pop(context);
                      }),
                      Text(
                        "Mathematics",
                        style: myTextStyle21(fontFamily: "primary"),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: size.width * 0.3,
                  child: LottieBuilder.asset(
                    "assets/lottie_animation_file/Winged Teacher.json",
                    fit: BoxFit.cover,
                    height: size.height * 0.15,
                    width: size.height * 0.15,
                  ),
                )
              ],
            ),
          ),
        ),

        /// ------- Body -------- ///
        body: Stack(
          children: [
            /// --------- Floating shapes in background ----------- ///
            Positioned(
              top: size.height * 0.1,
              right: 20,
              child: Icon(Icons.circle,
                  size: size.width * 0.3,
                  color: Colors.white.withValues(alpha: 0.3)),
            ),
            Positioned(
              top: size.height * 0.3,
              left: 10,
              child: Icon(Icons.circle,
                  size: size.width * 0.3,
                  color: Colors.white.withValues(alpha: 0.5)),
            ),
            Positioned(
              bottom: 20,
              right: 40,
              child: Icon(Icons.circle,
                  size: size.width * 0.3,
                  color: Colors.white.withValues(alpha: 0.3)),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),

                        /// ---- Multiplication Table ----- ///
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const MultiplicationTableScreen())),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                        ),

                        SizedBox(
                          height: 2.h,
                        ),

                        ///--------- Grid of math activities ----------- ///
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                          ),
                          itemCount: AppConstant.mathCategories.length,
                          itemBuilder: (context, index) {
                            final category = AppConstant.mathCategories[index];
                            return _buildMathCategoryCard(category, context);
                          },
                        ),

                        SizedBox(height: 3.h),
                        const HomeCarouselSlider(
                          viewportFraction: 1,
                        ),

                        SizedBox(height: 3.h),
                      ],
                    ),
                  ),

                  /// ---- Comparison card ---- ////

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Number Comparison" , style: myTextStyle21(),),
                          SizedBox(height: 1.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _comparisonItemCard(
                                    size: size,
                                    text: "5",
                                    cardColor: AppColors.primaryDark,
                                    isBorder: true),
                              ),
                              SizedBox(width: 2.h,),
                              Expanded(
                                child: _comparisonItemCard(
                                    size: size,
                                    text: "?",
                                    cardColor: Colors.grey.shade500,
                                    isBorder: true,
                                    textColor: Colors.grey.shade700),
                              ),
                              SizedBox(width: 2.h,),
                              Expanded(
                                child: _comparisonItemCard(
                                    size: size,
                                    text: "3",
                                    cardColor: AppColors.primaryDark,
                                    isBorder: true),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _comparisonItemCard(
                                  size: size,
                                  text: ">",
                                  cardColor: Vx.gray300,
                                  textColor: AppColors.primaryDark,
                                  isBorder: false),
                              _comparisonItemCard(
                                  size: size,
                                  text: "=",
                                  cardColor: Vx.gray300,
                                  textColor: AppColors.primaryDark,
                                  isBorder: false),
                              _comparisonItemCard(
                                  size: size,
                                  text: "<",
                                  cardColor: Vx.gray300,
                                  textColor: AppColors.primaryDark,
                                  isBorder: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 3.h,
                  ),

                  /// ----- Daily challenge section ------ ///
                  VxArc(
                    height: 3.h,
                    arcType: VxArcType.convex,
                    edge: VxEdge.top,
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.25,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.babyOrange,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_events_rounded,
                                  color: Colors.amber[700]),
                              const SizedBox(width: 8),
                              Text(
                                "Daily Challenge",
                                style: myTextStyle20(
                                  fontWeight: FontWeight.bold,
                                  fontColor: const Color(0xFF01579B),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          LinearProgressIndicator(
                            value: 0,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFFFA726)),
                            borderRadius: BorderRadius.circular(10),
                            minHeight: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                              width: size.width,
                              child: SimpleTextButton(
                                  onPress: () {}, btnText: "Start Challenge"))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMathCategoryCard(
      Map<String, dynamic> category, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (category['screen'] != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => category['screen']));
        }
      },
      child: ClayContainer(
        color: AppColors.primaryDark,
        spread: 4.0,
        borderRadius: 20,
        curveType: CurveType.concave,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (category['image'] != null)
                Image.asset(
                  category['image'],
                  width: 8.h,
                  height: 8.h,
                  fit: BoxFit.cover,
                ),
              Text(
                category['title'],
                textAlign: TextAlign.center,
                style: myTextStyle21(
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _comparisonItemCard(
      {required Size size,
      required String text,
      required bool isBorder,
      required Color cardColor,
      Color textColor = Colors.black}) {
    return Container(
        height: size.width * 0.2,
        width: size.width * 0.2,
        decoration: BoxDecoration(
            color: cardColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(11),
            border: BoxBorder.all(width: isBorder ? 2 : 0, color: cardColor)),
        child: Center(
            child: Text(
          text,
          style: myTextStyle32(fontFamily: "secondary", fontColor: textColor),
        )));
  }
}
