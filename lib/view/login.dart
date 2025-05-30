import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vip_hotels/controller/login_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/widget/custom_button.dart';
import 'package:vip_hotels/widget/custom_image_container.dart';
import 'package:vip_hotels/widget/custom_logo_black.dart';
import 'package:vip_hotels/widget/custom_text_field.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {

  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light

    ));
    return Obx((){
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: SizedBox(
                  height: Get.height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          top: 0,
                          child: CustomImageContainer(width: 1, height: 0.5, image: 'assets/images/login_bg.jpg')),
                      // CustomImageContainer(width: 0.5, height: 1, image: 'assets/images/login_background1.png'),

                      Positioned(
                        bottom: 0,
                        child: _inputData(),)

                    ],
                  ),
                ),
              ),
              loginController.loading.value ? Container(
                width: Get.width,
                height: Get.height,
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 6),
                ),
              ) : const Center(),
            ],
          ),
        ),
      );
    });
  }

  _inputData(){
    return Container(
      height: Get.height*0.6,
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLogoBlack(width: 1, height: 0.1, tag: 'logo'),
          const SizedBox(height: 30),
          Container(
            width: 250,
            child: RichText(
              text: const TextSpan(
                  text: 'Live the Luxury With ',
                  style: TextStyle(
                    fontFamily: 'bankgothic',
                    fontSize: 26,
                    color: AppStyle.lightGrey,
                  ),
                  children: [
                    TextSpan(text: 'VIP', style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold, color: AppStyle.vipBlue)),
                  ]
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          CustomTextField(
            width: 0.6,
            height: 55,
            controller: loginController.username,
            prefixIcon: const Icon(Icons.person, color: AppStyle.vipBlue),
            suffixIcon: const Icon(Icons.person, color: AppStyle.vipBlue, size: 0),
            hintText: 'User name',
            keyboardType: TextInputType.text,
            textVisible: false,
            maxLength: 30,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            width: 0.6,
            height: 55,
            controller: loginController.password,
            prefixIcon: const Icon(Icons.lock, color: AppStyle.vipBlue),
            suffixIcon: GestureDetector(
              onTap: (){
                print('-------');
                loginController.showPassword.value = !loginController.showPassword.value;
              },
              child:  loginController.showPassword.value ? const Icon(Icons.visibility_off, color: AppStyle.vipBlue) : const Icon(Icons.visibility, color: AppStyle.vipBlue),
            ),
            hintText: 'Password',
            keyboardType: TextInputType.text,
            textVisible: !loginController.showPassword.value,
            maxLength: 30,
          ),
          const SizedBox(height: 30),
          CustomButton(
              width: 0.6,
              height: 45,
              text: 'GO NOW',
              onPressed: (){
                FocusManager.instance.primaryFocus?.unfocus();
                loginController.login();
              },
              color: AppStyle.vipBlue,
              borderRadius: 5,
              textStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)
          ),
          const SizedBox(height: 15),
          CustomButton(
              width: 0.6,
              height: 45,
              text: 'Login as guest',
              onPressed: (){
                FocusManager.instance.primaryFocus?.unfocus();
                loginController.loginAsGuest();
              },
              color: AppStyle.vipGray,
              borderRadius: 5,
              textStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }


}
