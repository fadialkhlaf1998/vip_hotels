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
import 'package:vip_hotels/model/backend_style.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/global.dart';
import 'package:vip_hotels/widget/bottomNavBar.dart';

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
          backgroundColor: BackEndStyle.bgColor,
          body: _portraitWidget(context),
        ),
      );

  }

  _portraitWidget(context){
    return Obx(()=>Stack(
      children: [
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topBar(context),
              SizedBox(height: 10,),
              _categoryList(),
              Expanded(child:_mainObjectPortrait(context),),
              CustomBottomNavBar(
                  height: 55,
                  color: Colors.white,
                  selectIndex: homeController.selectIndexSidebar.value,
                  space: 60
              ),
            ],
          ),
        ),
        logoutConfirm()
      ],
    ));
  }

  _mainObjectPortrait(context){
    return  SizedBox(
        width: Get.width,
        child: Center(
          child: homeController.chooseBrand.value ? _carFilterListPortrait(context) : _carListPortrait(context),
        )
    );
  }

  _carListPortrait(context){
    return SizedBox(
      width: Get.width,
      child: LazyLoadScrollView(
        onEndOfPage: () => homeController.addLazyLoad(),
        child: ListView(
          controller: homeController.scrollController,
          children: [
            SizedBox(height: 20),
            const SizedBox(height: 20),
            homeController.loading.value
                ? SizedBox(
              width: Get.width,
              height: 200,
              child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 6)),
            )
                :
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 4/6,
              ),
              itemCount: homeController.lazyLoad.value,
              itemBuilder: (BuildContext context, index){
                return _carCard(index,context);
              },
            ),
            const SizedBox(height: 10),
            homeController.loading.value?Center():
            _footer(context),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  _carFilterListPortrait(context){
    return SizedBox(
      width: Get.width,
      child: LazyLoadScrollView(
        onEndOfPage: ()=>homeController.addLazyLoadFilter(),
        child: ListView(
          controller: homeController.scrollController,
          children: [
            SizedBox(height: 20),
            // _searchTextField(context),
            // _brandMenu(),
            const SizedBox(height: 20),
            homeController.loading.value
                ? SizedBox(
              width: Get.width,
              height: 200,
              child: const Center(child: CircularProgressIndicator(strokeWidth: 6),),
            )
                :
            homeController.lazyLoadFilter.value == 0
                ? SizedBox(
              width: Get.width,
              height: 200,
              child: Center(
                child: Text("Oops No Cars For This Selection",style: TextStyle(color: BackEndStyle.title_color,fontWeight: FontWeight.bold,fontSize: 15),),
              ),
            )
                :
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 4/6,
              ),
              itemCount: homeController.lazyLoadFilter.value,
              itemBuilder: (BuildContext context, index){
                return _carCardFilter(index);
              },
            ),
            const SizedBox(height: 10),
            homeController.loading.value?Center():
            _footer(context),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
  _footer(BuildContext context){
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = width / 5;
        return GestureDetector(
          onTap: (){
            Global.launchMyUrl('https://wa.me/'+Global.phone);
          },
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(BackEndStyle.footer_image),
                    fit: BoxFit.cover
                )
            ),
          ),
        );
      },
    );
  }
  _categoryList(){
    return Container(
      width: Get.width,
      height: 35,
      margin: EdgeInsets.only(bottom: 10),
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: introController.carCategory.length + 1,
          itemBuilder: (BuildContext context, index){
            return index == 0
                ? GestureDetector(
              onTap: (){
                if(homeController.chooseBrand.value){
                  homeController.chooseCarFilter(homeController.brandIndex.value);
                }else{
                  homeController.selectIndexBottomBar(-1);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 92,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    color: homeController.selectionIndexBottomBar.value == index - 1?BackEndStyle.primary_color
                        :Colors.transparent,
                    border: Border.all(
                        color:
                        homeController.selectionIndexBottomBar.value == index - 1?BackEndStyle.primary_color
                            :BackEndStyle.category_color
                    ),
                    borderRadius: BorderRadius.circular(20)

                ),
                child: Center(
                  child: Text(
                    'All',
                    style: TextStyle(
                        color: homeController.selectionIndexBottomBar.value == index - 1?Colors.white:BackEndStyle.category_color,
                        fontSize: 15,
                        fontFamily: 'graphik',
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
                : GestureDetector(
              onTap: (){
                if(homeController.chooseBrand.value){
                  homeController.chooseCategoryForFilter(index - 1, introController.carCategory[index - 1].id);
                }else{
                  homeController.selectIndexBottomBar(index - 1);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 92,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    color: homeController.selectionIndexBottomBar.value == index - 1?BackEndStyle.primary_color
                        :Colors.transparent,
                    border: Border.all(
                        color:
                        homeController.selectionIndexBottomBar.value == index - 1?BackEndStyle.primary_color
                            :BackEndStyle.category_color
                    ),
                    borderRadius: BorderRadius.circular(20)

                ),
                child: Center(
                  child: Text(
                    introController.carCategory[index - 1].title,
                    style: TextStyle(
                        color: homeController.selectionIndexBottomBar.value == index - 1?Colors.white:BackEndStyle.category_color,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
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
                    fontFamily: 'graphik',
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
                              fontFamily: 'graphik',
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
        width: Get.width,
      decoration: BoxDecoration(

      ),
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: Get.width/4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(BackEndStyle.header_image),
                fit: BoxFit.cover
              ),
            ),
            // child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Container(
            //       width: Get.width,
            //       height: 70,
            //       padding: const EdgeInsets.symmetric(vertical: 10),
            //       child: Image.network(Global.image),
            //     ),
            //   ],
            // ),
          ),
          const SizedBox(height: 10),
          _searchTextField(context),
          _brandMenu(),
        ],
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
            color: BackEndStyle.card_bg_color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BackEndStyle.card_border_color)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius:  BorderRadius.circular(20),
                    color: BackEndStyle.card_border_color
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    fit: BoxFit.cover,
                    introController.allCars[index].image,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          double height = width / 2;
                          return SizedBox(
                            width: width,
                            height: height,
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
                      );
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: introController.allCars[index].carId,
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(introController.allCars[index].brandImage)
                                )
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                introController.allCars[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: BackEndStyle.title_color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          !Global.guest ? 'AED ${introController.allCars[index].price}  ' : 'AED ****  ',
                          // 'AED ${introController.allCars[index].price} / Daily',
                          style: TextStyle(
                              fontSize: 14,
                              color: BackEndStyle.body_color,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "Daily",
                          style: TextStyle(
                              fontSize: 13,
                              color: BackEndStyle.body_color,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.symmetric(vertical: 5,),
                      decoration: BoxDecoration(
                          border: Border.symmetric(
                              horizontal: BorderSide(
                                  color: BackEndStyle.body_color
                              )
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/door_icon.svg",width: 15,color: BackEndStyle.body_color),
                              SizedBox(width: 5,),
                              Text(introController.allCars[index].doors.toString()+" Doors",style: TextStyle(color: BackEndStyle.body_color,fontSize: 12),)
                            ],
                          ),
                          Text("|",style: TextStyle(color: BackEndStyle.body_color),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/seat_icon.svg",width: 15,color: BackEndStyle.body_color),
                              SizedBox(width: 5,),
                              Text(introController.allCars[index].seets.toString()+" Seats",style: TextStyle(color: BackEndStyle.body_color,fontSize: 12),)
                            ],
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
            Flexible(flex: 1,child:
            Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
              child: _carCardButton(index),
            ),
            )
          ],
        ),
      ),
    );
  }

  _carCardButtonFilter(index){
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: (){
                  Get.toNamed('/book', arguments: [homeController.filterCarList[index]]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: BackEndStyle.primary_color,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: const Center(
                    child: Text(
                      'Rent Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: (){

                  if(homeController.filterCarList[index].options.isNotEmpty){
                    Get.toNamed('/carDetails', arguments: [homeController.filterCarList[index]]);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: BackEndStyle.primary_color)
                  ),
                  child: Center(
                    child: Text(
                      'Car Details',
                      style: TextStyle(
                          color: BackEndStyle.primary_color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
            color: BackEndStyle.card_bg_color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BackEndStyle.card_border_color)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius:  BorderRadius.circular(20),
                    color: BackEndStyle.card_border_color
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    fit: BoxFit.cover,
                    homeController.filterCarList[index].image,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          double height = width / 2;
                          return SizedBox(
                            width: width,
                            height: height,
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
                      );
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: homeController.filterCarList[index].carId,
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(homeController.filterCarList[index].brandImage)
                                )
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                homeController.filterCarList[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: BackEndStyle.title_color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          !Global.guest ? 'AED ${homeController.filterCarList[index].price}  ' : 'AED ****  ',
                          // 'AED ${homeController.filterCarList[index].price} / Daily',
                          style: TextStyle(
                              fontSize: 14,
                              color: BackEndStyle.body_color,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "Daily",
                          style: TextStyle(
                              fontSize: 13,
                              color: BackEndStyle.body_color,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.symmetric(vertical: 5,),
                      decoration: BoxDecoration(
                          border: Border.symmetric(
                              horizontal: BorderSide(
                                  color: BackEndStyle.body_color
                              )
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/door_icon.svg",width: 15,color: BackEndStyle.body_color,),
                              SizedBox(width: 5,),
                              Text(homeController.filterCarList[index].doors.toString()+" Doors",style: TextStyle(color: BackEndStyle.body_color,fontSize: 12),)
                            ],
                          ),
                          Text("|",style: TextStyle(color: BackEndStyle.body_color),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/seat_icon.svg",width: 15,color: BackEndStyle.body_color,),
                              SizedBox(width: 5,),
                              Text(homeController.filterCarList[index].seets.toString()+" Seats",style: TextStyle(color: BackEndStyle.body_color,fontSize: 12),)
                            ],
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
            Flexible(flex: 1,child:
            Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
              child: _carCardButtonFilter(index),
            ),
            )
          ],
        ),
      ),
    );
  }
  _carCardButton(index){
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: (){
                  Get.toNamed('/book', arguments: [introController.allCars[index]]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: BackEndStyle.primary_color,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: const Center(
                    child: Text(
                      'Rent Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: (){

                  if(introController.allCars[index].options.isNotEmpty){
                    Get.toNamed('/carDetails', arguments: [introController.allCars[index]]);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: BackEndStyle.primary_color)
                  ),
                  child: Center(
                    child: Text(
                      'Car Details',
                      style: TextStyle(
                          color: BackEndStyle.primary_color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  _searchTextField(context){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      width: Get.width * 0.9,
      height: homeController.searchOpenTextDelegate.value ? 45 : 0,
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
                width: Get.width * 0.9 - 70,
                height: 45,
                decoration: BoxDecoration(
                    color: BackEndStyle.card_bg_color,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                    )
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: (){
                        homeController.onTapSideBar(0);
                      },
                      child: Icon(Icons.close, size: 25,color: BackEndStyle.body_color),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.search, size: 25,color: BackEndStyle.body_color),
                    SizedBox(width: 5),
                    Text(
                      'Find Your Car Now',
                      style: TextStyle(
                          color: BackEndStyle.body_color,
                          fontSize: 14,
                          fontFamily: 'graphik',
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 70,
              height: 45,
              decoration: BoxDecoration(
                  color: BackEndStyle.primary_color,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)
                  )
              ),
              child: const Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'graphik',
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
      width: Get.width,
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
                          ? Icon(Icons.close,color: Colors.black,size: 30)
                          : SvgPicture.asset("assets/icons/filter-Filled.svg", width: 20,color: Colors.black,)
                    )
                  ),
                )
                : GestureDetector(
              onTap: (){
                homeController.chooseCarFilter(index-1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: homeController.brandIndex.value == index - 1 ?
                      BackEndStyle.selected_brand_bg_color : Colors.transparent
                  ),
                  child: Center(
                    child: Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 40),
                      width: 50,
                      height: 50,

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
          childAspectRatio: 2/1
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
              childAspectRatio: 2/1
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
