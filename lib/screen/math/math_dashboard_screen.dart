import 'package:babyspark/domain/custom_text_style.dart';
import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/screen/math/multiplication_table_screen.dart';
import 'package:babyspark/screen/math/start_daily_challenge_screen.dart';
import 'package:babyspark/widgets/navigation_button.dart';
import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../helper/app_color.dart';
import '../../widgets/home_carousel_slider.dart';

class MathDashboardScreen extends StatefulWidget {
  const MathDashboardScreen({super.key});

  @override
  State<MathDashboardScreen> createState() => _MathDashboardScreenState();
}

class _MathDashboardScreenState extends State<MathDashboardScreen> {
  int _completedChallenges = 0;
  final int _totalDailyQuestions = 10;
  bool _isChallengeCompletedToday = false;
  DateTime? _lastChallengeDate;
  int _todayProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadChallengeProgress();
  }

  void _loadChallengeProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _completedChallenges = prefs.getInt('completedChallenges') ?? 0;
      _lastChallengeDate =
          DateTime.tryParse(prefs.getString('lastChallengeDate') ?? '');
      _todayProgress = prefs.getInt('todayProgress') ?? 0;

      // Check if it's a new day
      final now = DateTime.now();
      if (_lastChallengeDate != null &&
          (now.day != _lastChallengeDate!.day ||
              now.month != _lastChallengeDate!.month ||
              now.year != _lastChallengeDate!.year)) {
        _todayProgress = 0;
        _isChallengeCompletedToday = false;
        prefs.setInt('todayProgress', 0);
      } else if (_todayProgress >= _totalDailyQuestions) {
        _isChallengeCompletedToday = true;
      }
    });
  }

  void _updateProgress(int progress) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _todayProgress = progress;
      if (progress >= _totalDailyQuestions) {
        _isChallengeCompletedToday = true;
        _completedChallenges++;
        prefs.setInt('completedChallenges', _completedChallenges);
      }
    });

    prefs.setInt('todayProgress', progress);
    prefs.setString('lastChallengeDate', DateTime.now().toIso8601String());
  }

  void _startDailyChallenge() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DailyChallengeScreen(
            onProgressUpdate: _updateProgress,
            initialProgress: _todayProgress,
          ),
        ),
      ).then((_) {
        // Refresh progress when returning from challenge
        _loadChallengeProgress();
      });
    } catch (e) {
      // Show error message if navigation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting challenge: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Add this to your initState or somewhere to reset daily progress
  void _checkAndResetDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayKey = _getTodayKey();
    final String? lastResetDate = prefs.getString('last_reset_date');

    if (lastResetDate != todayKey) {
      // New day, reset progress
      await prefs.setInt('today_progress', 0);
      await prefs.setInt('current_question_index', 0);
      await prefs.setString('last_reset_date', todayKey);
      setState(() {
        _todayProgress = 0;
        _isChallengeCompletedToday = false;
      });
    }
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

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

                  /// ----- Daily challenge section ------ ///
                  VxArc(
                    height: 3.h,
                    arcType: VxArcType.convex,
                    edge: VxEdge.top,
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.3,
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
                          const SizedBox(height: 12),
                          Text(
                            _isChallengeCompletedToday
                                ? "Today's challenge completed! 🎉"
                                : "Solve $_totalDailyQuestions problems to earn stars!",
                            style: myTextStyle18(
                              fontColor: Colors.grey[700]!,
                            ),
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: _todayProgress / _totalDailyQuestions,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFFFA726)),
                            borderRadius: BorderRadius.circular(10),
                            minHeight: 12,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total completed: $_completedChallenges",
                                style: myTextStyle14(
                                  fontColor: Colors.grey[600]!,
                                ),
                              ),
                              Text(
                                "$_todayProgress/$_totalDailyQuestions today",
                                style: myTextStyle14(
                                  fontColor: Colors.grey[600]!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isChallengeCompletedToday
                                  ? null
                                  : _startDailyChallenge,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isChallengeCompletedToday
                                    ? Colors.grey
                                    : const Color(0xFFFFA726),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                _isChallengeCompletedToday
                                    ? "Completed Today"
                                    : "Start Challenge",
                                style: myTextStyle18(
                                  fontWeight: FontWeight.bold,
                                  fontColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
}
