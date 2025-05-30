import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/home_controller.dart';

class BackgroundImage extends StatelessWidget {

  HomeController homeController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Container(
        width: Get.width,
        height: Get.height,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: !homeController.switchImage.value
              ? Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                // image: AssetImage('assets/images/${homeController.themeImages[homeController.selectImageIndex.value - 1]}.png')
                image: AssetImage('assets/images/car_details_bg.PNG')
              )
            ),
              ) : Center()
        ),
      );
    });
  }
}
