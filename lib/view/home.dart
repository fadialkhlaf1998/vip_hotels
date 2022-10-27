import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/controller/intro_controller.dart';
import 'package:vip_hotels/controller/login_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/global.dart';
import 'package:vip_hotels/widget/backgroundImage.dart';
import 'package:vip_hotels/widget/custom_logo.dart';
import 'package:vip_hotels/widget/custom_sideBar.dart';
import 'package:vip_hotels/widget/theme_circle.dart';

class Home extends StatelessWidget {

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
                  BackgroundImage(),
                  Container(
                    width: Get.width * 0.5,
                    height: Get.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0),
                        ],
                      ),
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
                      _topBar(),
                      _bottomBar()
                    ],
                  ),
                 AnimatedSwitcher(
                   duration: const Duration(milliseconds: 500),
                   child: homeController.themeOpenPage.value ? ThemeCircle() : const Text(''),
                 ),
                  /// filter button
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    right: 30,
                    bottom: homeController.chooseBrand.value ? 40 : -Get.width * 0.06,
                    child: GestureDetector(
                      onTap: (){
                        homeController.clearFilter();
                      },
                      child: Container(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        decoration: const BoxDecoration(
                          color: AppStyle.primary,
                          shape: BoxShape.circle
                        ),
                        child: const Center(
                          child: Icon(Icons.filter_list_off_sharp,size: 35),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        ),
      );
    });
  }


  _mainObject(context){
    return  SizedBox(
      width: Get.width - 80, /// this number is the sum of sideBar width and divider width
      child: Center(
        child: homeController.loading.value
            ? const CircularProgressIndicator(strokeWidth: 6)
            : homeController.chooseBrand.value ? _carFilterList(context) : _carList(context),
      )
    );
  }

  _bottomBar(){
    return Container(
      height: Get.height * 0.08,
      width: Get.width,
      decoration:  BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.4)
              ]
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomLogo(width: 0.18, height: 0.07, tag: 'tag'),
          GestureDetector(
            onTap: (){
              if(homeController.chooseBrand.value){
                homeController.chooseCarFilter(homeController.brandId.value);
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
                      color: Colors.grey,
                      fontSize: 27,
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
                    child: Center(
                      child: Text(
                        introController.carCategory[index].title,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 27,
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
        ],
      ),
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
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Image.network(Global.image),
        )
      ),
    );
  }

  _carList(context){
    return SizedBox(
      width: Get.width - 120,
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
              crossAxisCount: 3,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              // childAspectRatio: 12/12
            ),
            itemCount: introController.allCars.length,
            itemBuilder: (BuildContext context, index){
              return _carCard(index);
            },
          ),
          SizedBox(height: Get.height * 0.11)
        ],
      ),
    );
  }

  _carFilterList(context){
    return SizedBox(
      width: Get.width - 120,
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
              crossAxisCount: 3,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              // childAspectRatio: 12/12
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
    return Container(
      decoration: BoxDecoration(
          color: AppStyle.grey.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 5,
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
                )
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
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                  Text(
                    'AED ${homeController.filterCarList[index].price} / Daily',
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppStyle.primary,
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
    );
  }


  _carCard(index){
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.grey.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 5,
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
                    width: Get.width * 0.04,
                    height: Get.width * 0.04,
                    margin: const EdgeInsets.all(10),
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
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    introController.allCars[index].title,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  Text(
                      'AED ${introController.allCars[index].price} / Daily',
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppStyle.primary,
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
              child: _carCardButton(index),
            ),
          )
        ],
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
              Get.toNamed('/book', arguments: [homeController.filterCarList[index]]);
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: AppStyle.green,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20)
                  )
              ),
              child: const Center(
                child: Text(
                  'Rent Now',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
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


  _carCardButton(index){
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: (){
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
              Get.toNamed('/book', arguments: [introController.allCars[index]]);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: AppStyle.green,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20)
                )
              ),
              child: const Center(
                child: Text(
                  'Rent Now',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
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
                children: const [
                  SizedBox(width: 20),
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
          itemCount: introController.brandList.length,
          itemBuilder: (BuildContext context, index){
            return GestureDetector(
              onTap: (){
                homeController.chooseCarFilter(introController.brandList[index].id  );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(introController.brandList[index].image)
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
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
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

    return Container(
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
                       Container(
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
                                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                             Text(item.price.toString() + ' AED'),
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
    return Text('');
  }

}
