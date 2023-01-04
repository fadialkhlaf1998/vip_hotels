
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';

class CustomBottomNavBar extends StatelessWidget {

  List<String> myIcon = ['search.svg', 'favorite.svg'];
  HomeController homeController = Get.find();

  double height;
  Color color;
  int selectIndex;
  double space;

  CustomBottomNavBar({
    required this.height,
    required this.color,
    required this.selectIndex,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      width: Get.width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30)
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              if(homeController.searchOpenTextDelegate.value == true){
                homeController.searchOpenTextDelegate.value = false;
                homeController.brandOpenMenu.value = true;
                homeController.selectIndexSidebar.value = -1;
              }else{
                homeController.searchOpenTextDelegate.value = true;
                homeController.brandOpenMenu.value = false;
                homeController.themeOpenPage.value = false;
                homeController.goToTheTop();
              }
            },
            child: Column(
              children: [
                SizedBox(
                    width: 25,
                    height: 25,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: homeController.searchOpenTextDelegate.value
                          ? SvgPicture.asset('assets/icons/search.svg', color: Colors.white, key: Key('0'),)
                          : SvgPicture.asset('assets/icons/search.svg', color: AppStyle.lightGrey,  key: Key('1'),),
                    )
                ),
                const SizedBox(height: 5),
                Text(
                  'Search',
                  style: TextStyle(color: homeController.searchOpenTextDelegate.value ? Colors.white : Colors.grey, fontFamily: 'D-DIN-PRO', fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(width: space),
          GestureDetector(
            onTap: (){
              homeController.homeButton();
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
          SizedBox(width: space),
          GestureDetector(
            onTap: (){
              homeController.logoutConfirm.value = true;
            },
            child: Column(
              children: [
                SizedBox(
                    width: 25,
                    height: 25,
                    child: SvgPicture.asset('assets/icons/logout.svg', color: AppStyle.lightGrey,)
                ),
                const SizedBox(height: 5),
                const Text(
                  'Logout',
                  style: TextStyle(color: Colors.grey, fontFamily: 'D-DIN-PRO', fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: (){
          //     if(homeController.brandOpenMenu.value == true){
          //       homeController.brandOpenMenu.value = false;
          //       homeController.selectIndexSidebar.value = -1;
          //     }else{
          //       homeController.searchOpenTextDelegate.value = false;
          //       homeController.brandOpenMenu.value = true;
          //       homeController.themeOpenPage.value = false;
          //       homeController.goToTheTop();
          //     }
          //   },
          //   child: Container(
          //       width: 25,
          //       height: 25,
          //       child: AnimatedSwitcher(
          //         duration: const Duration(milliseconds: 300),
          //         child: homeController.brandOpenMenu.value
          //             ? SvgPicture.asset('assets/icons/favorite.svg', color: Colors.white, key: Key('0'),)
          //             : SvgPicture.asset('assets/icons/favorite.svg', color: AppStyle.lightGrey,  key: Key('1'),),
          //       )
          //   ),
          // ),
        ],
      ),
    );
  }
}


// mySideBarButton(){
//  return Container(
//    width: ,
//  );
// }
