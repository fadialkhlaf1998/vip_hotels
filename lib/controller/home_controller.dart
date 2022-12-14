
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
  RxBool brandOpenMenu = true.obs;
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
  RxInt brandIndex = (-1).obs;
  TextEditingController myController = TextEditingController();
  RxInt lazyLoad = 0.obs;
  RxInt lazyLoadFilter = 0.obs;
  RxBool logoutConfirm = false.obs;

  initLazyLoad(){
    if(introController.allCars.length > 12){
      lazyLoad.value = 12;
    }else{
      lazyLoad.value = introController.allCars.length;
    }
  }


  addLazyLoad(){
    if( 6 + lazyLoad.value<=introController.allCars.length){
      lazyLoad.value += 6;
    }else{
      lazyLoad.value = introController.allCars.length;
    }
  }

  initLazyLoadFilter(){
    if(filterCarList.length > 12){
      lazyLoadFilter.value = 12;
    }else{
      lazyLoadFilter.value = filterCarList.length;
    }
  }


  addLazyLoadFilter(){
    if( 6 + lazyLoadFilter.value<=filterCarList.length){
      lazyLoadFilter.value += 6;
    }else{
      lazyLoadFilter.value = filterCarList.length;
    }
  }


  @override
  void onInit() async {
    super.onInit();
    selectImageIndex.value = await Global.getTheme();
    for(double i = 2.25; i < 5; i += 1.25){
      if(selectImageIndex.value == i.floor()){
        angle.value = -(i % 1);
      }
    }
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
        brandOpenMenu.value = true;
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
        clearFilter();
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
    for(int i = 0; i < introController.carCategory.length; i++){
      introController.allCars.addAll(introController.carCategory[i].cars!);
    }
    loading.value = false;
    searchOpenTextDelegate.value = false;
    brandOpenMenu.value = true;
    chooseBrand.value = false;
    themeOpenPage.value = false;
    selectIndexSidebar.value = -1;
    selectionIndexBottomBar.value = -1;
    goToTheTop();
    brandIndex.value = -1;
    // clearFilter();
  }

  selectIndexBottomBar(index){
    introController.allCars.clear();
    loading.value = true;
    if(index == -1){
      selectionIndexBottomBar.value = -1;
      for(int i = 0; i < introController.carCategory.length; i++){
        introController.allCars.addAll(introController.carCategory[i].cars!);
      }
    }else{
      selectionIndexBottomBar.value = index;
      introController.allCars.addAll(introController.carCategory[index].cars!);
    }
    initLazyLoad();
    loading.value = false;
    goToTheTop();
  }


  chooseCarFilter(index){
    if(loading.value != true){
      loading.value = true;
      selectionIndexBottomBar.value = -1;
      filterCarList.clear();
      brandId.value = introController.brandList[index].id ;
      brandIndex.value = index;
      Api.filter([brandId.value], []).then((data){
        if(data != null){
          filterCarList.addAll(data);
        }
        initLazyLoadFilter();
        loading.value = false;
        chooseBrand.value = true;
      });
      goToTheTop();
    }
  }



  chooseCategoryForFilter(index, categoryId){
    loading.value = true;
    selectionIndexBottomBar.value = index;
    filterCarList.clear();
    Api.filter([brandId.value], [categoryId]).then((data){
      if(data != null){
        filterCarList.addAll(data);
      }
      initLazyLoadFilter();
      loading.value = false;
      chooseBrand.value = true;
    });
    goToTheTop();
  }



  clearFilter(){
    chooseBrand.value = false;
    // brandOpenMenu.value = false;
    selectIndexBottomBar(-1);
    selectIndexSidebar.value = -1;
    loading.value = true;
    introController.allCars.clear();
    for(int i = 0; i < introController.carCategory.length; i++){
      introController.allCars.addAll(introController.carCategory[i].cars!);
    }
    brandIndex.value = -1;
    initLazyLoad();
    loading.value = false;
    goToTheTop();
  }

  goToTheTop(){
    scrollController.animateTo(0, duration: const Duration(milliseconds: 1000), curve: Curves.fastOutSlowIn);
  }

  logout(){
    Global.clear();
    if(MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide > 600){
      Get.offAllNamed('/login');
    }else{
      Get.offAllNamed('/loginMobile');
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