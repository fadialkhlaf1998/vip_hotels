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
                  Row(
                    children: [
                      oriented == Orientation.portrait
                          ? _carDetailsPortrait()
                          : _carDetails(),
                    ],
                  ),
                  /// sideBar and logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height,
                        child: Center(
                          child: CustomSideBarDetailsPage(
                            width: 60,
                            color: Colors.transparent,
                            selectIndex:
                                homeController.selectIndexSidebar.value,
                            space: 40,
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            width: Get.width * 0.35,
                            height: Get.height * 0.2,
                            child: SvgPicture.asset('assets/icons/triangle.svg',
                                fit: BoxFit.contain,
                                alignment: Alignment.topCenter),
                          ),
                          Container(
                            width: Get.width * 0.15,
                            height: Get.height * 0.1,
                            margin: const EdgeInsets.only(top: 5),
                            child: Image.network(Global.image,
                                fit: BoxFit.contain),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60)
                    ],
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
                    right: detailsPageController.optionChangeTimer.value
                        ? -80
                        : 40,
                    curve: Curves.fastOutSlowIn,
                    bottom: 0,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      child: !detailsPageController.optionChangeTimer.value
                          ? Container(
                              margin: EdgeInsets.only(
                                  left: Get.width * 0.3,
                                  bottom: Get.width * 0.1),
                              width: Get.width * 0.55,
                              height: Get.height * 0.35,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          '${Api.url}uploads/${car.options[detailsPageController.optionIndex.value].images.split(',')[0]}'))),
                            )
                          : const Text(''),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(onTap: () {
                      detailsPageController.openGallery.value = true;
                    }, child: Obx(() {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 1400),
                        curve: Curves.fastOutSlowIn,
                        padding: const EdgeInsets.only(bottom: 2),
                        margin: EdgeInsets.only(
                            bottom: Get.height * 0.07, right: 70),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  detailsPageController.changeColor.value
                                      ? AppStyle.primary
                                      : AppStyle.primary.withOpacity(0),
                                  AppStyle.primary.withOpacity(0)
                                ]),
                            border: const Border(
                                bottom: BorderSide(
                                    width: 2, color: AppStyle.primary))),
                        child: const Text(
                          'More Images',
                          style: TextStyle(
                            inherit: true,
                            color: Colors.white,
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    })),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _bottomBar(),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: homeController.themeOpenPage.value
                        ? ThemeCircle()
                        : const Text(''),
                  ),
                  oriented == Orientation.portrait
                      ? CarGalleryPortrait(
                          carImage: car
                              .options[detailsPageController.optionIndex.value]
                              .images)
                      : CarGallery(
                          carImage: car
                              .options[detailsPageController.optionIndex.value]
                              .images),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 0),
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
            height: car.description.length > 10
                ? Get.height * 0.55
                : Get.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: Get.width * 0.4,
                  child: Text(
                    car.title,
                    textAlign: car.description.length > 10
                        ? TextAlign.start
                        : TextAlign.center,
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
                SizedBox(
                  width: Get.width * 0.4,
                  child: Row(
                    children: [
                      Text(
                        !Global.guest
                            ? 'AED ${car.price.toString()}  '
                            : 'AED ****  ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),

                      Text("Daily",
                        style: const TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Text(
                  'Security Deposit: AED ${car.insurance_price}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.5,
                  child:   Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (detailsPageController.optionId.value == -1) {
                            detailsPageController.optionId.value =
                                car.options.first.id;
                          }
                          Get.toNamed('/book', arguments: [car]);
                        },
                        child: Container(
                          width: Get.width * 0.16,
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
                      const SizedBox(height: 15),
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
                            width: Get.width * 0.16,
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
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Share',
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.share,
                                      color: AppStyle.grey)
                                ],
                              ),
                            )),
                      )
                          : const Center(),
                    ],
                  ),
                )
              ],
            ),
          ),
          CustomLogo(width: 0.15, height: 0.09, tag: 'tag'),
          SizedBox(height: Get.height * 0.05),
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
                        fontFamily: 'D-DIN-PRO',
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
