import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/model/backend_style.dart';
import 'package:vip_hotels/services/AppStyle.dart';

class CustomAnimatedTextField extends StatelessWidget {


  int duration;
  double width;
  double height;
  TextEditingController controller;
  Icon prefixIcon;
  TextInputType keyboardType;
  String labelText;
  double right;
  double bottom;
  bool validate;

  CustomAnimatedTextField({
      required this.duration,
      required this.width,
      required this.height,
      required this.controller,
      required this.prefixIcon,
      required this.keyboardType,
      required this.labelText,
    required this.right,
    required this.bottom,
    required this.validate
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * width,
      height: height,
      child: TextField(
        style: TextStyle(
          color: BackEndStyle.title_color,
        ),
        controller: controller,
        decoration:  InputDecoration(
          counterText: "",
          errorStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold),
          focusedBorder: validate?
          OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2,
                  color: Colors.red
              ),
              borderRadius: BorderRadius.circular(5)
          )
              :OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color: BackEndStyle.body_color
              ),
              borderRadius: BorderRadius.circular(5)
          ),
          enabledBorder: validate?
          OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2,
                  color: Colors.red
              ),
              borderRadius: BorderRadius.circular(5)
          )
              :OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color: BackEndStyle.body_color),
              borderRadius: BorderRadius.circular(5)
          ),
          prefixIcon: prefixIcon,
          labelText: labelText,
          labelStyle: TextStyle(
              color: BackEndStyle.body_color,
              fontSize: 13
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
