
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/model/backend_style.dart';
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
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Adjust opacity
            offset: const Offset(0, -4), // Negative Y for top shadow
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // SizedBox(width: 10),
          Container(
            width: 120,
            child: GestureDetector(
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
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: homeController.searchOpenTextDelegate.value
                        ?BackEndStyle.selected_nav_bg_color
                        :Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: 25,
                        height: 25,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: homeController.searchOpenTextDelegate.value
                              ? SvgPicture.asset('assets/icons/search.svg', color: BackEndStyle.primary_color, key: Key('0'),)
                              : SvgPicture.asset('assets/icons/search.svg', color: BackEndStyle.primary_color,  key: Key('1'),),
                        )
                    ),
                    // const SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(color: BackEndStyle.primary_color, fontFamily: 'graphik', fontSize: 13, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(width: 10),
          Container(
            width: 120,
            child: GestureDetector(
              onTap: (){
                homeController.homeButton();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: !homeController.searchOpenTextDelegate.value
                      ?BackEndStyle.selected_nav_bg_color
                      :Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width:   25,
                        height:  25,
                        child: SvgPicture.asset('assets/icons/home.svg', color: BackEndStyle.primary_color,  key: Key('1'),)
                    ),
                    Text(
                      'Home',
                      style: TextStyle(color: BackEndStyle.primary_color, fontFamily: 'graphik', fontSize: 13, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(width: 10),
          Container(
            width: 120,
            child: GestureDetector(
              onTap: (){
                homeController.logoutConfirm.value = true;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 25,
                      height: 25,
                      child: SvgPicture.asset('assets/icons/logout.svg', color: BackEndStyle.primary_color,)
                  ),
                  // const SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(color: BackEndStyle.primary_color, fontFamily: 'graphik', fontSize: 13, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          // SizedBox(width: 10),
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
