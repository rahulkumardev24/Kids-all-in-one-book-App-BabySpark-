import 'package:babyspark/helper/app_constant.dart';
import 'package:babyspark/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../controller/loading_controller.dart';
import '../../domain/custom_text_style.dart';
import '../../helper/app_color.dart';
import 'colors_screen.dart';

class ColorGridScreen extends StatefulWidget {
  final String appBarTitle;
  const ColorGridScreen({super.key, required this.appBarTitle});

  @override
  State<ColorGridScreen> createState() => _BookGridScreenState();
}

class _BookGridScreenState extends State<ColorGridScreen> {
  final LoadingController _loadingController = LoadingController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadingController.showLoading();

      Future.delayed(const Duration(seconds: 1), () {
        _loadingController.hideLoading();
      });
    });
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(

          /// --- Appbar --- ///
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: size.height * 0.2,
            backgroundColor: Colors.transparent,
            flexibleSpace: SecondaryAppBar(title: widget.appBarTitle , onPress: (){Navigator.pop(context);},),
          ),

          /// --- body --- ///
          body: GridView.builder(
            padding: const EdgeInsets.all(12),
            physics: const ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size.width > 600 ? 4 : 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            itemCount: AppConstant.colorsList.length,
            itemBuilder: (context, index) {
              final color = AppConstant.colorsList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ColorsScreen(
                                selectedIndex: index,
                              )));
                },
                child: ItemsColorCard(
                  title: color['name'],
                  color: color['color'],
                  isTablet: isTablet(context),
                ),
              );
            },
          )),
    );
  }
}

class ItemsColorCard extends StatelessWidget {
  final String title;
  final Color color;
  final bool isTablet;

  const ItemsColorCard({
    super.key,
    required this.title,
    required this.color,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    /// --- Card --- ///
    return VxArc(
      height: size.height * 0.02,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: size.height,
              width: size.height,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.8),
                  borderRadius: const BorderRadiusGeometry.only(
                      topRight: Radius.circular(400),
                      bottomRight: Radius.circular(100),
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(200))),
            ),
          ),

          /// --- Title --- ///
          Positioned(
            bottom: size.height * 0.03,
            child: Text(
              title,
              style: myTextStyleCus(
                  fontSize: isTablet ? 60 : 18, fontWeight: FontWeight.normal),
            ),
          ),
          Positioned(
            top: -size.width * 0.00,
            right: 0,
            child: Container(
              width: size.width * 0.4,
              height: size.width * 0.4,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
