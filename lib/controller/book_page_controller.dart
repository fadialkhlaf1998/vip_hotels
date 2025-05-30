
import 'dart:io';

import 'package:dio/dio.dart' as myDio;
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/api.dart';
import 'package:vip_hotels/services/global.dart';
import 'package:vip_hotels/view/success.dart';

class BookPageController extends GetxController{

  RxBool saveDate = false.obs;
  RxBool validate = false.obs;
  RxString range = ''.obs;
  RxBool calenderOpen = false.obs;
  final ImagePicker _picker = ImagePicker();
  RxList<File> imageList = <File>[].obs;
  String from = '';
  String to = '';
  RxBool loading = false.obs;
  RxBool uploadBar = false.obs;
  RxBool fake = false.obs;
  RxDouble progress = 0.0.obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController msg = TextEditingController();


  void onSelectionDateChanges(var args) {
    if (args.value is PickerDateRange ) {
      saveDate.value = false;
      from = DateFormat('yyyy-MM-dd').format(args.value.startDate);
      to = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate);
      range.value = '${DateFormat('dd/MM').format(args.value.startDate)} -'' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
    } else if (args.value is DateTime) {
      // selectedDate.value = args.value.toString();
    } else if (args.value is List<DateTime>) {
      // dateCount.value = args.value.length.toString();
    } else {
      // rangeCount.value = args.value.length.toString();
    }
  }

  Future selectImage()async{
    _picker.pickMultiImage().then((value){
      for(int i = 0; i < value.length; i++){
      imageList.add(File(value[i].path));
      }
    });
  }

  selectPhotosFromCamera()async{
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    imageList.add(File(photo!.path));
  }

  convertDate(String date){
    return DateTime.parse(date);
  }

  book(String carId,String? optionId,BuildContext context) async {
    try {
      validate.value = true;
      if(range.isNotEmpty && name.text.isNotEmpty &&  address.text.isNotEmpty && phone.text.isNotEmpty && email.text.isNotEmpty &&RegExp(r'\S+@\S+\.\S+').hasMatch(email.text)){
        // loading.value = true;
        uploadBar(true);
        var dio = myDio.Dio();

        var formData = myDio.FormData.fromMap({
          '_from': from,
          '_to': to,
          'phone': phone.text,
          'email': email.text,
          'name': name.text,
          'address': address.text,
          'car_id': carId,
          'hotel_id': Global.id,
          'option_id': optionId!,
          'company_id': Global.companyId.toString(),
        });
        for (int i = 0; i < imageList.length; i++) {
          formData.files.addAll([
            MapEntry('files',await myDio.MultipartFile.fromFile(imageList[i].path)),
          ]);
        }
        print(formData.fields);
        var response = await dio.post(
          '${Api.url}api/orders',
          data: formData,

          onSendProgress: (int sent, int total) {
            fake(!fake.value);
            progress.value = sent / total;
            print(fake.value);
            print('${progress.value}%');

          },
        );
        print(response.data);
        if (response.statusCode == 200) {
          // print(await response.stream.bytesToString());
          // loading.value = false;
          uploadBar(false);
          progress.value = 0;
          Get.off(()=>Success());
        }
        else {
          // loading.value = false;
          uploadBar(false);
          progress.value = 0;
          AppStyle.errorNotification(context, 'Oops', 'Something Went Wrong');
          // print(response.reasonPhrase);
        }



      }else{
        // loading.value = false;
        uploadBar(false);
        if(range.isEmpty ){
          AppStyle.errorNotification(context, 'Warning', 'Please choose date');
        }
      }
    }catch(e){
      // loading.value = false;
      uploadBar(false);
      progress.value = 0;
      AppStyle.errorNotification(context, 'Oops', 'Something Went Wrong');
    }

  }



  confirmDates(){
    saveDate.value = true;
    calenderOpen.value = false;
  }

  Future addOrderGuest(String carName) async {
    bool isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide > 600;
    if(name.text.isEmpty || email.text.isEmpty || phone.text.isEmpty){
      validate.value = true;
      Get.snackbar(
          'Warning', 'Checked fields are required',
          margin: isTablet ? const EdgeInsets.only(top: 40, right: 150, left: 150) : const EdgeInsets.only(top: 40, right: 20, left: 20),
          backgroundColor: AppStyle.lightGrey
      );
      return false;
    }else{
      loading.value = true;
      await Api.addOrderGuest(carName, name.text, email.text, phone.text, msg.text).then((value){
        if(value){
          Get.snackbar(
              'Success', 'Your request is being processed',
              margin: isTablet ? const EdgeInsets.only(top: 40, right: 150, left: 150) : const EdgeInsets.only(top: 40, right: 20, left: 20),
              backgroundColor: AppStyle.green
          );
          validate.value = false;
          loading.value = false;
          Future.delayed(const Duration(milliseconds: 100)).then((value){
            isTablet ? Get.offAllNamed('/home') : Get.offAllNamed('/homeMobile');
          });
        }else{
          Get.snackbar(
              'Warning', 'Something went wrong',
              margin: isTablet ? const EdgeInsets.only(top: 40, right: 150, left: 150) : const EdgeInsets.only(top: 40, right: 20, left: 20),
              backgroundColor: AppStyle.lightGrey
          );
          loading.value = false;
        }
      });
    }
  }




}