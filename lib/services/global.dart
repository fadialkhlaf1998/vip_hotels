

import 'package:shared_preferences/shared_preferences.dart';

class Global {

  static String id = '';
  static String title = '';
  static String username = '';
  static String password = '';
  static String image = '';
  static String email = '';
  static int companyId = -1;
  static bool guest = false;


  static saveUserInformation(String id, String title, String username, String password, String image, int companyId, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    prefs.setString('title', title);
    prefs.setString('username', username);
    prefs.setString('password', password);
    prefs.setString('image', image);
    prefs.setString('email', email);
    prefs.setInt('companyId', companyId);
  }

  static Future<bool> loadUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    title = prefs.getString('title') ?? '';
    username = prefs.getString('username') ?? '';
    password = prefs.getString('password') ?? '';
    image = prefs.getString('image') ?? "";
    companyId = prefs.getInt('companyId') ?? -1;
    email = prefs.getString('email') ?? '';

    return true;
  }

  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('title');
    prefs.remove('username');
    prefs.remove('password');
    prefs.remove('image');
    prefs.remove('companyId');
    prefs.remove('id');
    prefs.remove('email');
  }

  static saveTheme(int themeIndex, double angle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', themeIndex);
    prefs.setDouble('angle', angle);
  }

  static Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('theme') ?? 1;
  }


}