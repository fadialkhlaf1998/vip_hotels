import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vip_hotels/controller/book_page_controller.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/model/backend_style.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/api.dart';
import 'package:vip_hotels/services/global.dart';
import 'package:vip_hotels/widget/custom_animated_textField.dart';
import 'package:vip_hotels/widget/custom_animation_phone_field.dart';
import 'package:vip_hotels/widget/custom_button.dart';
import 'package:get/get.dart';

class BookPageMobile extends StatelessWidget {

  Car car = Get.arguments[0];
  DetailsPageController detailsPageController = Get.find();
  BookPageController bookPageController = Get.put(BookPageController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
    ));
    return Obx((){
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Container(
                      //   width: Get.width,
                      //   height: Get.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         fit: BoxFit.cover,
                      //         image: NetworkImage(car.image)
                      //     ),
                      //   ),
                      // ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.fastOutSlowIn,
                        width: Get.width,
                        height: Get.height,
                        // color: Colors.black.withOpacity(0.7),
                      ),
                      _bookDetails(context),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: bookPageController.calenderOpen.value
                            ? Container(
                          width:Get.width,
                          height: Get.height,
                          color: Colors.black.withOpacity(0.7),
                          child: _pickDate(),
                        ) : const Text(''),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: bookPageController.uploadBar.value ?
                    Container(
                      width: Get.width,
                      height: Get.height,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 5.0,
                          percent: bookPageController.progress.value,
                          center: Text((bookPageController.progress.value * 100).toStringAsFixed(2)+"%",style: TextStyle(color: BackEndStyle.primary_color,fontWeight: FontWeight.bold),),
                          progressColor: BackEndStyle.primary_color,
                        ),
                      ),
                    )
                        :bookPageController.loading.value
                        ? Container(
                      width: Get.width,
                      height: Get.height,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 5,color: BackEndStyle.primary_color,),
                      ),
                    ) : const Center(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }


  _bookDetails(BuildContext context){
    return SingleChildScrollView(
      child: SizedBox(
        height: Get.height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: Get.width * 0.1, top: 20),
                child: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.black),
              ),
            ),
          ),
            SizedBox(
              height: Get.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Global.guest
                      ? const Center()
                      : Obx((){
                    return  GestureDetector(
                      onTap: (){
                        bookPageController.calenderOpen.value = true;
                      },
                      child: Container(
                        width: Get.width * 0.8,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: BackEndStyle.body_color, width: 2)
                        ),
                        child: Center(
                          child: bookPageController.range.isEmpty
                              ? Text(
                              'Pickup & Dropoff Date',
                              style: TextStyle(
                                  color: BackEndStyle.body_color,
                                  fontFamily: 'graphik',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ))
                              :  Text(
                              'From ${bookPageController.range.value.split('-')[0]} To ${bookPageController.range.value.split('-')[1]}',
                              style: TextStyle(
                                  color: BackEndStyle.title_color,
                                  fontFamily: 'graphik',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              )),
                        ),
                      ),
                    );
                  }),
                  Global.guest
                      ? const Center()
                      : DottedBorder(
                      color: BackEndStyle.primary_color,
                      dashPattern: const [10, 4],
                      strokeWidth: 2,
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: Get.width * 0.78,
                          height: Get.height * 0.15,
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      bookPageController.selectImage();
                                    },
                                    child: SvgPicture.asset('assets/icons/gallery.svg', color: BackEndStyle.primary_color, width: 35,height: 35,fit: BoxFit.contain,),
                                  ),
                                  const SizedBox(width: 40),
                                  GestureDetector(
                                    onTap: (){
                                      bookPageController.selectPhotosFromCamera();
                                    },
                                    child: Icon(Icons.camera_alt, color: BackEndStyle.primary_color,size: 40,),
                                  ),
                                ],
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  _iconContainer('Id', 'id'),
                                  _iconContainer('Passport', 'passport'),
                                  _iconContainer('Visa', 'visa'),
                                  _iconContainer('Driving license', 'driving-license'),
                                ],
                              ),
                            ],
                          )
                      )
                  ),
                  Global.guest
                      ? SizedBox(
                    width: Get.width * 0.8,
                    child: Text(
                      car.title,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  )
                      : const Center(),
                  const SizedBox(height: 20),
                  CustomAnimatedTextField(
                    duration: 900,
                    width: 0.8,
                    height: 50,
                    controller: bookPageController.name,
                    prefixIcon: Icon(Icons.person, color: BackEndStyle.primary_color),
                    keyboardType: TextInputType.text,
                    labelText: 'Enter your name',
                    // right: bookPageController.range.isEmpty ? - Get.width * 0.3 : Get.width * 0.1,
                    right: Get.width * 0.1,
                    bottom: Get.height * 0.5,
                    validate: bookPageController.name.text.isEmpty && bookPageController.validate.value,
                  ),
                  CustomAnimatedTextField(
                    duration: 900,
                    width: 0.8,
                    height: 50,
                    controller: bookPageController.address,
                    prefixIcon: Icon(Icons.location_on, color: BackEndStyle.primary_color),
                    keyboardType: TextInputType.text,
                    labelText: 'Enter your Address',
                    // right: bookPageController.range.isEmpty ? - Get.width * 0.3 : Get.width * 0.1,
                    right: Get.width * 0.1,
                    bottom: Get.height * 0.5,
                    validate: bookPageController.address.text.isEmpty && bookPageController.validate.value,
                  ),
                  CustomAnimatedTextField(
                    duration: 1500,
                    width: 0.8,
                    height: 50,
                    controller: bookPageController.email,
                    prefixIcon: Icon(Icons.email, color: BackEndStyle.primary_color),
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Enter your email',
                    // right: bookPageController.range.isEmpty ? - Get.width * 0.3 : Get.width * 0.1,
                    right: Get.width * 0.1,
                    bottom: Get.height * 0.4,
                    validate: (bookPageController.email.text.isEmpty && bookPageController.validate.value) ||
                        (!RegExp(r'\S+@\S+\.\S+').hasMatch(bookPageController.email.text)&& bookPageController.validate.value) ,
                  ),
                  CustomAnimatedPhoneField(
                    duration: 1100,
                    width: 0.8,
                    height: 52,
                    controller: bookPageController.phone,
                    prefixIcon: Icon(Icons.phone, color: BackEndStyle.primary_color),
                    keyboardType: TextInputType.number,
                    labelText: 'Phone',
                    // right: bookPageController.range.isEmpty ? - Get.width * 0.3 : Get.width * 0.1,
                    right:Get.width * 0.1,
                    bottom: Get.height * 0.3,
                    validate: bookPageController.phone.text.length < 10 && bookPageController.validate.value,
                  ),
                  Global.guest
                  ? SizedBox(
                    width: Get.width * 0.8,
                    height: Get.height * 0.15,
                    child: TextField(
                      // keyboardType: TextInputType.multiline,
                      expands: true,
                      maxLines: null,
                      controller: bookPageController.msg,
                      decoration:  InputDecoration(
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: AppStyle.lightGrey
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: AppStyle.lightGrey),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        prefixIcon: Icon(Icons.message, color: BackEndStyle.primary_color,),
                        labelText: 'Message',
                        labelStyle: TextStyle(
                            color: BackEndStyle.body_color,
                            fontSize: 13
                        ),
                      ),
                      style: TextStyle(color: BackEndStyle.title_color),
                    ),
                  )
                  : const Center(),
                  SizedBox(
                    height: Get.height * 0.1,
                    width: Get.width * 0.8,
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: bookPageController.imageList.length,
                        itemBuilder: (BuildContext context, index){
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: Get.height * 0.1,
                            height: Get.height * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(bookPageController.imageList[index])
                                )
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: Get.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      width: Get.width* 0.3,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: BackEndStyle.primary_color),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text("Cancel",style: TextStyle(color: BackEndStyle.primary_color,fontSize: 16),),
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  CustomButton(
                      width: 0.3,
                      height: 40,
                      text: Global.guest ? 'INQUIRE NOW' : 'BOOK NOW',
                      onPressed: () async {
                        if(Global.guest){
                           bookPageController.addOrderGuest(car.title);
                        }else{
                          await bookPageController.book(car.carId.toString(), detailsPageController.optionId.value.toString(),context);
                          detailsPageController.optionId.value = -1;
                          detailsPageController.optionIndex.value = 0;
                        }
                      },
                      color: BackEndStyle.primary_color,
                      borderRadius: 20,
                      textStyle: const TextStyle(color: Colors.white, fontSize: 14)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0)
          ],
        ),
      ),
    );
  }

  _iconContainer(String text, String icon){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Image.asset('assets/icons/$icon.png', width: 25,height: 25),

          icon == 'id'?Icon(Icons.perm_identity,size: 25,color: BackEndStyle.primary_color,):
          icon == 'passport'?Icon(Icons.account_box_outlined,size: 25,color: BackEndStyle.primary_color,) :
          icon == 'visa'?Icon(Icons.airplane_ticket_outlined,size: 25,color: BackEndStyle.primary_color,) :
          Icon(Icons.drive_eta_outlined,size: 25,color: BackEndStyle.primary_color,),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 12
            ),
          ),
        ],
      ),
    );
  }


  _pickDate(){
    return Center(
      child: Container(
        width: Get.width * 0.8,
        height: 430,
        decoration: BoxDecoration(
            color: AppStyle.grey,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                      onTap: () {
                        bookPageController.calenderOpen.value = false;
                      },
                      child: const Icon(Icons.close,color: Colors.white,size: 25)
                  ),
                )
              ],
            ),
            SfDateRangePicker(
              onSelectionChanged: bookPageController.onSelectionDateChanges,
              selectionMode: DateRangePickerSelectionMode.range,
              backgroundColor: AppStyle.grey,
              minDate: DateTime.now(),
              view: DateRangePickerView.month,
              monthViewSettings: const DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                        color: AppStyle.grey,
                        fontSize: 19
                    ),
                    backgroundColor: AppStyle.lightGrey
                ),
              ),
              selectionTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
              ),
              monthCellStyle: const DateRangePickerMonthCellStyle(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                ),
                disabledDatesTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white
                ),
              ),
              yearCellStyle: const DateRangePickerYearCellStyle(
                disabledDatesTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white
                ),
                todayTextStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              rangeSelectionColor: AppStyle.lightGrey,
              rangeTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              headerStyle: const DateRangePickerHeaderStyle(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                ),
                backgroundColor: AppStyle.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Center(
                child: SizedBox(
                  width: Get.width * 0.45,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //todo : delete comment
                      // primary: BackEndStyle.primary_color,
                      // onPrimary: BackEndStyle.primary_color,
                      backgroundColor: BackEndStyle.primary_color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: FittedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                                'Confirm Dates',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                )
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(Icons.arrow_forward,color: Colors.black,size: 20),
                            )
                          ],
                        )
                    ),
                    onPressed: () {
                      bookPageController.confirmDates();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }




}
