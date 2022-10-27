
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vip_hotels/services/AppStyle.dart';
import 'package:vip_hotels/services/api.dart';

class BookPageController extends GetxController{

  RxBool saveDate = false.obs;
  RxString range = ''.obs;
  RxBool calenderOpen = false.obs;
  final ImagePicker _picker = ImagePicker();
  RxList<File> imageList = <File>[].obs;
  String from = '';
  String to = '';
  RxBool loading = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();


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

  book(String carId,String? optionId) async {
    if(range.isNotEmpty){
      loading.value = true;
      await Api.addOrder(from,to,carId,optionId,imageList, phone.text, email.text, name.text).then((value){
        if(value){
          loading.value = false;
          Get.offNamed('/home');
          print('success');

        }else{
          loading.value = false;
          print('failed');
        }
      });
    }else{
     Get.snackbar(
         'Warning', 'Please choose date',
       margin: const EdgeInsets.only(top: 40, right: 150, left: 150),
       backgroundColor: AppStyle.lightGrey
     );
    }
  }

  confirmDates(){
    saveDate.value = true;
    calenderOpen.value = false;
  }




}