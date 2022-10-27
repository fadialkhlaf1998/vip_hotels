

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {

  final double width;
  final double height;
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double borderRadius;
  final TextStyle textStyle;


  CustomButton({
    required this.width,
    required this.height,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.borderRadius,
    required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: Get.width * width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
