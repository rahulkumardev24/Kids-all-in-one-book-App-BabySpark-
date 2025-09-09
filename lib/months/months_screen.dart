import 'package:avatar_glow/avatar_glow.dart';
import 'package:babyspark/controller/months_controller.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/widgets/control_icon_button.dart';
import 'package:babyspark/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../domain/custom_text_style.dart';
import '../helper/app_color.dart';

class MonthsScreen extends StatefulWidget {
  const MonthsScreen({super.key});

  @override
  State<MonthsScreen> createState() => _MonthsScreenState();
}

class _MonthsScreenState extends State<MonthsScreen> {
  final MonthsController monthsController = Get.put(MonthsController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final monthsData = AppConstant.monthsData;

    return SafeArea(
      child: Scaffold(
        /// ---------- Appbar -------------- ///
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: size.height * 0.2,
          flexibleSpace: SecondaryAppBar(
            title: "Months",
            onPress: () {
              Navigator.pop(context);
              monthsController.stopAllSpeech();
            },
          ),
          elevation: 0,
        ),

        /// ------------ Body -------------- ///
        body: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              monthsController.stopAllSpeech();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              controller: monthsController.scrollController,
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: monthsData.length,
                    itemBuilder: (context, index) {
                      final item = monthsData[index];

                      return Obx(() {
                        final isCurrentSpeaking =
                            monthsController.currentSpeakingIndex == index;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              /// Month Card
                              InkWell(
                                onTap: () =>
                                    monthsController.selectMonth(index),
                                borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(11))
                                    .copyWith(
                                        topRight: const Radius.circular(100),
                                        bottomRight:
                                            const Radius.circular(100)),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 2.h, top: 0.5.h, bottom: 0.5.h),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.h),
                                      margin: const EdgeInsets.only(left: 12),
                                      decoration: BoxDecoration(
                                        color: isCurrentSpeaking
                                            ? AppColors.primaryDark
                                            : item["color"] as Color,
                                        borderRadius: const BorderRadius
                                                .horizontal(
                                                right: Radius.circular(100))
                                            .copyWith(
                                                bottomLeft:
                                                    const Radius.circular(11),
                                                topLeft:
                                                    const Radius.circular(11)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.h),
                                            child: Text(
                                              item["day"] as String,
                                              style: myTextStyle30(
                                                fontFamily: "secondary",
                                                fontColor: isCurrentSpeaking
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              if (isCurrentSpeaking)
                                                Icon(
                                                  Icons.volume_up,
                                                  color: Colors.white54,
                                                  size: 3.h,
                                                ),
                                              SizedBox(
                                                width: 1.h,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Image.asset(
                                                  "assets/images/trady_bear.png",
                                                  height: 8.h,
                                                  width: 8.h,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              ///--------- Month number badge ------- ///
                              Positioned(
                                left: -2.h,
                                child: Container(
                                  height: size.width * 0.25,
                                  width: size.width * 0.25,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/month_card.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 3.h),
                                    child: Text(
                                      "${index + 1}",
                                      style: myTextStyle32(
                                        fontFamily: "secondary",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ),
          ),
        ),

        /// ------- Floating action button ----- ///
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(() => AvatarGlow(
              glowColor: monthsController.isAutoPlaying
                  ? Colors.amber
                  : AppColors.primaryDark,
              glowRadiusFactor: 0.4,
              animate: monthsController.isAutoPlaying,
              child: ControlIconButton(
                  color: monthsController.isAutoPlaying
                      ? Colors.amber
                      : AppColors.primaryDark,
                  icon: monthsController.isAutoPlaying
                      ? Icons.pause_rounded
                      : Icons.volume_up_rounded,
                  iconSize: 32,
                  onPressed: monthsController.toggleAutoPlay),
            )),
      ),
    );
  }
}
