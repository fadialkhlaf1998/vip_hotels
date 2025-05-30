import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomLogoBlack extends StatelessWidget {

  double width;
  double height;
  String tag;


  CustomLogoBlack({
    required this.width,
    required this.height,
    required this.tag
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: SizedBox(
        width: Get.width * width,
        height: Get.height * height,
        // child: SvgPicture.asset('assets/icons/logo vip.svg', fit: BoxFit.contain,),
        child: SvgPicture.asset('assets/icons/LOGO_black.svg', fit: BoxFit.contain,),
      ),
    );
  }
}
