import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
import 'package:vip_hotels/controller/login_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/global.dart';

import 'package:vip_hotels/widget/custom_sideBar.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {

  HomeController homeController = Get.put(HomeController());
  DetailsPageController detailsPageController = Get.put(DetailsPageController());
  LoginController loginController = Get.find();
  IntroController introController = Get.find();

  Home({super.key}){
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      homeController.initLazyLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light

    ));
    return WillPopScope(
        onWillPop: () async {
          if(homeController.themeOpenPage.value){
            homeController.themeOpenPage.value = false;
            homeController.selectIndexSidebar.value = -1;
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: SafeArea(
              child: OrientationBuilder(
                builder: (context, orientation){
                  return orientation == Orientation.portrait
                      ? Obx((){
                        return _portraitWidget(context);
                  })
                      : Obx((){
                        return  Stack(
                          children: [
                            // BackgroundImage(),
                            Container(
                              width: Get.width,
                              height: Get.height,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/images/homeBackground.jpg')
                                  )
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 10),
                                CustomSideBar(
                                  width: 60,
                                  color: Colors.transparent,
                                  selectIndex: homeController.selectIndexSidebar.value,
                                  space: 40,
                                ),
                                const VerticalDivider(color: AppStyle.lightGrey,indent: 100,endIndent: 100,width: 10,thickness: 1.5),
                                _mainObject(context),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _topBar(context),
                                _bottomBar()
                              ],
                            ),
                            logoutConfirm()

                          ],
                        );
                  });
                },
              )
          ),
        ),
      );

  }

  _portraitWidget(context){
    return Stack(
      children: [
        Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/homeBackground.jpg')
              )
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            CustomSideBar(
              width: 60,
              color: Colors.transparent,
              selectIndex: homeController.selectIndexSidebar.value,
              space: 40,
            ),
            const VerticalDivider(color: AppStyle.lightGrey,indent: 100,endIndent: 100,width: 10,thickness: 1.5),
            _mainObjectPortrait(context),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _topBar(context),
            _bottomBar()
          ],
        ),
        logoutConfirm()
      ],
    );
  }

  _mainObject(context){
    return  SizedBox(
      width: Get.width - 80,
      child: Center(
        child: homeController.chooseBrand.value ? _carFilterList(context) : _carList(context),
      )
    );
  }

  _mainObjectPortrait(context){
    return  SizedBox(
        width: Get.width - 80,
        child: Center(
          child: homeController.chooseBrand.value ? _carFilterListPortrait(context) : _carListPortrait(context),
        )
    );
  }

  _carListPortrait(context){
    return SizedBox(
      width: Get.width - 120,
      child: LazyLoadScrollView(
        onEndOfPage: () => homeController.addLazyLoad(),
        child: ListView(
          controller: homeController.scrollController,
          children: [
            SizedBox(height: Get.height * 0.1 + 100),
            const SizedBox(height: 20),
            homeController.loading.value
                ? SizedBox(
              width: Get.width - 120,
              height: 200,
              child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 6)),
            )
                :
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3/3,
              ),
              itemCount: homeController.lazyLoad.value,
              itemBuilder: (BuildContext context, index){
                return _carCardPortrait(index,context);
              },
            ),
            SizedBox(height: Get.height * 0.11)
          ],
        ),
      ),
    );
  }

  _carFilterListPortrait(context){
    return SizedBox(
      width: Get.width - 120,
      child: LazyLoadScrollView(
        onEndOfPage: ()=>homeController.addLazyLoadFilter(),
        child: ListView(
          controller: homeController.scrollController,
          children: [
            SizedBox(height: Get.height * 0.1 + 100),
            // _searchTextField(context),
            // _brandMenu(),
            const SizedBox(height: 20),
            homeController.loading.value
                ? SizedBox(
              width: Get.width - 120,
              height: 200,
              child: const Center(child: CircularProgressIndicator(strokeWidth: 6),),
            )
                :
            homeController.lazyLoadFilter.value == 0
                ? SizedBox(
              width: Get.width - 120,
              height: 200,
              child: const Center(
                child: Text("Oops No Cars For This Selection",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
              ),
            )
                :
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3/3,
              ),
              itemCount: homeController.lazyLoadFilter.value,
              itemBuilder: (BuildContext context, index){
                return _carCardFilterPortrait(index);
              },
            ),
            SizedBox(height: Get.height * 0.11)
          ],
        ),
      ),
    );
  }

  _carCardFilterPortrait(index){
    return GestureDetector(
      onTap: (){
        if(homeController.filterCarList[index].options.isNotEmpty){
          Get.toNamed('/carDetails', arguments: [homeController.filterCarList[index]]);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppStyle.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(homeController.filterCarList[index].image),
                        )
                    ),
                  ),
                  Hero(
                    tag: homeController.filterCarList[index].carId,
                    child: Container(
                      width: Get.width * 0.04,
                      height: Get.width * 0.04,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(homeController.filterCarList[index].brandImage)
                          )
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/circle_seats.svg",width: 20,),
                      SizedBox(width: 5,),
                      Text(homeController.filterCarList[index].seets.toString()+" Seats",style: TextStyle(color: Colors.white,fontSize: 10),)
                    ],
                  ),)
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      homeController.filterCarList[index].title,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),

                    ),

                    Row(
                      children: [
                        Text(
                          !Global.guest ? 'AED ${introController.allCars[index].price}  ' : 'AED ****  ',
                          // 'AED ${introController.allCars[index].price} / Daily',
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppStyle.primary,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                         Text(
                          "Daily",
                          style:  TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),

                    Text(
                      'Security Deposit: AED ${homeController.filterCarList[index].insurance_price}',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.7),
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                ),
                child: _carCardButtonFilterPortrait(index),
              ),
            )
          ],
        ),
      ),
    );
  }

  _carCardPortrait(index,BuildContext context){
    return GestureDetector(
      onTap: (){
        if(introController.allCars[index].options.isNotEmpty){
          Get.toNamed('/carDetails', arguments: [introController.allCars[index]]);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppStyle.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex:4,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    width: Get.width * 0.3,
                    height: Get.width * 0.3,
                    decoration: const BoxDecoration(
                      borderRadius:  BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        fit: BoxFit.cover,
                        introController.allCars[index].image,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: Get.width * 0.3,
                            height: Get.width * 0.3,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Hero(
                    tag: introController.allCars[index].carId,
                    child: Container(
                      width: Get.width * 0.04,
                      height: Get.width * 0.04,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(introController.allCars[index].brandImage),

                          )
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/circle_seats.svg",width: 20,),
                        SizedBox(width: 5,),
                        Text(introController.allCars[index].seets.toString()+" Seats",style: TextStyle(color: Colors.white,fontSize: 10),)
                      ],
                    ),)
                ],
              ),
            ),
            Flexible(
                flex: 3,
                child: OrientationBuilder(
                  builder: (context, orientation){
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            introController.allCars[index].title,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontStyle: FontStyle.italic
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                !Global.guest ? 'AED ${introController.allCars[index].price}  ' : 'AED ****  ',
                                // 'AED ${introController.allCars[index].price} / Daily',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppStyle.primary,
                                    fontStyle: FontStyle.italic
                                ),
                              ),
                              Text(
                                "Daily",
                                style:  TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontStyle: FontStyle.italic
                                ),
                              ),
                            ],
                          ),

                          Text(
                            'Security Deposit: AED ${introController.allCars[index].insurance_price}',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7),
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                ),
                child: _carCardButtonPortrait(index),
              ),
            )
          ],
        ),
      ),
    );
  }

  _bottomBar(){

    return Container(
      height: 50,
      width: Get.width,
      decoration:  BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.9)
              ]
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // CustomLogo(width: 0.18, height: 0.07, tag: 'tag'),
          GestureDetector(
            onTap: (){
              if(homeController.chooseBrand.value){
                homeController.chooseCarFilter(homeController.brandIndex.value);
              }else{
                homeController.selectIndexBottomBar(-1);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: Get.height * 0.09,
              decoration: BoxDecoration(
                border: homeController.selectionIndexBottomBar.value == -1
                    ? const  Border(
                    bottom: BorderSide(color: AppStyle.primary, width:  3)
                ) : null,
              ),
              child: const Center(
                child: Text(
                  'All',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    fontFamily: 'D-DIN-PRO',
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          SizedBox(
            height: Get.height * 0.09,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: introController.carCategory.length,
              itemBuilder: (BuildContext context, index){
                return GestureDetector(
                  onTap: (){
                    if(homeController.chooseBrand.value){
                      homeController.chooseCategoryForFilter(index, introController.carCategory[index].id);
                    }else{
                      homeController.selectIndexBottomBar(index);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    height: Get.height * 0.09,
                    decoration: BoxDecoration(
                      border: homeController.selectionIndexBottomBar.value == index
                          ? const  Border(
                            bottom: BorderSide(color: AppStyle.primary, width:  3)
                          ) : null
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          introController.carCategory[index].title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'D-DIN-PRO',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 60,
                          height: 40,
                          child: SvgPicture.network(introController.carCategory[index].image, color: AppStyle.primary),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _topBar(context){
    return  Container(
        height: Get.height * 0.1 + 100,
        width: Get.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.black.withOpacity(0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: Get.width,
              height: Get.height * 0.1,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.network(Global.image),
            )
          ),
          const SizedBox(height: 10),
          _searchTextField(context),
          _brandMenu(),
        ],
      ),
    );
  }

  _carList(context){
    return SizedBox(
      width: Get.width - 120,
      child: LazyLoadScrollView(
        onEndOfPage: () => homeController.addLazyLoad(),
        child: ListView(
          controller: homeController.scrollController,
          children: [
            SizedBox(height: Get.height * 0.1 + 100),
            const SizedBox(height: 20),
            homeController.loading.value
                ? SizedBox(
                  width: Get.width - 120,
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 6)),
            )
                :
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 3/3,
              ),
              itemCount: homeController.lazyLoad.value,
              itemBuilder: (BuildContext context, index){
                return _carCard(index,context);
              },
            ),
            SizedBox(height: Get.height * 0.11)
          ],
        ),
      ),
    );
  }

  _carFilterList(context){
    return SizedBox(
      width: Get.width - 120,
      child: LazyLoadScrollView(
        onEndOfPage: ()=>homeController.addLazyLoadFilter(),
        child: ListView(
          controller: homeController.scrollController,
          children: [
            SizedBox(height: Get.height * 0.1 + 100),
            // _searchTextField(context),
            // _brandMenu(),
            const SizedBox(height: 20),
            homeController.loading.value
                    ? SizedBox(
                  width: Get.width - 120,
                    height: 200,
                       child: const Center(child: CircularProgressIndicator(strokeWidth: 6),),
                 )
                :
            homeController.lazyLoadFilter.value == 0
                ? SizedBox(
                      width: Get.width - 120,
                      height: 200,
                      child: const Center(
                        child: Text("Oops No Cars For This Selection",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
              ),
            )
                :
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 3/3,
              ),
              itemCount: homeController.lazyLoadFilter.value,
              itemBuilder: (BuildContext context, index){
                return _carCardFilter(index);
              },
            ),
            SizedBox(height: Get.height * 0.11)
          ],
        ),
      ),
    );
  }

  _carCardFilter(index){
    return GestureDetector(
      onTap: (){
        if(homeController.filterCarList[index].options.isNotEmpty){
          Get.toNamed('/carDetails', arguments: [homeController.filterCarList[index]]);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppStyle.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(homeController.filterCarList[index].image),
                        )
                    ),
                  ),
                  Hero(
                    tag: homeController.filterCarList[index].carId,
                    child: Container(
                      width: Get.width * 0.04,
                      height: Get.width * 0.04,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(homeController.filterCarList[index].brandImage)
                          )
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/circle_seats.svg",width: 22,),
                        SizedBox(width: 5,),
                        Text(homeController.filterCarList[index].seets.toString()+" Seats",style: TextStyle(color: Colors.white),)
                      ],
                    ),)
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      homeController.filterCarList[index].title,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),

                    ),


                    Row(
                      children: [
                        Text(
                          !Global.guest ? 'AED ${introController.allCars[index].price}  ' : 'AED ****  ',
                          // 'AED ${introController.allCars[index].price} / Daily',
                          style: const TextStyle(
                              fontSize: 18,
                              color: AppStyle.primary,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                         Text(
                          "Daily",
                          style:  TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Security Deposit: AED ${homeController.filterCarList[index].insurance_price}',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.7),
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                ),
                child: _carCardButtonFilter(index),
              ),
            )
          ],
        ),
      ),
    );
  }

  _carCard(index,BuildContext context){
    return GestureDetector(
      onTap: (){
        if(introController.allCars[index].options.isNotEmpty){
          Get.toNamed('/carDetails', arguments: [introController.allCars[index]]);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppStyle.grey.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex:4,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    width: Get.width * 0.3,
                    height: Get.width * 0.3,
                    decoration: const BoxDecoration(
                      borderRadius:  BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        fit: BoxFit.cover,
                        introController.allCars[index].image,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: Get.width * 0.3,
                            height: Get.width * 0.3,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Hero(
                    tag: introController.allCars[index].carId,
                    child: Container(
                      width: Get.width * 0.04,
                      height: Get.width * 0.04,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(introController.allCars[index].brandImage),
                          )
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/circle_seats.svg",width: 22,),
                      SizedBox(width: 5,),
                      Text(introController.allCars[index].seets.toString()+" Seats",style: TextStyle(color: Colors.white),)
                    ],
                  ),)
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: OrientationBuilder(
                builder: (context, orientation){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          introController.allCars[index].title,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 21,
                              color: Colors.white,
                              fontStyle: FontStyle.italic
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              !Global.guest ? 'AED ${introController.allCars[index].price}  ' : 'AED ****  ',
                              // 'AED ${introController.allCars[index].price} / Daily',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: AppStyle.primary,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                             Text(
                              "Daily",
                              style:  TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.7),
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Security Deposit: AED ${introController.allCars[index].insurance_price}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                ),
                child: _carCardButton(index),
              ),
            )
          ],
        ),
      ),
    );
  }

  _carCardButtonFilter(index){
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              homeController.searchOpenTextDelegate.value = false;
              homeController.brandOpenMenu.value = true;
              homeController.selectIndexSidebar.value = -1;
              if(homeController.filterCarList[index].options.isNotEmpty){
                Get.toNamed('/carDetails', arguments: [homeController.filterCarList[index]]);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: homeController.filterCarList[index].options.isNotEmpty ? Colors.white : Colors.grey,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  )
              ),
              child: Center(
                child: Text(
                  'Car Details',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: homeController.filterCarList[index].options.isNotEmpty ? Colors.black : Colors.white.withOpacity(0.5),
                      fontSize: 18
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              homeController.searchOpenTextDelegate.value = false;
              homeController.brandOpenMenu.value = true;
              homeController.selectIndexSidebar.value = -1;
              Get.toNamed('/book', arguments: [homeController.filterCarList[index]]);
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: AppStyle.primary,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20)
                  )
              ),
              child: const Center(
                child: Text(
                  'Rent Now',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _carCardButtonFilterPortrait(index){
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              homeController.searchOpenTextDelegate.value = false;
              homeController.brandOpenMenu.value = true;
              homeController.selectIndexSidebar.value = -1;
              if(homeController.filterCarList[index].options.isNotEmpty){
                Get.toNamed('/carDetails', arguments: [homeController.filterCarList[index]]);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: homeController.filterCarList[index].options.isNotEmpty ? Colors.white : Colors.grey,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  )
              ),
              child: Center(
                child: Text(
                  'Car Details',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: homeController.filterCarList[index].options.isNotEmpty ? Colors.black : Colors.white.withOpacity(0.5),
                      fontSize: 13
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              homeController.searchOpenTextDelegate.value = false;
              homeController.brandOpenMenu.value = true;
              homeController.selectIndexSidebar.value = -1;
              Get.toNamed('/book', arguments: [homeController.filterCarList[index]]);
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: AppStyle.primary,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20)
                  )
              ),
              child: const Center(
                child: Text(
                  'Rent Now',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontSize: 13
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _carCardButtonPortrait(index){
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              homeController.searchOpenTextDelegate.value = false;
              homeController.brandOpenMenu.value = true;
              homeController.selectIndexSidebar.value = -1;
              if(introController.allCars[index].options.isNotEmpty){
                Get.toNamed('/carDetails', arguments: [introController.allCars[index]]);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: introController.allCars[index].options.isNotEmpty ? Colors.white : Colors.grey,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  )
              ),
              child: Center(
                child: Text(
                  'Car Details',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: introController.allCars[index].options.isNotEmpty ? Colors.black : Colors.white.withOpacity(0.5),
                      fontSize: 13
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              homeController.searchOpenTextDelegate.value = false;
              homeController.brandOpenMenu.value = true;
              homeController.selectIndexSidebar.value = -1;
              Get.toNamed('/book', arguments: [introController.allCars[index]]);
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: AppStyle.primary,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20)
                  )
              ),
              child: const Center(
                child: Text(
                  'Rent Now',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    fontSize: 13,
                    // shadows: [
                    //   Shadow(color: Colors.black,blurRadius: 1)
                    // ]
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _carCardButton(index){
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              homeController.searchOpenTextDelegate.value = false;
              homeController.brandOpenMenu.value = true;
              homeController.selectIndexSidebar.value = -1;
              if(introController.allCars[index].options.isNotEmpty){
                Get.toNamed('/carDetails', arguments: [introController.allCars[index]]);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: introController.allCars[index].options.isNotEmpty ? Colors.white : Colors.grey,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                  )
              ),
              child: Center(
                child: Text(
                    'Car Details',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: introController.allCars[index].options.isNotEmpty ? Colors.black : Colors.white.withOpacity(0.5),
                    fontSize: 18
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              homeController.searchOpenTextDelegate.value = false;
              homeController.brandOpenMenu.value = true;
              homeController.selectIndexSidebar.value = -1;
              Get.toNamed('/book', arguments: [introController.allCars[index]]);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: AppStyle.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20)
                )
              ),
              child: const Center(
                child: Text(
                  'Rent Now',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontSize: 18,
                    // shadows: [
                    //   Shadow(color: Colors.black,blurRadius: 1)
                    // ]
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _searchTextField(context){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      width: Get.width - 120,
      height: homeController.searchOpenTextDelegate.value ? 80 : 0,
      child:  SingleChildScrollView(
        child: Row(
          children: [
          GestureDetector(
            onTap: (){
              showSearch(
                context: context,
                delegate: CustomSearchClass(),
              );
            },
            child:   Container(
              width: Get.width - 300,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                  )
              ),
              // child: Center(
              //   child: TextField(
              //     onChanged: (value) {
              //       // homeController.filterSearchResults(value);
              //     },
              //     decoration: const InputDecoration(
              //         border: InputBorder.none,
              //         focusedBorder: InputBorder.none,
              //         enabledBorder: InputBorder.none,
              //         errorBorder: InputBorder.none,
              //       disabledBorder: InputBorder.none,
              //       hintText: 'Find Your Car Now',
              //       contentPadding:
              //       EdgeInsets.only(left: 30),
              //     ),
              //    ),
              // ),
              child: Row(
                children:  [
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: (){
                      homeController.onTapSideBar(0);
                    },
                    child: Icon(Icons.close, size: 40,color: Colors.white),
                  ),
                  SizedBox(width: 7),
                  Icon(Icons.search, size: 40,color: Colors.white),
                  SizedBox(width: 7),
                  Text(
                    'Find Your Car Now',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'D-DIN-PRO',
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
          ),
            Container(
              width: 170,
              height: 60,
              decoration: const BoxDecoration(
                color: AppStyle.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)
                )
              ),
              child: const Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'D-DIN-PRO',
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _brandMenu(){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      width: Get.width - 120,
      height: homeController.brandOpenMenu.value ? 80 : 0,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: introController.brandList.length + 1,
          itemBuilder: (BuildContext context, index){
            return index == 0
                ? GestureDetector(
                    onTap: (){
                      homeController.clearFilter();

                    },
              child: Container(
                margin: const EdgeInsets.only(left: 25,right: 10),
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: homeController.brandIndex.value!= -1
                          ? Icon(Icons.close,color: AppStyle.primary,size: 40)
                          : SvgPicture.asset("assets/icons/filter-Filled.svg", width: 25,color: AppStyle.primary,)
                    )
                  ),
                )
                : GestureDetector(
              onTap: (){
                homeController.chooseCarFilter(index-1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  width: 80,
                  decoration: BoxDecoration(
                      border: Border.all(color: homeController.brandIndex.value == index-1?AppStyle.primary:AppStyle.grey),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 40),
                      width: 80,
                      height: 60,

                      decoration: BoxDecoration(

                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(introController.brandList[index - 1].image)
                          )
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  logoutConfirm(){
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
            child: homeController.logoutConfirm.value
              ? Container(
            width: Get.width,
            height: Get.height,
            color: Colors.black.withOpacity(0.6),
          ) : const Text('')
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn,
          width: Get.width * 0.5,
          height: homeController.logoutConfirm.value ? Get.height * 0.4 : 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppStyle.grey,
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height * 0.4,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Warning!',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 24
                      ),
                    ),
                  ),
                  const Text(
                    'Do you really want to log out?',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          homeController.logoutConfirm.value = false;
                        },
                        child: Container(
                          width: Get.width * 0.25,
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20)
                              )
                          ),
                          child: const Center(
                            child: Text(
                                'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          homeController.logout();
                        },
                        child: Container(
                          width: Get.width * 0.25,
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20)
                              )
                          ),
                          child: const Center(
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ),
        ),
      ],
    );
  }


}

class CustomSearchClass extends SearchDelegate {

  IntroController introController = Get.find();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    introController.searchCarList.clear();
    introController.searchCarList =
        introController.allCars.where((element) =>
            element.title.toLowerCase().contains(query)).toList();

    return query.isEmpty ? const Center():Container(
      margin: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3/1
        ),
        itemCount: introController.searchCarList.length,
        itemBuilder: (BuildContext context, index){
          Car item = introController.searchCarList[index];
          return  GestureDetector(
            onTap: (){
              if(item.options.isNotEmpty){
                Get.offNamed('/carDetails', arguments: [item]);
              }
            },
            child: Card(
                color: Colors.white,
                child:Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.14,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(item.image)
                              )
                          ),
                        ),
                        const SizedBox(width: 15),
                       SizedBox(
                         width: Get.width * 0.28,
                         child:  Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SizedBox(
                               width: 40,
                               height: 40,
                               child: Image.network(item.brandImage),
                             ),
                             Text(
                                 item.title,
                                 maxLines: 2,
                                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                             Text('${item.price} AED'),
                           ],
                         ),
                       )
                      ],
                    )
                )
            ),
          );
        },
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    introController.searchCarList.clear();
    introController.searchCarList =
        introController.allCars.where((element) =>
            element.title.toLowerCase().contains(query)).toList();

    return query.isEmpty? const Center():Container(
        margin: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3/1
          ),
          itemCount: introController.searchCarList.length,
          itemBuilder: (BuildContext context, index){
            Car item = introController.searchCarList[index];
            return  GestureDetector(
              onTap: (){
                if(item.options.isNotEmpty){
                  Get.offNamed('/carDetails', arguments: [item]);
                }
              },
              child: Card(
                  color: Colors.white,
                  child:Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: Get.width * 0.14,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(item.image)
                                )
                            ),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(
                            width: Get.width * 0.28,
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.network(item.brandImage),
                                ),
                                Text(
                                    item.title,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('${item.price} AED'),
                              ],
                            ),
                          )
                        ],
                      )
                  )
              ),
            );
          },
        )
    );
  }

}
