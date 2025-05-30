import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/global.dart';


class ThemeCircle extends StatefulWidget{

  @override
  State<ThemeCircle> createState() => _ThemeCircleState();
}

class _ThemeCircleState extends State<ThemeCircle> with SingleTickerProviderStateMixin{
  HomeController homeController = Get.find();

  bool left =true;


  @override
  Widget build(BuildContext context) {
    return Obx((){
      return GestureDetector(
        onTap: () {
          homeController.themeOpenPage.value = false;
          homeController.selectIndexSidebar.value = 2;
        },
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            left =false;
          }
          if (details.delta.dx < 0) {
            left =true;
          }
        },
        onPanEnd: (e){
          if(left){
            homeController.forwardRotation();
          }else{
            homeController.backwardRotation();
          }
        },
        child: Container(
          width: Get.width,
          height: Get.height,
          color: Colors.black.withOpacity(0.8),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50,bottom: 20),
                    child: GestureDetector(
                      onTap: () async {
                        await homeController.backwardRotation();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30, bottom: 20),
                        child: Icon(Icons.arrow_back_ios, color: Colors.white,size: homeController.angle.value == 0 ? 0 : 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50,bottom: 20),
                    child: GestureDetector(
                      onTap: () async {
                        await homeController.forwardRotation();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30, bottom: 20),
                        child: Icon(Icons.arrow_forward_ios, color: Colors.white,size: homeController.angle.value == -0.75 ? 0 : 40),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: - Get.width * 0.30,
                child:  AnimatedRotation(
                  turns: homeController.angle.value,
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastOutSlowIn,
                  child:  Container(
                    width: Get.width * 0.60,
                    height: Get.width * 0.60,
                    // color: Colors.red,
                    child: SvgPicture.asset('assets/icons/VIP Theme Navigator.svg',fit: BoxFit.cover,),
                  ),
                ),
              ),
              Container(
                width: Get.width * 0.5,
                height: Get.width * 0.25,
                decoration: const BoxDecoration(
                  color: AppStyle.lightGrey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1000),
                      topRight: Radius.circular(1000)
                  ),
                ),
              ),
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: !homeController.switchImage.value ? _imageTheme()
                      : const Text('')
              ),
              _logoText(),
            ],
          ),
        ),
      );
    });
  }
  _imageTheme(){
    return  GestureDetector(

      child: Container(
        width: Get.width * 0.5,
        height: Get.width * 0.25,
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
      ),
    );
  }

  _logoText(){
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: Get.width * 0.35,
              height: Get.height * 0.2,
              child: SvgPicture.asset('assets/icons/triangle.svg',fit: BoxFit.contain, alignment: Alignment.topCenter,),
            ),
            Container(
              width: Get.width * 0.15,
              height: Get.height * 0.1,
              margin: EdgeInsets.only(top: 5),
              child: Image.network(Global.image, fit: BoxFit.contain),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Choose Your Theme And',
          style: TextStyle(
            color: AppStyle.lightGrey,
            fontFamily: 'graphik',
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'GO WITH US',
          style: TextStyle(
            color: AppStyle.primary,
            fontFamily: 'graphik',
            fontSize: 35,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 45),
        GestureDetector(
          onTap: (){
            homeController.selectionImageTheme();
          },
          child: Container(
            width: 150,
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
        )
      ],
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

