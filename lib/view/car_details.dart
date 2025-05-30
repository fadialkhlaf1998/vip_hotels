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
import 'package:vip_hotels/widget/car_gallery.dart';
import 'package:vip_hotels/widget/car_gallery_portriat.dart';
import 'package:vip_hotels/widget/custom_logo.dart';
import 'package:vip_hotels/widget/custom_sidebar_details_page.dart';
import 'package:vip_hotels/widget/theme_circle.dart';

// ignore: must_be_immutable
class CarDetails extends StatelessWidget {
  HomeController homeController = Get.find();
  DetailsPageController detailsPageController = Get.find();

  Car car = Get.arguments[0];

  CarDetails({super.key}) {
    detailsPageController.mainCarImageIndex.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    detailsPageController.optionIndex.value = 0;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light));
    return WillPopScope(
      onWillPop: () async {
        if (homeController.themeOpenPage.value ||
            detailsPageController.openGallery.value) {
          homeController.themeOpenPage.value = false;
          homeController.selectIndexSidebar.value = -1;
          detailsPageController.openGallery.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SafeArea(child: OrientationBuilder(
          builder: (context, oriented) {
            return Obx(() {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  BackgroundImage(),
                  /// car details
                  _carDetailsPortrait(),
                  /// sideBar and logo
                  Positioned(
                    top: 0,
                    child: Container(
                      width: Get.width,
                      height: Get.width / 5,
                      child: Image.network(BackEndStyle.inner_image,
                          fit: BoxFit.cover),
                    ),
                  ),
                  /// Car Image
                  Positioned(
                    left: 50,
                    top: 20,
                    child: GestureDetector(
                      onTap: () {
                        homeController.selectIndexSidebar.value = -1;
                        Get.back();
                      },
                      child: const SizedBox(
                        child: Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 35),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 700),
                    right: 0,
                    curve: Curves.fastOutSlowIn,
                    bottom: 0,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      child: !detailsPageController.optionChangeTimer.value
                          ? Container(

                              width: Get.width ,
                              height: Get.height * 0.35,

                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          '${Api.url}uploads/${car.options[detailsPageController.optionIndex.value].images.split(',')[0]}'),
                                        fit: BoxFit.contain
                                  )
                              ),

                            )
                          : const Text(''),
                    ),
                  ),



                  CarGalleryPortrait(
                      carImage: car
                          .options[detailsPageController.optionIndex.value]
                          .images)
                ],
              );
            });
          },
        )),
      ),
    );
  }

  _carDetailsPortrait() {
    return Container(
      // padding: const EdgeInsets.only(left: 100),
      width: Get.width,
      height: 600,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.black.withOpacity(0.25),
          ],
        ),
        borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.width / 5 + 20),
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Hero(
                      tag: car.carId,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: BackEndStyle.card_bg_color.withOpacity(0.5),
                            shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(car.brandImage)
                                )
                            ),
                          ),
                        ),
                      ),

                    ),
                    SizedBox(width: 20 ,),
                    SizedBox(
                      child: Text(
                        car.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30 ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Get.width*0.1,vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/door_icon.svg",width: 20,color: Colors.white,),
                            SizedBox(width: 5,),
                            Text(car.doors.toString()+" Doors",style: TextStyle(color: Colors.white,fontSize: 17),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 40,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Get.width*0.1,vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/seat_icon.svg",width: 20,color: Colors.white),
                            SizedBox(width: 5,),
                            Text(car.seets.toString()+" Seats",style: TextStyle(color: Colors.white,fontSize: 17),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30 ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text("Price",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          !Global.guest
                              ? 'AED ${car.price.toString()}  '
                              : 'AED ****  ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),

                        Text("Daily",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(width: 10,),
                    Row(
                      children: [
                        Text(
                          'Security Deposit: AED ${car.insurance_price}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 30 ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(detailsPageController.optionId.value == -1){
                          detailsPageController.optionId.value = car.options.first.id;
                        }
                        Get.toNamed('/book', arguments: [car]);
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: BackEndStyle.primary_color,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: const Center(
                          child: Text(
                            'Book now',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 15 ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        detailsPageController.openGallery.value = true;
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white)
                        ),
                        child: const Center(
                          child: Text(
                            'Mora Images',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _carDetails() {
    return Container(
      padding: const EdgeInsets.only(left: 100),
      width: Get.width * 0.5,
      height: Get.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.black.withOpacity(0.25),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Hero(
            tag: car.carId,
            child: Container(
              width: Get.width * 0.05,
              height: Get.width * 0.05,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(car.brandImage))),
            ),
          ),
          SizedBox(
            width: Get.width * 0.4,
            child: Text(
              car.title,
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(
            height: car.description.length > 10 ? Get.height * 0.2 : 0,
            width: Get.width * 0.4,
            child: SingleChildScrollView(
              child: Html(
                data: car.description,
                style: {'*': Style(color: Colors.white)},
              ),
            ),
          ),
          SizedBox(
            width: Get.width * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/circle_seats.svg",width: 22,),
                    SizedBox(width: 5,),
                    Text(car.seets.toString()+" Seats",style: TextStyle(color: Colors.white),)
                  ],
                ),
                // _customIcon('person', car.seets.toString()),
                // _customIcon('calendar', car.year.toString()),
                // _customIcon('doors', car.doors.toString()),
              ],
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
                    fontSize: 31,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),

              Text("Daily",
                style: const TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Text(
            'Security Deposit: AED ${car.insurance_price}',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(0.7),
                fontStyle: FontStyle.italic
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (detailsPageController.optionId.value == -1) {
                    detailsPageController.optionId.value = car.options.first.id;
                  }
                  Get.toNamed('/book', arguments: [car]);
                },
                child: Container(
                  width: Get.width * 0.15,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppStyle.primary,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                    child: Text(
                      'Book now',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              car.shareLink.isNotEmpty
                  ? GestureDetector(
                      onTap: () async {
                        if (detailsPageController.optionId.value == -1) {
                          detailsPageController.optionId.value =
                              car.options.first.id;
                        }
                        await detailsPageController.shareCar(
                            car.image, car.title, car.shareLink);
                      },
                      child: Container(
                          width: Get.width * 0.15,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: detailsPageController.loading.value
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: const LinearProgressIndicator(
                                      color: Colors.black,
                                      backgroundColor: Colors.grey,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Share',
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.share, color: AppStyle.grey)
                                    ],
                                  ),
                          )),
                    )
                  : const Center(),
            ],
          ),
          // GestureDetector(
          //   onTap: (){
          //     if(detailsPageController.optionId.value == -1){
          //       detailsPageController.optionId.value = car.options.first.id;
          //     }
          //     Get.toNamed('/book', arguments: [car]);
          //   },
          //   child: Container(
          //     width: Get.width * 0.12,
          //     height: Get.height * 0.05,
          //     decoration: BoxDecoration(
          //         color: AppStyle.primary,
          //         borderRadius: BorderRadius.circular(5)
          //     ),
          //     child: const Center(
          //       child: Text(
          //         'Book now',
          //         style: TextStyle(
          //           fontSize: 17,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          CustomLogo(width: 0.15, height: 0.09, tag: 'tag'),
          SizedBox(height: Get.height * 0.05),
        ],
      ),
    );
  }

  _customIcon(String icon, String data) {
    return Row(
      children: [
        SvgPicture.asset('assets/icons/$icon.svg',
            color: AppStyle.primary, width: 20, height: 20, fit: BoxFit.cover),
        const SizedBox(width: 10),
        Text(
          data,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        )
      ],
    );
  }

  _bottomBar() {
    return Container(
      height: Get.height * 0.07,
      width: Get.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.1)
          ])),
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: car.options.length,
          itemBuilder: (BuildContext context, index) {
            String color = '0xFF${car.options[index].color.substring(1)}';
            return GestureDetector(
              onTap: () {
                detailsPageController.optionId.value = car.options[index].id;
                detailsPageController.changeOptionColor(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                height: Get.height * 0.09,
                decoration: BoxDecoration(
                    border: detailsPageController.optionIndex.value == index
                        ? Border(
                            bottom: BorderSide(
                            color: Color(int.parse(color)),
                            width: 3,
                          ))
                        : null),
                child: Center(
                  child: Text(
                    car.options[index].title,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontFamily: 'graphik',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
