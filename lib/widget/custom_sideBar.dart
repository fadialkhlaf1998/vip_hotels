
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';

class CustomSideBar extends StatelessWidget {

  List<String> myIcon = ['search.svg', 'favorite.svg'];
  HomeController homeController = Get.find();

  double width;
  Color color;
  int selectIndex;
  double space;

  CustomSideBar({
    required this.width,
    required this.color,
    required this.selectIndex,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: width,
        color: color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: (){
                  // homeController.selectIndexSidebar.value = index;
                  homeController.homeButton();
                },
                child: SizedBox(
                    width: width - 25,
                    height: width - 25,
                    child: SvgPicture.asset('assets/icons/home.svg', color: AppStyle.primary,  key: Key('1'),)
                ),
              ),
              SizedBox(height: space),
              ListView.builder(
                shrinkWrap: true,
                itemCount: myIcon.length,
                itemBuilder: (BuildContext context, index){
                  return Column(
                    children: [
                      SizedBox(height: space),
                      GestureDetector(
                        onTap: (){
                           homeController.onTapSideBar(index);
                        },
                        child: SizedBox(
                          width: width - 25,
                          height: width - 25,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: selectIndex == index
                                ? SvgPicture.asset('assets/icons/${myIcon[index]}', color: Colors.white, key: Key('0'),)
                                : SvgPicture.asset('assets/icons/${myIcon[index]}', color: AppStyle.lightGrey,  key: Key('1'),),
                          )
                        ),
                      ),
                      SizedBox(height: space)
                    ],
                  );
                },
              ),
              SizedBox(height: space),
              GestureDetector(
                onTap: (){
                  // homeController.selectIndexSidebar.value = index;
                  // homeController.homeButton();
                  homeController.logout();
                },
                child: SizedBox(
                    width: width - 25,
                    height: width - 25,
                    child: const Icon(Icons.logout, color: AppStyle.lightGrey, size: 35),
                    // child: SvgPicture.asset('assets/icons/home.svg', color: AppStyle.primary,  key: Key('1'),)
                ),
              ),
            ],
          ),
      ),
    );
  }
}


 // mySideBarButton(){
 //  return Container(
 //    width: ,
 //  );
 // }
