

import 'dart:ui';

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
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1000)).then((_){
      Global.loadUserInformation().then((result){
        if(result){
          if(Global.username != '' && Global.password != ''){
            carCategory.clear();
            brandList.clear();
            allCars.clear();
            searchCarList.clear();
            Api.login(Global.username, Global.password).then((data){
              carCategory.addAll(data!.category);
              brandList.addAll(data.brands);
              for(int i = 0; i < carCategory.length; i++){
                allCars.addAll(carCategory[i].cars!);
                searchCarList.addAll(carCategory[i].cars!);
              }
              Get.offNamed('/home');
            });
          }else{
            Get.offNamed('/login');
          }
        }
      });
    });
  }
}