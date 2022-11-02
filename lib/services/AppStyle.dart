

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStyle{

  static const primary = Color(0xFFe0d206);
  static const grey = Color(0xFF323232);
  static const green = Color(0xFF3bd16f);
  static const lightGrey = Color(0xFF888888);


  static const defaultTextStyle = TextStyle(
      fontFamily: 'D-DIN-PRO',
      fontSize: 30,
      color: lightGrey,
  );

  static errorNotification(context, title, subTitle){
    return Get.snackbar(
        title,
        subTitle,
        margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.warning));
  }

  static successNotification(context,title, subTitle){
    return Get.snackbar(
        title,
        subTitle,colorText: Colors.white,
        margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
        backgroundColor: Colors.black.withOpacity(0.8),
        icon: const Icon(Icons.check,color: Colors.white,),
      boxShadows: [
        BoxShadow(
          color: Colors.white.withOpacity(0.5),
          blurRadius: 0.1
        )
      ]
    );
  }

  static noteNotification(context,title, subTitle){
    return Get.snackbar(
        title,
        subTitle,
        margin: const EdgeInsets.only(top: 20,left: 25,right: 25),
        backgroundColor: Colors.grey,
        icon: const Icon(Icons.warning)
    );
  }

}