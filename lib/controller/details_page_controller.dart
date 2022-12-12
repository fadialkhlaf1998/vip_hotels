
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

class DetailsPageController extends GetxController{

  ItemScrollController itemScrollController = ItemScrollController();


  RxBool galleryOpenPage = false.obs;
  RxInt optionIndex = 0.obs;
  RxInt optionId = (-1).obs;
  RxBool optionChangeTimer = false.obs;
  RxInt mainCarImageIndex = 1.obs;
  RxBool openGallery = false.obs;
  RxBool changeColor = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    change();
  }

  change() async {
    while(true){
      await Future.delayed(const Duration(milliseconds: 1300)).then((value){
        changeColor.value = !changeColor.value;
      });
    }

  }

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

  shareCar(String image, String name, String shareLink) async {
    loading.value = true;
    final url = Uri.parse(image);
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path], text: '$name \n\n $shareLink');
    loading.value = false;
  }

}