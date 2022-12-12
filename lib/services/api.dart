import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vip_hotels/model/all_data.dart';
import 'package:vip_hotels/services/global.dart';

class Api {

  static var url = 'https://phpstack-548447-2953380.cloudwaysapps.com/';

  static Future<AllData?> login(String username, String password) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('${url}api/hotel/login'));
    request.body = json.encode({
      "username": username,
      "password": password
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      AllData u = AllData.fromMap(jsonDecode(data));
      Global.id = u.id.toString();
      Global.title = u.title;
      Global.image = u.image;
      Global.password = u.password;
      Global.username = u.username;
      Global.email = u.email;
      Global.companyId = u.companyId;
      return u;
    } else {
      return null;
    }
  }

  static Future<List<Car>?> filter(List<int> brandId, List<int> categoryId) async {
    print('brandId ${brandId.toString()}');
    print('category Id ${categoryId.toString()}');
    print(Global.id);
    print(Global.companyId);
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('${url}api/car/filter'));
    request.body = json.encode({
      "brands": brandId,
      "categoryies": categoryId,
      "company_id": Global.companyId,
      "hotel_id" : Global.id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      FilterData filterData = FilterData.fromMap(json.decode(data));
      return filterData.cars;
    }
    else {
      return [];
    }
  }

  static Future addOrder(String from, String to, String carId, String? optionId, List<File> images,String phone, String email, String name ) async {

    var request = http.MultipartRequest('POST', Uri.parse('${url}api/orders'));
    request.fields.addAll({
      '_from': from,
      '_to': to,
      'phone': phone,
      'email': email,
      'name': name,
      'car_id': carId,
      'hotel_id': Global.id,
      'option_id': optionId!,
      'company_id': Global.companyId.toString()
    });

    for (int i = 0; i < images.length; i++) {
      request.files.add(await http.MultipartFile.fromPath('files', images[i].path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }

  static Future addOrderGuest(String carName, String name, String email, String phone, String msg) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('${url}api/orders/guest-order'));
    request.body = json.encode({
      "car": carName,
      "name": name,
      "email": email,
      "phone": phone,
      "msg": msg
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }


}