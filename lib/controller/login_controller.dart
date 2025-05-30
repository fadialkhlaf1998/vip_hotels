import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
import 'package:vip_hotels/model/backend_style.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/api.dart';
import 'package:vip_hotels/services/global.dart';

class LoginController extends GetxController{

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool showPassword = false.obs;
  RxBool loading = false.obs;

  IntroController introController = Get.find();

  login() async {
    bool isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide > 600;
    introController.carCategory.clear();
    introController.brandList.clear();
    introController.allCars.clear();
    loading.value = true;
    if(username.text == 'guest' && password.text == 'guest'){
      Get.snackbar(
          'Warning', 'You can\'t Login as guest like this',
          margin: isTablet ? const EdgeInsets.only(top: 40, right: 150, left: 150) : const EdgeInsets.only(top: 40, right: 20, left: 20),
          backgroundColor: AppStyle.lightGrey
      );
      loading.value = false;
    }else{
      await  Api.login(username.text, password.text).then((data) async {
        if(data != null){
          /// get data
          print(data.username);
          await Global.saveUserInformation(data.id.toString(), data.title, data.username, data.password, data.image, data.companyId,data.email);
          Global.guest = false;

          BackEndStyle.header_image = data.header_image;
          BackEndStyle.footer_image = data.footer_image;
          BackEndStyle.inner_image = data.inner_image;
          BackEndStyle.selected_brand_bg_color = data.selected_brand_bg_color;
          BackEndStyle.selected_nav_bg_color = data.selected_nav_bg_color;
          BackEndStyle.card_border_color = data.card_border_color;
          BackEndStyle.card_bg_color = data.card_bg_color;
          BackEndStyle.category_color = data.category_color;
          BackEndStyle.body_color = data.body_color;
          BackEndStyle.title_color = data.title_color;
          BackEndStyle.primary_color = data.primary_color;

          introController.carCategory.addAll(data.category);
          introController.brandList.addAll(data.brands);
          for(int i = 0; i < introController.carCategory.length; i++){
            introController.allCars.addAll(introController.carCategory[i].cars!);
          }
          loading.value = false;
          username.clear();
          password.clear();
          isTablet ? Get.offAllNamed('/home') : Get.offAllNamed('/homeMobile') ;
        }else{
          loading.value = false;
          Get.snackbar(
              'Warning', 'Wrong email or password',
              margin: isTablet ? const EdgeInsets.only(top: 40, right: 150, left: 150) : const EdgeInsets.only(top: 40, right: 20, left: 20),
              backgroundColor: AppStyle.lightGrey
          );
        }
      });
    }


  }



  loginAsGuest() async {
    bool isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide > 600;
    loading.value = true;
    introController.carCategory.clear();
    introController.brandList.clear();
    introController.allCars.clear();
    await  Api.login('guest', 'guest').then((data) async {
      if(data != null){
        /// get data
        Global.image = data.image;
        Global.phone = data.phone;
        Global.id = data.id.toString();
        Global.companyId = data.companyId;
        Global.guest = true;

        BackEndStyle.header_image = data.header_image;
        BackEndStyle.footer_image = data.footer_image;
        BackEndStyle.inner_image = data.inner_image;
        BackEndStyle.selected_brand_bg_color = data.selected_brand_bg_color;
        BackEndStyle.selected_nav_bg_color = data.selected_nav_bg_color;
        BackEndStyle.card_border_color = data.card_border_color;
        BackEndStyle.card_bg_color = data.card_bg_color;
        BackEndStyle.category_color = data.category_color;
        BackEndStyle.body_color = data.body_color;
        BackEndStyle.title_color = data.title_color;
        BackEndStyle.primary_color = data.primary_color;

        introController.carCategory.addAll(data.category);
        introController.brandList.addAll(data.brands);
        for(int i = 0; i < introController.carCategory.length; i++){
          introController.allCars.addAll(introController.carCategory[i].cars!);
        }
        loading.value = false;
        username.clear();
        password.clear();
        isTablet ? Get.offAllNamed('/home') : Get.offAllNamed('/homeMobile');
      }else{
        loading.value = false;
        Get.snackbar(
            'Warning', 'Wrong email or password',
            margin: isTablet ? const EdgeInsets.only(top: 40, right: 150, left: 150) : const EdgeInsets.only(top: 40, right: 20, left: 20),
            backgroundColor: AppStyle.lightGrey
        );
      }
    });
  }


}