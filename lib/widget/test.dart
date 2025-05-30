import 'package:flutter/cupertino.dart';

class Test{

// _carCardFilter(index){
  //   return GestureDetector(
  //     onTap: (){
  //       if(homeController.filterCarList[index].options.isNotEmpty){
  //         Get.toNamed('/CarDetailsMobile', arguments: [homeController.filterCarList[index]]);
  //       }
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: AppStyle.grey.withOpacity(0.7),
  //           borderRadius: BorderRadius.circular(20)
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Flexible(
  //             flex: 8,
  //             child: Stack(
  //               alignment: Alignment.topLeft,
  //               children: [
  //                 Container(
  //                   decoration: BoxDecoration(
  //                       borderRadius: const BorderRadius.only(
  //                         topLeft: Radius.circular(20),
  //                         topRight: Radius.circular(20),
  //                       ),
  //                       image: DecorationImage(
  //                         fit: BoxFit.cover,
  //                         image: NetworkImage(homeController.filterCarList[index].image),
  //                       )
  //                   ),
  //                 ),
  //                 Hero(
  //                   tag: homeController.filterCarList[index].carId,
  //                   child: Container(
  //                     width: Get.width * 0.08,
  //                     height: Get.width * 0.08,
  //                     margin: const EdgeInsets.all(5),
  //                     decoration: BoxDecoration(
  //                         image: DecorationImage(
  //                             image: NetworkImage(homeController.filterCarList[index].brandImage)
  //                         )
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 10,
  //                   right: 10,
  //                   child: Row(
  //                     children: [
  //                       SvgPicture.asset("assets/icons/circle_seats.svg",width: 22,),
  //                       SizedBox(width: 5,),
  //                       Text(homeController.filterCarList[index].seets.toString()+" Seats",style: TextStyle(color: Colors.white),)
  //                     ],
  //                   ),)
  //               ],
  //             ),
  //           ),
  //           Flexible(
  //             flex: 5,
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //
  //                   Text(
  //                     homeController.filterCarList[index].title,
  //                     maxLines: 1,
  //                     style: const TextStyle(
  //                         fontSize: 15,
  //                         color: Colors.white,
  //                         fontStyle: FontStyle.italic
  //                     ),
  //                   ),
  //                   // Row(
  //                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   //   children: [
  //                   //
  //                   //
  //                   //
  //                   //     Row(
  //                   //       children: [
  //                   //         SvgPicture.asset("assets/icons/doors.svg"),
  //                   //         SizedBox(width: 5,),
  //                   //         Text(homeController.filterCarList[index].doors.toString(),style: TextStyle(color: Colors.white),)
  //                   //       ],
  //                   //     ),
  //                   //
  //                   //     Row(
  //                   //       children: [
  //                   //         SvgPicture.asset("assets/icons/calendar.svg"),
  //                   //         SizedBox(width: 5,),
  //                   //         Text(homeController.filterCarList[index].year,style: TextStyle(color: Colors.white),)
  //                   //       ],
  //                   //     ),
  //                   //
  //                   //     Row(
  //                   //       children: [
  //                   //         SvgPicture.asset("assets/icons/seat.svg"),
  //                   //         SizedBox(width: 5,),
  //                   //         Text(homeController.filterCarList[index].seets.toString(),style: TextStyle(color: Colors.white),)
  //                   //       ],
  //                   //     ),
  //                   //
  //                   //
  //                   //   ],
  //                   // ),
  //
  //                   Row(
  //                     children: [
  //                       Text(
  //                         !Global.guest ? 'AED ${homeController.filterCarList[index].price}  ' : 'AED ****  ',
  //                         // 'AED ${introController.allCars[index].price} / Daily',
  //                         style: const TextStyle(
  //                             fontSize: 15,
  //                             color: AppStyle.primary,
  //                             fontStyle: FontStyle.italic
  //                         ),
  //                       ),
  //                       Text(
  //                         "Daily",
  //                         style: TextStyle(
  //                             fontSize: 13,
  //                             color: Colors.white.withOpacity(0.7),
  //                             fontStyle: FontStyle.italic
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Text(
  //                      'Security Deposit: AED ${homeController.filterCarList[index].insurance_price}',
  //                     style: TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.white.withOpacity(0.7),
  //                         fontStyle: FontStyle.italic
  //                     ),
  //                   ),
  //
  //                   // SizedBox(height: 5,)
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Flexible(
  //             flex: 2,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   color: Colors.black.withOpacity(0.6),
  //                   borderRadius: const BorderRadius.only(
  //                     bottomRight: Radius.circular(20),
  //                     bottomLeft: Radius.circular(20),
  //                   )
  //               ),
  //               child: _carCardButtonFilter(index),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // _carCardButtonFilter(index){
  //   return Row(
  //     children: [
  //       Flexible(
  //         flex: 1,
  //         child: GestureDetector(
  //           onTap: (){
  //             if(homeController.filterCarList[index].options.isNotEmpty){
  //               Get.toNamed('/CarDetailsMobile', arguments: [homeController.filterCarList[index]]);
  //             }
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 color: homeController.filterCarList[index].options.isNotEmpty ? Colors.white : Colors.grey,
  //                 borderRadius: const BorderRadius.only(
  //                   bottomLeft: Radius.circular(20),
  //                 )
  //             ),
  //             child: Center(
  //               child: Text(
  //                 'Car Details',
  //                 style: TextStyle(
  //                     fontStyle: FontStyle.italic,
  //                     color: homeController.filterCarList[index].options.isNotEmpty ? Colors.black : Colors.white.withOpacity(0.5),
  //                     fontSize: 12
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 5),
  //       Flexible(
  //         flex: 1,
  //         child: GestureDetector(
  //           onTap: (){
  //             Get.toNamed('/bookMobile', arguments: [homeController.filterCarList[index]]);
  //           },
  //           child: Container(
  //             decoration: const BoxDecoration(
  //                 color: AppStyle.primary,
  //                 borderRadius: BorderRadius.only(
  //                     bottomRight: Radius.circular(20)
  //                 )
  //             ),
  //             child: const Center(
  //               child: Text(
  //                 'Rent Now',
  //                 style: TextStyle(
  //                     fontStyle: FontStyle.italic,
  //                     color: Colors.black,
  //                     fontSize: 12
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}