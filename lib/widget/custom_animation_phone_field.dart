import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vip_hotels/controller/book_page_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';

class CustomAnimatedPhoneField extends StatelessWidget {


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
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      right: right,
      bottom: bottom,
      duration: Duration(milliseconds: duration),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: Get.width * width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2,color: validate?Colors.red:AppStyle.lightGrey)
        ),
        child: InternationalPhoneNumberInput(
          // style: const TextStyle(
          //   color: Colors.white,
          // ),
          inputBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2,
                  color: Colors.red
              ),
              borderRadius: BorderRadius.circular(5)
          ),
          maxLength: 11,
          onInputChanged: (value){
            // print(value.phoneNumber!.split(value.dialCode!)[1].length);
            // if(value.phoneNumber!.split(value.dialCode!)[1].length <=9){
            //

            // }
            controller.text =  value.phoneNumber!;
            print(controller.text);
          },
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          selectorTextStyle: const TextStyle(
            color: Colors.grey,
          ),
          // controller: controller,
          // maxLength: 9,
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
          initialValue: PhoneNumber(isoCode: "AE",dialCode: "+971"),
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
