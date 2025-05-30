import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/model/backend_style.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/api.dart';
import 'package:vip_hotels/services/global.dart';
import 'package:vip_hotels/widget/backgroundImage.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/widget/car_gallery_mobile.dart';
import 'package:vip_hotels/widget/custom_logo.dart';
import 'package:vip_hotels/widget/theme_circle_mobile.dart';


class CarDetailsMobile extends StatelessWidget {

  HomeController homeController = Get.find();
  DetailsPageController detailsPageController = Get.find();

  Car car = Get.arguments[0];

  CarDetailsMobile(){
    detailsPageController.mainCarImageIndex.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    detailsPageController.optionIndex.value = 0;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
    ));
    return Obx((){
      return WillPopScope(
        onWillPop: ()async{
          if(homeController.themeOpenPage.value || detailsPageController.openGallery.value){
            homeController.themeOpenPage.value = false;
            homeController.selectIndexSidebar.value = -1;
            detailsPageController.openGallery.value = false;
            return false;
          }else{
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                BackgroundImage(),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                      width: Get.width,
                      height: 430,
                      decoration: BoxDecoration(
                        color: Color(0xff5959594D),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Get.width,
                            height: Get.width/5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(BackEndStyle.inner_image),
                                fit: BoxFit.cover
                              )
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 20,),
                                GestureDetector(
                                  onTap: (){
                                    Get.back();
                                  },
                                  child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                                )
                              ],
                            ),
                          ),
                          // SizedBox(height: 20,),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: BackEndStyle.card_bg_color.withOpacity(0.5),
                                          shape: BoxShape.circle
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(car.brandImage)
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.6,
                                            child: Text(
                                              car.title,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                            
                            
                                        ],
                                      )
                                    ],
                                  ),
                            
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // SizedBox(width: 20,),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(4)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset("assets/icons/door_icon.svg",width: 15,color: Colors.white,),
                                            SizedBox(width: 5,),
                                            Text(car.doors.toString()+" Doors",style: TextStyle(color: Colors.white,fontSize: 12),)
                                          ],
                                        ),
                                      ),
                                      // SizedBox(width: 15,),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(4)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset("assets/icons/seat_icon.svg",width: 15,color: Colors.white),
                                            SizedBox(width: 5,),
                                            Text(car.seets.toString()+" Seats",style: TextStyle(color: Colors.white,fontSize: 12),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Price",
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            !Global.guest
                                                ? 'AED ${car.price.toString()}  '
                                                : 'AED ****  ',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                            
                                          Text("Daily",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                            
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Security Deposit: AED ${car.insurance_price}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                            
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 20,),
                                      GestureDetector(
                                        onTap: (){
                                          if(detailsPageController.optionId.value == -1){
                                            detailsPageController.optionId.value = car.options.first.id;
                                          }
                                          Get.toNamed('/bookMobile', arguments: [car]);
                                        },
                                        child: Container(
                                          width: 150,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: BackEndStyle.primary_color,
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Book now',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                            
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 20,),
                                      GestureDetector(
                                        onTap: (){
                                          detailsPageController.openGallery.value = true;
                                        },
                                        child: Container(
                                          width: 150,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.white)
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Mora Images',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                            
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(height: 20,),
                        ],
                      ),
                    ),
                    // _bottomNavBar(),

                  ],
                ),

                /// Car Image
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  right: detailsPageController.optionChangeTimer.value ? -20 : 20,
                  curve: Curves.fastOutSlowIn,
                  bottom: 50,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: !detailsPageController.optionChangeTimer.value ? Container(
                      margin: EdgeInsets.only(left: Get.width * 0.3,bottom: Get.width * 0.1),
                      width: Get.width * 0.9,
                      height: Get.height * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                              image: NetworkImage('${Api.url}uploads/${car.options[detailsPageController.optionIndex.value].images.split(',')[0]}')
                          )
                      ),
                    ) : const Text(''),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: homeController.themeOpenPage.value ? ThemeCircleMobile() : const Text(''),
                ),

                CarGalleryMobile(carImage: car.options[detailsPageController.optionIndex.value].images)
              ],
            ),
          ),
        ),
      );
    });
  }

  _bottomNavBar(){
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: Get.width,
      height: 55,
      decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30)
          )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: (){
              detailsPageController.openGallery.value = true;
            },
            child: Column(
              children: [
                SizedBox(
                    width: 25,
                    height: 25,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: detailsPageController.openGallery.value
                          ? SvgPicture.asset('assets/icons/gallery.svg', color: Colors.white, key: Key('0'),)
                          : SvgPicture.asset('assets/icons/gallery.svg', color: AppStyle.lightGrey,  key: Key('1'),),
                    )
                ),
                const SizedBox(height: 5),
                Text(
                  'Gallery',
                  style: TextStyle(color: detailsPageController.openGallery.value ? Colors.white : Colors.grey, fontFamily: 'graphik', fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              // homeController.homeButton();
              Get.back();
            },
            child: Column(
              children: [
                SizedBox(
                    width:   25,
                    height:  25,
                    child: SvgPicture.asset('assets/icons/home.svg', color: AppStyle.primary,  key: Key('1'),)
                ),
                const SizedBox(height: 5),
                const Text(
                  'Home',
                  style: TextStyle(color: AppStyle.primary, fontFamily: 'graphik', fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),

          GestureDetector(
            onTap: (){
              homeController.themeOpenPage.value = true;
            },
            child: Column(
              children: [
                Container(
                    width: 25,
                    height: 25,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: homeController.themeOpenPage.value
                          ? SvgPicture.asset('assets/icons/theme.svg', color: Colors.white, key: Key('0'),)
                          : SvgPicture.asset('assets/icons/theme.svg', color: AppStyle.lightGrey,  key: Key('1'),),
                    )
                ),
                const SizedBox(height: 5),
                Text(
                  'Theme',
                  style: TextStyle(color: homeController.themeOpenPage.value ? Colors.white : Colors.grey, fontFamily: 'graphik', fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}
