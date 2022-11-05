import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
import 'package:vip_hotels/controller/login_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/global.dart';
import 'package:vip_hotels/widget/bottomNavBar.dart';
import 'package:vip_hotels/widget/theme_circle.dart';

class HomeMobile extends StatelessWidget {

  HomeController homeController = Get.put(HomeController());
  DetailsPageController detailsPageController = Get.put(DetailsPageController());
  LoginController loginController = Get.find();
  IntroController introController = Get.find();

  @override
  Widget build(BuildContext context) {
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
                      _topBar(),
                      CustomBottomNavBar(
                          height: 50,
                          color: Colors.black.withOpacity(0.8),
                          selectIndex: homeController.selectIndexSidebar.value,
                          space: 60
                      ),
                      // _bottomBar()
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: homeController.themeOpenPage.value ? ThemeCircle() : const Text(''),
                  ),
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
          child: homeController.loading.value
              ? const CircularProgressIndicator(strokeWidth: 6)
              : AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: homeController.chooseBrand.value ? _carFilterList(context) : _carList(context),
          )
        )
    );
  }


  _topBar(){
    return  Container(
      height: Get.height * 0.1,
      width: Get.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.network(Global.image),
              )
          ),
          GestureDetector(
            onTap: (){
              homeController.logout();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.logout, size: 20,color: Colors.white)),
          ),
        ],
      ),
    );
  }

  _carList(context){
    return SizedBox(
      key: ValueKey(2),
      width: Get.width * 0.9,
      child: ListView(
        controller: homeController.scrollController,
        children: [
          SizedBox(height: Get.height * 0.11),
          _searchTextField(context),
          _brandMenu(),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3/4,
            ),
            itemCount: introController.allCars.length,
            itemBuilder: (BuildContext context, index){
              return _carCard(index,context);
            },
          ),
          const SizedBox(height: 60)
        ],
      ),
    );
  }

  _carFilterList(context){
    return SizedBox(
      key: ValueKey(1),
      width: Get.width * 0.9,
      child: ListView(
        controller: homeController.scrollController,
        children: [
          SizedBox(height: Get.height * 0.11),
          _searchTextField(context),
          _brandMenu(),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3/4,
            ),
            itemCount: homeController.filterCarList.length,
            itemBuilder: (BuildContext context, index){
              return _carCardFilter(index);
            },
          ),
          SizedBox(height: Get.height * 0.11)
        ],
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
                          fontSize: 14,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                    Text(
                      'AED ${homeController.filterCarList[index].price} / Daily',
                      style: const TextStyle(
                          fontSize: 12,
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(introController.allCars[index].image),
                        )
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
                          fontSize: 14,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                    Text(
                      'AED ${introController.allCars[index].price} / Daily',
                      style: const TextStyle(
                          fontSize: 12,
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
      width: Get.width - 120,
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    color: AppStyle.primary,
                    shape: BoxShape.circle
                ),
                child: const Icon(Icons.filter_list_off),
              ),
            )
                : GestureDetector(
              onTap: (){
                homeController.chooseCarFilter(introController.brandList[index - 1].id  );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(introController.brandList[index - 1].image)
                    )
                ),
              ),
            );
          },
        ),
      ),
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
