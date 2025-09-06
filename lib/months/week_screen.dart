import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../helper/app_color.dart';

class WeekScreen extends StatelessWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final weekData = AppConstant.weekDaysData;
    bool isTablet(BuildContext context) {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide >= 600;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: size.height * 0.2,
          flexibleSpace: const SecondaryAppBar(title: "Week"),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: ListView.builder(
            itemCount: weekData.length,
            itemBuilder: (context, index) {
              final item = weekData[index];
              return Stack(
                alignment: Alignment.center,
                children: [
                  /// Timeline Line
                  if (index != weekData.length)
                    Positioned(
                      bottom: 0,
                      left: 1.5.h,
                      child: Container(
                        width: 4,
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
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
                              style: myTextStyleCus(
                                  fontSize: isTablet(context) ? 32 : 27),
                            ),
                          )),

                      Container(
                        height: 8,
                        width: 60,
                        decoration: BoxDecoration(
                            border: BoxBorder.symmetric(
                                horizontal:
                                    BorderSide(color: item["color"] as Color))),
                      ),

                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
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
                                style: myTextStyle25(fontFamily: "secondary"),
                              ),
                              Image.asset(
                                item["image"] as String,
                                height: 5.h,
                                width: 5.h,
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
        ),
      ),
    );
  }
}
