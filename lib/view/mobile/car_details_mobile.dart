import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
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
          backgroundColor: Colors.black,
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
                      height: Get.height * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomLogo(width: 0.4, height: 0.1, tag: 'logo'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                      image: NetworkImage(car.brandImage)
                                  )
                                ),
                              ),
                              const SizedBox(width: 5),
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
                                        fontSize: 17
                                      ),
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Text(
                                        !Global.guest
                                            ? 'AED ${car.price.toString()}  '
                                            : 'AED ****  ',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),

                                      Text("Daily",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),

                                  Text(
                                    'Security Deposit: AED ${car.insurance_price}',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withOpacity(0.7),
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Divider(color: Colors.white.withOpacity(0.8), indent: Get.width * 0.15,endIndent:  Get.width * 0.15, thickness: 1),
                          Column(
                            children: [
                              Container(
                                width: Get.width * 0.7,
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/icons/circle_seats.svg",width: 22,),
                                    SizedBox(width: 5,),
                                    Text(car.seets.toString()+" Seats",style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                height: car.description.length > 10 ? Get.height * 0.13 - 30 : 0,
                                width: Get.width * 0.7,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [


                                      Html(
                                        data: car.description,
                                        style: {
                                          '*' : Style(
                                              color: Colors.white,
                                            fontSize: FontSize(12),
                                            margin: Margins.zero
                                          )
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          car.description.length > 10
                              ? Divider(color: Colors.white.withOpacity(0.8), indent: Get.width * 0.15,endIndent:  Get.width * 0.15, thickness: 1)
                          : Text(''),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  if(detailsPageController.optionId.value == -1){
                                    detailsPageController.optionId.value = car.options.first.id;
                                  }
                                  Get.toNamed('/bookMobile', arguments: [car]);
                                },
                                child: Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: AppStyle.primary,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Book now',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              car.shareLink.isNotEmpty
                              ? GestureDetector(
                                onTap: () async {
                                  if(detailsPageController.optionId.value == -1){
                                    detailsPageController.optionId.value = car.options.first.id;
                                  }
                                  await detailsPageController.shareCar(car.image, car.title, car.shareLink);
                                },
                                child: Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Share',
                                        ),
                                        SizedBox(width: 5),
                                        Icon(Icons.share, color: AppStyle.grey)
                                      ],
                                    ),
                                  )
                                ),
                              )
                              : const Center(),
                            ],
                          ),
                          SizedBox(
                            width: Get.width * 0.8,
                            height: 40,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: car.options.length,
                              itemBuilder: (BuildContext context, index){
                                String color = '0xFF${car.options[index].color.substring(1)}';
                                return GestureDetector(
                                  onTap: (){
                                    detailsPageController.optionId.value = car.options[index].id;
                                    detailsPageController.changeOptionColor(index);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.fastOutSlowIn,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    height: Get.height * 0.09,
                                    decoration: BoxDecoration(
                                        border: detailsPageController.optionIndex.value == index ? Border(
                                            bottom:  BorderSide(
                                              color: Color(int.parse(color)),
                                              width: 2,
                                            )
                                        ) : null
                                    ),
                                    child: Center(
                                      child: Text(
                                        car.options[index].title,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily: 'D-DIN-PRO',
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    _bottomNavBar(),

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
                Row(
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
                  style: TextStyle(color: detailsPageController.openGallery.value ? Colors.white : Colors.grey, fontFamily: 'D-DIN-PRO', fontSize: 13, fontWeight: FontWeight.bold),
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
                  style: TextStyle(color: AppStyle.primary, fontFamily: 'D-DIN-PRO', fontSize: 13, fontWeight: FontWeight.bold),
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
                  style: TextStyle(color: homeController.themeOpenPage.value ? Colors.white : Colors.grey, fontFamily: 'D-DIN-PRO', fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}
