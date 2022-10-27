import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/api.dart';
import 'package:vip_hotels/services/global.dart';

class LoginController extends GetxController{

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool showPassword = false.obs;

  IntroController introController = Get.find();

  login() async {
    introController.carCategory.clear();
    introController.brandList.clear();
    introController.allCars.clear();
    await  Api.login(username.text, password.text).then((data){
      if(data != null){
        /// get data
        Global.saveUserInformation(data.id.toString(), data.title, data.username, data.password, data.image, data.companyId,data.email);
        introController.carCategory.addAll(data.category);
        introController.brandList.addAll(data.brands);
        for(int i = 0; i < introController.carCategory.length; i++){
          introController.allCars.addAll(introController.carCategory[i].cars!);
        }
        Get.offAllNamed('/home');
      }
    });
  }





}