import 'package:babyspark/domain/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyCategoriesCard extends StatelessWidget {
  /// here we create constructor
  String title;
  String animationPath;
  MyCategoriesCard(
      {super.key, required this.animationPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3)],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(animationPath, height: 100 , fit: BoxFit.cover),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  title,
                  style: myTextStyle28(fontFamily: "mainSecond"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
