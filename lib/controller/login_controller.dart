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
    introController.carCategory.clear();
    introController.brandList.clear();
    introController.allCars.clear();
    loading.value = true;
    await  Api.login(username.text, password.text).then((data){
      if(data != null){
        /// get data
        Global.saveUserInformation(data.id.toString(), data.title, data.username, data.password, data.image, data.companyId,data.email);
        introController.carCategory.addAll(data.category);
        introController.brandList.addAll(data.brands);
        for(int i = 0; i < introController.carCategory.length; i++){
          introController.allCars.addAll(introController.carCategory[i].cars!);
        }
        loading.value = false;
        Get.offAllNamed('/home');
      }else{
        loading.value = false;
        Get.snackbar(
            'Warning', 'Wrong email or password',
            margin: const EdgeInsets.only(top: 40, right: 150, left: 150),
            backgroundColor: AppStyle.lightGrey
        );
      }
    });
  }





}