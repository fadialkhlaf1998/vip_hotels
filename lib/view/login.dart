


import 'package:flutter/material.dart';
import 'package:vip_hotels/controller/login_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/widget/custom_button.dart';
import 'package:vip_hotels/widget/custom_image_container.dart';
import 'package:vip_hotels/widget/custom_logo.dart';
import 'package:vip_hotels/widget/custom_text_field.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {

  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                    child: SizedBox(
                      height: Get.height - (MediaQuery.of(context).padding.bottom + MediaQuery.of(context).padding.top),
                      child: Row(
                        children: [
                          CustomImageContainer(width: 0.5, height: 1, image: 'assets/images/login_background.png'),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomImageContainer(width: 0.5, height: 1, image: 'assets/images/login_background1.png'),
                              _inputData(),

                            ],
                          ),
                        ],
                      ),
                    )
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomLogo(width: 0.3, height: 0.3, tag: 'logo'),
        const SizedBox(height: 20),
        RichText(
          text: const TextSpan(
           text: 'Live the Luxury With ',
              style: AppStyle.defaultTextStyle,
            children: [
              TextSpan(text: 'VIP', style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold, color: AppStyle.primary)),
            ]
          ),
        ),
        const SizedBox(height: 25),
        CustomTextField(
            width: 0.4,
            height: 55,
            controller: loginController.username,
            prefixIcon: const Icon(Icons.person, color: AppStyle.primary),
            suffixIcon: const Icon(Icons.person, color: AppStyle.primary, size: 0),
            hintText: 'User name',
            keyboardType: TextInputType.text,
            textVisible: false,
            maxLength: 30,
        ),
        const SizedBox(height: 15),
        CustomTextField(
            width: 0.4,
            height: 55,
            controller: loginController.password,
            prefixIcon: const Icon(Icons.lock, color: AppStyle.primary),
            suffixIcon: GestureDetector(
              onTap: (){
                print('-------');
                loginController.showPassword.value = !loginController.showPassword.value;
              },
              child:  loginController.showPassword.value ? const Icon(Icons.visibility_off, color: AppStyle.primary) : const Icon(Icons.visibility, color: AppStyle.primary),
            ),
            hintText: 'Password',
            keyboardType: TextInputType.text,
            textVisible: !loginController.showPassword.value,
            maxLength: 30,
        ),
        const SizedBox(height: 30),
        CustomButton(
            width: 0.1,
            height: 45,
            text: 'GO NOW',
            onPressed: (){
              FocusManager.instance.primaryFocus?.unfocus();
              loginController.login();
            },
            color: AppStyle.primary,
            borderRadius: 5,
            textStyle: const TextStyle(color: Colors.black,fontSize: 15)
        )
      ],
    );
  }


}
