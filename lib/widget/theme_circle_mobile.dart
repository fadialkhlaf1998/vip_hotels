import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/global.dart';


class ThemeCircleMobile extends StatefulWidget{

  @override
  State<ThemeCircleMobile> createState() => _ThemeCircleState();
}

class _ThemeCircleState extends State<ThemeCircleMobile> with SingleTickerProviderStateMixin{
  HomeController homeController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Stack(
        children: [
         GestureDetector(
           onTap: (){
             homeController.themeOpenPage.value = false;
           },
           child:  Container(
             width: Get.width,
             height: Get.height,
             color: Colors.black.withOpacity(0.8),
           ),
         ),
          Container(
            height: Get.height,
            width: Get.width,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  bottom: - Get.width * 0.45,
                  child:  AnimatedRotation(
                    turns: homeController.angle.value,
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.fastOutSlowIn,
                    child:  Container(
                      width: Get.width * 0.9,
                      height: Get.width * 0.9,
                      // color: Colors.red,
                      child: SvgPicture.asset('assets/icons/VIP Theme Navigator.svg',fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: Get.width * 0.7,
                    height: Get.width * 0.35,
                    decoration: const BoxDecoration(
                      color: AppStyle.lightGrey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1000),
                          topRight: Radius.circular(1000)
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      child: !homeController.switchImage.value ? _imageTheme()
                          : const Text('')
                  ),
                ),
                _logoText(),
              ],
            ),
          ),
        ],
      );
    });
  }

  _imageTheme(){
    return  Container(
      width: Get.width * 0.7,
      height: Get.width * 0.35,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(1000),
              topRight: Radius.circular(1000)
          ),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/${homeController.themeImages[homeController.selectImageIndex.value - 1]}.png')
          )
      ),
    );
  }

  _logoText(){
    return Container(
      width: Get.width,
      height: Get.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: Get.width * 0.6,
                height: Get.height * 0.15,
                child: SvgPicture.asset('assets/icons/triangle.svg',fit: BoxFit.contain),
              ),
              Container(
                width: Get.width * 0.28,
                height: Get.height * 0.1,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Image.network(Global.image, fit: BoxFit.contain),
              ),
            ],
          ),
          Column(
            children: const [
              Text(
                'Choose Your Theme And',
                style: TextStyle(
                  color: AppStyle.lightGrey,
                  fontFamily: 'graphik',
                  fontSize: 21,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              Text(
                'GO WITH US',
                style: TextStyle(
                    color: AppStyle.primary,
                    fontFamily: 'graphik',
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: (){
              homeController.selectionImageTheme();
            },
            child: Container(
              width: Get.width * 0.4,
              height: Get.height * 0.05,
              decoration: BoxDecoration(
                color: AppStyle.primary,
                borderRadius: BorderRadius.circular(5)
              ),
              child: const Center(
                child: Text(
                  'Selection',
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  await homeController.backwardRotation();
                },
                child: Container(
                  color: Colors.transparent,

                  child: Padding(
                    padding: const EdgeInsets.only(left: 30,bottom: 20, top: 20),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white,size: homeController.angle.value == 0 ? 0 : 30),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await homeController.forwardRotation();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30,bottom: 20,top: 20),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white,size: homeController.angle.value == -0.75 ? 0 : 30),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }


}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..lineTo(x / 2, y)
      ..lineTo(x, 0)
      ..lineTo(0, 0);
      // ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

