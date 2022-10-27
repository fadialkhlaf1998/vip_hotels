import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/services/AppStyle.dart';

class CustomTextField extends StatefulWidget {

  final double width;
  final double height;
  final TextEditingController controller;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String hintText;
  final TextInputType keyboardType;
  final bool textVisible;
  final int maxLength;

  CustomTextField({
    required this.width,
    required this.height,
    required this.controller,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.hintText,
    required this.keyboardType,
    required this.textVisible,
    required this.maxLength,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * widget.width,
      height: widget.height,
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: widget.controller,
        validator: (text) {
            if (text!.isEmpty) {
              setState(() {
                check = false;
              });
              return 'This field cannot be empty';
            }

          return null;
        },
        obscureText: widget.textVisible,
        decoration:  InputDecoration(
          counterText: "",
          errorStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: AppStyle.lightGrey
            ),
            borderRadius: BorderRadius.circular(5)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1,
                  color: AppStyle.lightGrey),
              borderRadius: BorderRadius.circular(5)
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          labelText: widget.hintText,
          labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14
          ),
        ),
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
      ),
    );
  }
}

