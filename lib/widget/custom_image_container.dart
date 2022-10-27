import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomImageContainer extends StatelessWidget {

  double width;
  double height;
  String image;

  CustomImageContainer({
    required this.width,
    required this.height,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * width,
      height: Get.height * height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(image)
        )
      ),
    );
  }
}
