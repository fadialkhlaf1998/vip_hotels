

import 'package:get/get.dart';

class DetailsPageController extends GetxController{

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

}