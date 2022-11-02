import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vip_hotels/services/AppStyle.dart';

class Success extends StatelessWidget {

  RxBool init = false.obs;

  Success(){

    Future.delayed(Duration(milliseconds: 500)).then((value){
      init.value = true;
    });
    Future.delayed(Duration(seconds: 5)).then((value){
      init.value = false;
      Get.offNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/homeBackground.jpg')
              )
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              const Text('We Successfully Added Your Booking.', style: TextStyle(
              color: Colors.white,
              fontFamily: 'D-DIN-PRO',
              fontSize: 27,
              fontWeight: FontWeight.bold
              )),
              SizedBox(height: 20,),
              const Text('A Confirmation Email Will Be Sent To You.', style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'D-DIN-PRO',
                  fontSize: 27,
                  fontWeight: FontWeight.bold
              )),
              SizedBox(height: 40,),
              Obx(() =>  !init.value?SizedBox(height: 300,):Lottie.asset("assets/tick.json",width: 300,height: 300,frameRate: FrameRate(1000),),),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
