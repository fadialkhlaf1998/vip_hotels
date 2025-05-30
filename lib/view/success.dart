import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vip_hotels/model/backend_style.dart';

class Success extends StatelessWidget {

  RxBool init = false.obs;
  bool isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide > 600;


  Success(){
    Future.delayed(const Duration(milliseconds: 600)).then((value){
     init.value = true;
    });
    Future.delayed(const Duration(seconds: 5)).then((value){
      init.value = false;
      isTablet
          ? Get.offAllNamed('/home')
      :  Get.offAllNamed('/homeMobile');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          // decoration: const BoxDecoration(
          //     image: DecorationImage(
          //         fit: BoxFit.cover,
          //         image: AssetImage('assets/images/homeBackground.jpg')
          //     )
          // ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              Text('We Successfully Added Your Booking.', style: TextStyle(
              color: BackEndStyle.title_color,
              fontFamily: 'graphik',
              fontSize: isTablet ?  27 : 18,
              fontWeight: FontWeight.bold
              )),
              const SizedBox(height: 20),
              Text('A Confirmation Email Will Be Sent To You.', style: TextStyle(
                  color:  BackEndStyle.title_color,
                  fontFamily: 'graphik',
                  fontSize: isTablet ?  27 : 18,
                  fontWeight: FontWeight.bold
              )),
              const SizedBox(height: 40),
              Icon(Icons.check_circle_outline,color: BackEndStyle.primary_color,size: 300,),
              // Obx(() =>  !init.value
              //     ? const SizedBox(height: 300)
              //     : Lottie.asset("assets/tick.json",width: isTablet ?  300: 200,height: isTablet ?  300: 200,frameRate: FrameRate(1000),)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
