

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DetailsPageController extends GetxController{

  ItemScrollController itemScrollController = ItemScrollController();


  RxBool galleryOpenPage = false.obs;
  RxInt optionIndex = 0.obs;
  RxInt optionId = (-1).obs;
  RxBool optionChangeTimer = false.obs;
  RxInt mainCarImageIndex = 1.obs;
  RxBool openGallery = false.obs;


  changeOptionColor(index){
    optionIndex.value = index;
    optionChangeTimer.value = true;
    Future.delayed(const Duration(milliseconds: 200)).then((value){
      optionChangeTimer.value = false;
    });
  }

  Future scrollToItem(index, lastIndex) async{
    itemScrollController.scrollTo(
        index: index,
        alignment: index == 0 ? 0 : index == lastIndex - 1 ? 0.5 : 0.4,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 1000)
    );
  }

}