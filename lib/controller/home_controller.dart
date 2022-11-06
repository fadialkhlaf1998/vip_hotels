
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/api.dart';
import 'package:vip_hotels/services/global.dart';

class HomeController extends GetxController{

  IntroController introController = Get.find();
  RxList themeImages = ['Background 1','Background 2','Background 3','Background 4'].obs;
  RxInt selectIndexSidebar = (-1).obs;
  RxBool searchOpenTextDelegate = false.obs;
  RxBool brandOpenMenu = false.obs;
  RxBool themeOpenPage = false.obs;
  ScrollController scrollController = ScrollController();
  RxInt selectImageIndex = 1.obs;
  RxBool switchImage = false.obs;
  RxInt selectionIndexBottomBar = (-1).obs;
  RxDouble angle = 0.0.obs;
  RxList<Car> filterCarList = <Car>[].obs;
  RxBool chooseBrand = false.obs;
  RxBool loading = false.obs;
  RxInt brandId = 0 .obs;
  TextEditingController myController = TextEditingController();



  @override
  void onInit() async {
    super.onInit();
    selectImageIndex.value = await Global.getTheme();
    for(double i = 2.25; i < 5; i += 1.25){
      if(selectImageIndex.value == i.floor()){
        angle.value = -(i % 1);
      }
    }
    // angle.value = await Global.getAngle();
  }

  forwardRotation()async {
    if(angle.value > -0.75){
      angle.value -= 0.25;
      selectImageIndex.value += 1;
    }
    switchImage.value = true;
    await Future.delayed(const Duration(milliseconds: 50)).then((value){
      switchImage.value = false;
    });
  }

  backwardRotation() async {
    if(angle.value < 0){
      angle.value += 0.25;
      selectImageIndex.value -= 1;
    }
    switchImage.value = true;
    await Future.delayed(const Duration(milliseconds: 50)).then((value){
      switchImage.value = false;
    });
  }

  selectionImageTheme(){
    themeOpenPage.value = false;
    selectIndexSidebar.value = -1;
    Global.saveTheme(selectImageIndex.value, angle.value);
  }


  onTapSideBar(index){
    selectIndexSidebar.value = index;
    if(selectIndexSidebar.value == 0){
      if(searchOpenTextDelegate.value == true){
        searchOpenTextDelegate.value = false;
        selectIndexSidebar.value = -1;
      }else{
        searchOpenTextDelegate.value = true;
        brandOpenMenu.value = false;
        themeOpenPage.value = false;
        goToTheTop();
      }
    }else if(selectIndexSidebar.value == 1){
      if(brandOpenMenu.value == true){
        brandOpenMenu.value = false;
        selectIndexSidebar.value = -1;
      }else{
        searchOpenTextDelegate.value = false;
        brandOpenMenu.value = true;
        themeOpenPage.value = false;
        goToTheTop();
      }
    }else if(selectIndexSidebar.value == 2){
      if(themeOpenPage.value == true){
        themeOpenPage.value = false;
        selectIndexSidebar.value = -1;
      }else{
        searchOpenTextDelegate.value = false;
        brandOpenMenu.value = false;
        themeOpenPage.value = true;
      }
    }
  }
  
  homeButton(){
    introController.allCars.clear();
    if(brandOpenMenu.value = true){
      for(int i = 0; i < introController.carCategory.length; i++){
        introController.allCars.addAll(introController.carCategory[i].cars!);
      }
      loading.value = false;
    }
    searchOpenTextDelegate.value = false;
    brandOpenMenu.value = false;
    chooseBrand.value = false;
    themeOpenPage.value = false;
    selectIndexSidebar.value = -1;
    goToTheTop();
  }

  selectIndexBottomBar(index){
    introController.allCars.clear();
    if(index == -1){
      selectionIndexBottomBar.value = -1;
      for(int i = 0; i < introController.carCategory.length; i++){
        introController.allCars.addAll(introController.carCategory[i].cars!);
      }
    }else{
      selectionIndexBottomBar.value = index;
      introController.allCars.addAll(introController.carCategory[index].cars!);
    }
    goToTheTop();
  }


  chooseCarFilter(index){
    loading.value = true;
    selectionIndexBottomBar.value = -1;
    filterCarList.clear();
    brandId.value = index;
    Api.filter([index], []).then((data){
      if(data != null){
        filterCarList.addAll(data);
        print('------------');
        print(filterCarList.length);
      }
      loading.value = false;
      chooseBrand.value = true;
    });
    goToTheTop();
  }



  chooseCategoryForFilter(index, categoryId){
    loading.value = true;
    selectionIndexBottomBar.value = index;
    filterCarList.clear();
    Api.filter([brandId.value], [categoryId]).then((data){
      if(data != null){
        filterCarList.addAll(data);
      }
      loading.value = false;
      chooseBrand.value = true;
    });
    goToTheTop();
  }



  clearFilter(){
    chooseBrand.value = false;
    brandOpenMenu.value = false;
    selectIndexSidebar.value = -1;
    loading.value = true;
    for(int i = 0; i < introController.carCategory.length; i++){
      introController.allCars.addAll(introController.carCategory[i].cars!);
    }
    loading.value = false;
    goToTheTop();
  }

  goToTheTop(){
    scrollController.animateTo(0, duration: const Duration(milliseconds: 1000), curve: Curves.fastOutSlowIn);
  }

  logout(){
    Global.clear();
    if(MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide > 600){
      Get.offNamed('/login');
    }else{
      Get.offNamed('/loginMobile');
    }

  }

  // filterSearchResults(String query) {
  //     List<Car> dummySearchList = <Car>[];
  //     dummySearchList.addAll(introController.allCars);
  //     if(query.isNotEmpty) {
  //       List<Car> dummyListData = <Car>[];
  //       for (var car in dummySearchList) {
  //         if(car.title.toLowerCase().contains(query)) {
  //           dummyListData.add(car);
  //         }
  //       }
  //       tempCarList.clear();
  //       tempCarList.addAll(dummyListData);
  //       return;
  //     } else {
  //       tempCarList.clear();
  //       tempCarList.addAll(introController.allCars);
  //     }
  // }



}