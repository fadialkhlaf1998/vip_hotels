import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/api.dart';

class CarGallery extends StatelessWidget {

  DetailsPageController detailsPageController = Get.find();


  String carImage;

  CarGallery({
    required this.carImage
  });

  bool left =true;

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: detailsPageController.openGallery.value
                ? GestureDetector(
              onTap: (){
                detailsPageController.openGallery.value = false;
              },
                  child: Container(
              width: Get.width,
              height: Get.height,
              color: Colors.black.withOpacity(0.5),
            ),
                ) : const Center(),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.fastOutSlowIn,
            right:  detailsPageController.openGallery.value ? 25 : Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 80),
                GestureDetector(
                  onTap: (){
                    print('fadi');
                  },
                  onPanUpdate: (details) {
                    if (details.delta.dx > 0) {
                      left =false;
                    }
                    if (details.delta.dx < 0) {
                      left =true;
                    }
                  },
                  onPanEnd: (e){
                    if(left){
                      if(detailsPageController.mainCarImageIndex.value+1  < carImage.split(',').length ){
                        detailsPageController.mainCarImageIndex.value += 1;
                        detailsPageController.scrollToItem(detailsPageController.mainCarImageIndex.value, carImage.split(',').length);
                      }
                    }else if(detailsPageController.mainCarImageIndex.value -1 > 0){
                      detailsPageController.mainCarImageIndex.value -= 1;
                      detailsPageController.scrollToItem(detailsPageController.mainCarImageIndex.value, carImage.split(',').length);
                    }

                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    width: Get.width * 0.8,
                    height: Get.height * 0.65,
                    decoration: BoxDecoration(
                        color: AppStyle.lightGrey.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('${Api.url}uploads/${carImage.split(',')[detailsPageController.mainCarImageIndex.value]}')
                        )
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    detailsPageController.openGallery.value = false;
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 40,top: 40),
                    child: Icon(Icons.close, color: Colors.white, size: 40),
                  ),
                )
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease,
            bottom: detailsPageController.openGallery.value ? 50 : - Get.height * 0.17,
            child: SizedBox(
                width: Get.width * 0.8,
                height: Get.height * 0.12,
                child: Center(
                  child: ScrollablePositionedList.builder(
                    scrollDirection: Axis.horizontal,
                    itemScrollController: detailsPageController.itemScrollController,
                    shrinkWrap: true,
                    itemCount: carImage.split(',').length - 1,
                    itemBuilder: (BuildContext context, index){
                      return GestureDetector(
                        onTap: (){
                          detailsPageController.mainCarImageIndex.value = index + 1;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: Get.width * 0.15,
                          decoration: BoxDecoration(
                            color: AppStyle.lightGrey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            border: detailsPageController.mainCarImageIndex.value == index + 1
                                ? Border.all(color: AppStyle.primary, width: 2)
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              fit: BoxFit.cover,
                              '${Api.url}uploads/${carImage.split(',')[index + 1]}',

                              loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: Container(
                                    width: 20,
                                    height: 20,
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
                      );
                    },
                  ),
                )
            ),
          )
        ],
      );
    });
  }
}
