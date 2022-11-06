import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
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
    await  Api.login(username.text, password.text).then((data) async {
      if(data != null){
        /// get data
        await Global.saveUserInformation(data.id.toString(), data.title, data.username, data.password, data.image, data.companyId,data.email);
        introController.carCategory.addAll(data.category);
        introController.brandList.addAll(data.brands);
        for(int i = 0; i < introController.carCategory.length; i++){
          introController.allCars.addAll(introController.carCategory[i].cars!);
        }
        loading.value = false;
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



  loginAsGuest() async {
    bool isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide > 600;
    loading.value = true;
    await  Api.login('guest', 'guest').then((data) async {
      if(data != null){
        /// get data
        Global.image = data.image;
        Global.id = data.id.toString();
        Global.companyId = data.companyId;
        introController.carCategory.addAll(data.category);
        introController.brandList.addAll(data.brands);
        for(int i = 0; i < introController.carCategory.length; i++){
          introController.allCars.addAll(introController.carCategory[i].cars!);
        }
        loading.value = false;
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