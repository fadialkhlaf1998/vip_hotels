import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
import 'package:vip_hotels/controller/login_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/global.dart';
import 'package:vip_hotels/widget/bottomNavBar.dart';

class HomeMobile extends StatelessWidget {

  HomeController homeController = Get.put(HomeController());
  DetailsPageController detailsPageController = Get.put(DetailsPageController());

  LoginController loginController = Get.find();
  IntroController introController = Get.find();

  HomeMobile(){
    homeController.initLazyLoad();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light

    ));
    return Obx((){
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
          backgroundColor: Colors.black,
          appBar: AppBar(
            brightness: Brightness.dark,
          ),
          body: SafeArea(
              child: Stack(
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
                  _mainObject(context),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _topBar(context),
                      CustomBottomNavBar(
                          height: Get.height * 0.065,
                          color: Colors.black.withOpacity(0.8),
                          selectIndex: homeController.selectIndexSidebar.value,
                          space: 60
                      ),
                      // _bottomBar()
                    ],
                  ),
                  logoutConfirm()
                ],
              )
          ),
        ),
      );
    });
  }



  _mainObject(context){
    return  Container(
        width: Get.width,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: homeController.chooseBrand.value ? _carFilterList(context) : _carList(context),
          )
        )
    );
  }


  _topBar(context){
    return  Container(
      height: Get.height * 0.08 + 120,
      width: Get.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(width: 40),
              Center(
                  child: Container(
                    width: Get.width * 0.8,
                    height: Get.height * 0.08,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.network(Global.image),
                  )
              ),
              // GestureDetector(
              //   onTap: (){
              //     homeController.logout();
              //   },
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 10),
              //       child: Icon(Icons.logout, size: 20,color: Colors.white)),
              // ),
            ],
          ),
          Container(
            width: Get.width,
            height: 40,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 40,
                      decoration: BoxDecoration(
                        border: homeController.selectionIndexBottomBar.value == -1
                            ? const  Border(
                            bottom: BorderSide(color: AppStyle.primary, width:  2)
                        ) : null,
                      ),
                      child: const Center(
                        child: Text(
                          'All',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'D-DIN-PRO',
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 40,
                      decoration: BoxDecoration(
                          border: homeController.selectionIndexBottomBar.value == index - 1
                              ? const  Border(
                              bottom: BorderSide(color: AppStyle.primary, width:  3)
                          ) : null
                      ),
                      child: Center(
                        child: Text(
                          introController.carCategory[index - 1].title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'D-DIN-PRO',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
      key: const ValueKey(2),
      width: Get.width * 0.95,
      child: LazyLoadScrollView(
        onEndOfPage: () => homeController.addLazyLoad(),
        child: ListView(
          controller: homeController.scrollController,
          children: [
            SizedBox(height: Get.height * 0.08 + 110),
            // Container(
            //   width: Get.width,
            //   height: 40,
            //   child: Center(
            //     child: ListView.builder(
            //       shrinkWrap: true,
            //       scrollDirection: Axis.horizontal,
            //       itemCount: introController.carCategory.length + 1,
            //       itemBuilder: (BuildContext context, index){
            //         return index == 0
            //             ? GestureDetector(
            //           onTap: (){
            //             if(homeController.chooseBrand.value){
            //               homeController.chooseCarFilter(homeController.brandIndex.value);
            //             }else{
            //               homeController.selectIndexBottomBar(-1);
            //             }
            //           },
            //           child: AnimatedContainer(
            //             duration: const Duration(milliseconds: 200),
            //             padding: const EdgeInsets.symmetric(horizontal: 10),
            //             height: 40,
            //             decoration: BoxDecoration(
            //               border: homeController.selectionIndexBottomBar.value == -1
            //                   ? const  Border(
            //                   bottom: BorderSide(color: AppStyle.primary, width:  2)
            //               ) : null,
            //             ),
            //             child: const Center(
            //               child: Text(
            //                 'All',
            //                 style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 15,
            //                     fontFamily: 'D-DIN-PRO',
            //                     fontWeight: FontWeight.bold
            //                 ),
            //               ),
            //             ),
            //           ),
            //         )
            //             : GestureDetector(
            //           onTap: (){
            //             if(homeController.chooseBrand.value){
            //               homeController.chooseCategoryForFilter(index - 1, introController.carCategory[index - 1].id);
            //             }else{
            //               homeController.selectIndexBottomBar(index - 1);
            //             }
            //           },
            //           child: AnimatedContainer(
            //             duration: const Duration(milliseconds: 200),
            //             padding: const EdgeInsets.symmetric(horizontal: 10),
            //             height: 40,
            //             decoration: BoxDecoration(
            //                 border: homeController.selectionIndexBottomBar.value == index - 1
            //                     ? const  Border(
            //                     bottom: BorderSide(color: AppStyle.primary, width:  3)
            //                 ) : null
            //             ),
            //             child: Center(
            //               child: Text(
            //                 introController.carCategory[index - 1].title,
            //                 style: const TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 15,
            //                     fontFamily: 'D-DIN-PRO',
            //                     fontWeight: FontWeight.bold
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10),
            // _searchTextField(context),
            // _brandMenu(),
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
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3/4,
              ),
              itemCount: homeController.lazyLoad.value,
              itemBuilder: (BuildContext context, index){
                return _carCard(index,context);
              },
            ),
            const SizedBox(height: 60)
          ],
        ),
      ),
    );
  }

  _carFilterList(context){
    return SizedBox(
      key: ValueKey(1),
      width: Get.width * 0.95,
      child: LazyLoadScrollView(
        onEndOfPage: ()=>homeController.addLazyLoadFilter(),
        child: ListView(
          controller: homeController.scrollController,
          children: [
            SizedBox(height: Get.height * 0.08 + 110),
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
                    child: Text(
                      "Oops No Cars For This Selection",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13),),
                  ),
            )
                :
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3/4,
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
          Get.toNamed('/CarDetailsMobile', arguments: [homeController.filterCarList[index]]);
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
              flex: 8,
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
                      width: Get.width * 0.08,
                      height: Get.width * 0.08,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(homeController.filterCarList[index].brandImage)
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      homeController.filterCarList[index].title,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                    Text(
                      'AED ${homeController.filterCarList[index].price} / Daily',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppStyle.primary,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
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
          Get.toNamed('/CarDetailsMobile', arguments: [introController.allCars[index]]);
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
              flex: 8,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //       borderRadius: const BorderRadius.only(
                  //         topLeft: Radius.circular(20),
                  //         topRight: Radius.circular(20),
                  //       ),
                  //       image: DecorationImage(
                  //         fit: BoxFit.cover,
                  //         image: NetworkImage(introController.allCars[index].image),
                  //       )
                  //   ),
                  // ),
                  Container(
                    width: Get.width * 0.5,
                    height: Get.width * 0.5,
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
                      width: Get.width * 0.08,
                      height: Get.width * 0.08,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(introController.allCars[index].brandImage)
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      introController.allCars[index].title,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                    Text(
                      'AED ${introController.allCars[index].price} / Daily',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppStyle.primary,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
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
              if(homeController.filterCarList[index].options.isNotEmpty){
                Get.toNamed('/CarDetailsMobile', arguments: [homeController.filterCarList[index]]);
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
                      fontSize: 11
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
              Get.toNamed('/bookMobile', arguments: [homeController.filterCarList[index]]);
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
                      fontSize: 11
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

              if(introController.allCars[index].options.isNotEmpty){
                Get.toNamed('/CarDetailsMobile', arguments: [introController.allCars[index]]);
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
                      fontSize: 11
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
              Get.toNamed('/bookMobile', arguments: [introController.allCars[index]]);
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
                    fontSize: 11,
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
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                    )
                ),
                child: Row(
                  children: const [
                    SizedBox(width: 10),
                    Icon(Icons.search, size: 25,color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Find Your Car Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'D-DIN-PRO',
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
                      fontSize: 15,
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
      width: Get.width * 0.9,
      height: homeController.brandOpenMenu.value ? 60 : 0,
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    color: AppStyle.primary,
                    shape: BoxShape.circle
                ),
                child: const Icon(Icons.filter_list_off),
              ),
            )
                : AnimatedContainer(
              duration: const Duration(milliseconds: 300),

              width: 60,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: homeController.brandIndex.value == index - 1 ?  AppStyle.primary : Colors.grey.withOpacity(0.8)),
                borderRadius: BorderRadius.circular(10),

              ),
                  child: GestureDetector(
              onTap: (){
                  homeController.chooseCarFilter(index - 1);
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(introController.brandList[index - 1].image)
                      )
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
          width: Get.width * 0.8,
          height: homeController.logoutConfirm.value ? Get.height * 0.3 : 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppStyle.grey,
          ),
          child: SingleChildScrollView(
              child: SizedBox(
                height: Get.height * 0.3,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text(
                        'Warning!',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18
                        ),
                      ),
                    ),
                    const Text(
                      'Do you really want to log out?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
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
                            width: Get.width * 0.4,
                            height: 45,
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
                                    fontSize: 15
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
                            width: Get.width * 0.4,
                            height: 45,
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
                                    fontSize: 15,
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


  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   final ThemeData theme = Theme.of(context).copyWith(
  //     textTheme: const TextTheme(
  //       headline6: TextStyle(
  //         color: Colors.black,
  //         fontSize: 18.0,
  //         fontFamily: 'conthrax',
  //       ),
  //     ),
  //   );
  //   return theme;
  // }

  @override
  Widget buildResults(BuildContext context) {
    // introController.searchCarList.clear();
    // introController.searchCarList =
    //     introController.allCars.where((element) =>
    //         element.title.toLowerCase().contains(query)).toList();

    return query.isEmpty
        ? const Center()
        : Container(
        margin: const EdgeInsets.all(5),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 5/2
          ),
          itemCount: introController.searchCarList.length,
          itemBuilder: (BuildContext context, index){
            Car item = introController.searchCarList[index];
            return  GestureDetector(
              onTap: (){
                if(item.options.isNotEmpty){
                  Get.offNamed('/carDetailsMobile', arguments: [item]);
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
                            height: 180,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(item.image)
                                )
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: Get.width * 0.28,
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(
                                //   width: 20,
                                //   height: 20,
                                //   child: Image.network(item.brandImage),
                                // ),
                                Text(
                                    item.title,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                Text('${item.price} AED', style: const  TextStyle(fontSize: 10),),
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

    return query.isEmpty
        ? Center()
        : Container(
        margin: const EdgeInsets.all(5),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 5/2
          ),
          itemCount: introController.searchCarList.length,
          itemBuilder: (BuildContext context, index){
            Car item = introController.searchCarList[index];
            return  GestureDetector(
              onTap: (){
                if(item.options.isNotEmpty){
                  Get.offNamed('/CarDetailsMobile', arguments: [item]);
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
                            height: 180,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(item.image)
                                )
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: Get.width * 0.28,
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(
                                //   width: 40,
                                //   height: 40,
                                //   child: Image.network(item.brandImage),
                                // ),
                                Text(
                                    item.title,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 12,color: Colors.black, fontFamily: 'conthrax')),
                                Text('${item.price} AED', style: const  TextStyle(fontSize: 10, color: Colors.black, fontFamily: 'conthrax'),),
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
