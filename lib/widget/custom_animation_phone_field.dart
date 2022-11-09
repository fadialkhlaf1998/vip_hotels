import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vip_hotels/services/AppStyle.dart';

class CustomAnimatedPhoneField extends StatefulWidget {


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

  CustomAnimatedPhoneField({
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
  State<CustomAnimatedPhoneField> createState() => _CustomAnimatedPhoneFieldState();
}

class _CustomAnimatedPhoneFieldState extends State<CustomAnimatedPhoneField> {
  PhoneNumber phoneNumber = PhoneNumber(isoCode: "AE");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 2,color: widget.validate?Colors.red:AppStyle.lightGrey)
      ),
      child: InternationalPhoneNumberInput(
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          leadingPadding: 10
        ),
        inputBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 2,
                color: Colors.red
            ),
            borderRadius: BorderRadius.circular(5)
        ),

        maxLength: 11,
        onInputChanged: (value){

          setState(() {
            phoneNumber = value;
            widget.controller.text =  value.phoneNumber!;
          });
          print(phoneNumber);
        },
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        selectorTextStyle: const TextStyle(
          color: Colors.grey,
        ),
        inputDecoration:  InputDecoration(
          counterText: "",
          errorStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold),
          focusedBorder:OutlineInputBorder(
              borderSide: const BorderSide(
                // width: 2,
                  color: Colors.transparent),
              borderRadius: BorderRadius.circular(5)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  // width: 2,
                  color: Colors.transparent),
              borderRadius: BorderRadius.circular(5)
          ),
          // prefixIcon: prefixIcon,
          // labelText: labelText,
          // labelStyle: const TextStyle(
          //     color: Colors.white,
          //     fontSize: 14
          // ),
        ),
        initialValue: phoneNumber,
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
