import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/api.dart';
import 'package:vip_hotels/services/global.dart';

class IntroController extends GetxController{

  RxList<Category> carCategory = <Category>[].obs;
  RxList<Brand> brandList = <Brand>[].obs;
  RxList<Car> allCars = <Car>[].obs;
  List<Car> searchCarList = <Car>[];

  @override
  void onInit() async{
    super.onInit();
    bool isTablet = false;
    bool iPad = await isIpad();
    if(MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide > 600 || iPad){
      isTablet = true;
    }
    getData(isTablet);
  }

  Future<bool> isIpad() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.model!=null && info.model!.toLowerCase().contains("ipad")) {
      print(info.model);
      return true;
    }
    return false;
  }


  getData(bool isTablet)async{
      bool result = await Global.loadUserInformation();
      if(Global.username != '' && Global.password != ''){
        carCategory.clear();
        brandList.clear();
        allCars.clear();
        searchCarList.clear();
        await getLoginData();
        isTablet ? Get.offNamed('/home') : Get.offNamed('/homeMobile');
      }else{
      isTablet ? Get.offNamed('/login') : Get.offNamed('/loginMobile');
      }

  }

  Future<bool> getLoginData()async{
    AllData? data = await Api.login(Global.username, Global.password);
    if(data == null){
      return await getLoginData();
    }else{
      carCategory.addAll(data.category);
      brandList.addAll(data.brands);
      for(int i = 0; i < carCategory.length; i++){
        allCars.addAll(carCategory[i].cars!);
        searchCarList.addAll(carCategory[i].cars!);
      }
      return true;
    }

  }
}