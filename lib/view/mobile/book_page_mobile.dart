import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vip_hotels/controller/book_page_controller.dart';
import 'package:vip_hotels/controller/details_page_controller.dart';
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/widget/custom_animated_textField.dart';
import 'package:vip_hotels/widget/custom_animation_phone_field.dart';
import 'package:vip_hotels/widget/custom_button.dart';
import 'package:get/get.dart';

class BookPageMobile extends StatelessWidget {

  Car car = Get.arguments[0];
  BookPageController bookPageController = Get.put(BookPageController());
  DetailsPageController detailsPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: Get.width,
                            height: Get.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(car.image)
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.fastOutSlowIn,
                            width: Get.width,
                            height: Get.height,
                            color: Colors.black.withOpacity(0.7),
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
                            ) : Text(''),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: bookPageController.loading.value
                        ? Container(
                      width: Get.width,
                      height: Get.height,
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 5,color: AppStyle.primary,),
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
      child: Container(
        height: Get.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx((){
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
                      border: Border.all(color: AppStyle.lightGrey, width: 2)
                  ),
                  child: Center(
                    child: bookPageController.range.isEmpty
                        ? const Text(
                        'Pickup & Dropoff Date',
                        style: TextStyle(
                            color: AppStyle.lightGrey,
                            fontFamily: 'D-DIN-PRO',
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ))
                        :  Text(
                        'From ${bookPageController.range.value.split('-')[0]} To ${bookPageController.range.value.split('-')[1]}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'D-DIN-PRO',
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        )),
                  ),
                ),
              );
            }),
            DottedBorder(
                color: AppStyle.primary,
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
                              child: SvgPicture.asset('assets/icons/gallery.svg', color: AppStyle.primary, width: 40,height: 40,fit: BoxFit.contain,),
                            ),
                            const SizedBox(width: 40),
                            GestureDetector(
                              onTap: (){
                                bookPageController.selectPhotosFromCamera();
                              },
                              child: const Icon(Icons.camera_alt, color: AppStyle.primary,size: 45,),
                            ),
                          ],
                        ),
                        const Text(
                            'Passport Copy, Hotel Reservation, Driving License',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppStyle.lightGrey,
                                fontFamily: 'D-DIN-PRO',
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ))
                      ],
                    )
                )
            ),
            CustomAnimatedTextField(
              duration: 900,
              width: 0.8,
              height: 50,
              controller: bookPageController.name,
              prefixIcon: const Icon(Icons.person, color: AppStyle.primary),
              keyboardType: TextInputType.text,
              labelText: 'Enter your name',
              // right: bookPageController.range.isEmpty ? - Get.width * 0.3 : Get.width * 0.1,
              right: Get.width * 0.1,
              bottom: Get.height * 0.5,
              validate: bookPageController.name.text.isEmpty && bookPageController.validate.value,
            ),
            CustomAnimatedTextField(
              duration: 1500,
              width: 0.8,
              height: 50,
              controller: bookPageController.email,
              prefixIcon: const Icon(Icons.email, color: AppStyle.primary),
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
              prefixIcon: const Icon(Icons.phone, color: AppStyle.primary),
              keyboardType: TextInputType.number,
              labelText: 'Phone',
              // right: bookPageController.range.isEmpty ? - Get.width * 0.3 : Get.width * 0.1,
              right:Get.width * 0.1,
              bottom: Get.height * 0.3,
              validate: bookPageController.phone.text.length < 10 && bookPageController.validate.value,
            ),
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
            CustomButton(
                width: 0.5,
                height: 40,
                text: 'BOOK NOW',
                onPressed: () async {
                  await bookPageController.book(car.carId.toString(), detailsPageController.optionId.value.toString(),context);
                  detailsPageController.optionId.value = -1;
                  detailsPageController.optionIndex.value = 0;

                },
                color: AppStyle.primary,
                borderRadius: 5,
                textStyle: const TextStyle(color: Colors.black, fontSize: 14)
            )
          ],
        ),
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
                  fontSize: 18
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
                      primary: AppStyle.primary,
                      onPrimary: AppStyle.primary,
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