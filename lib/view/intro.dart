import 'package:flutter/material.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
import 'package:vip_hotels/controller/login_controller.dart';
import 'package:vip_hotels/view/login.dart';
import 'package:vip_hotels/widget/custom_image_container.dart';
import 'package:vip_hotels/widget/custom_logo.dart';
import 'package:get/get.dart';

class Intro extends StatefulWidget {

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool isTablet = false;
    if(MediaQuery.of(context).size.width > 600){
      isTablet = true;
    }
    introController.getData(isTablet);
  }

  IntroController introController = Get.put(IntroController());

  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageContainer(width: 1, height: 1, image: 'assets/images/intro_background.png'),
          CustomLogo(width: 0.35, height: 0.35, tag: 'logo')
        ],
      ),
    );
  }
}
