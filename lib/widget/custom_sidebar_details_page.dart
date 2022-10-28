


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/controller/home_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';

class CustomSideBarDetailsPage extends StatelessWidget {

  HomeController homeController = Get.find();
  DetailsPageController detailsPageController = Get.find();



  double width;
  Color color;
  int selectIndex;
  double space;

  CustomSideBarDetailsPage({
    required this.width,
    required this.color,
    required this.selectIndex,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: color,
      child: Row(
        children: [
          const SizedBox(width: 15),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: (){
                  detailsPageController.openGallery.value = true;
                },
                child: SizedBox(
                    width: width - 25,
                    height: width - 25,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: selectIndex == 0
                          ? SvgPicture.asset('assets/icons/gallery.svg', color: Colors.white, key: Key('0'),)
                          : SvgPicture.asset('assets/icons/gallery.svg', color: AppStyle.lightGrey,  key: Key('1'),),
                    )
                ),
              ),
              SizedBox(height: space * 2),
              GestureDetector(
                onTap: (){
                  // homeController.homeButton();
                  homeController.selectIndexSidebar.value = -1;
                  Get.back();

                },
                child: SizedBox(
                    width: width - 25,
                    height: width - 25,
                    child: SvgPicture.asset('assets/icons/home.svg', color: AppStyle.primary,  key: Key('1'),)
                ),
              ),
              SizedBox(height: space * 2),
              GestureDetector(
                onTap: (){
                  homeController.themeOpenPage.value = true;
                  homeController.selectIndexSidebar.value = 1;
                },
                child: SizedBox(
                    width: width - 25,
                    height: width - 25,
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: selectIndex == 1
                            ? SvgPicture.asset('assets/icons/theme.svg', color: Colors.white, key: Key('0'),)
                            : SvgPicture.asset('assets/icons/theme.svg', color: AppStyle.lightGrey,  key: Key('1'),),
                      )
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const VerticalDivider(color: AppStyle.lightGrey,indent: 100,endIndent: 100,width: 0,thickness: 1.5),
        ],
      ),
    );
  }
}
