// To parse this JSON data, do
//
//     final allData = allDataFromMap(jsonString);

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

AllData allDataFromMap(String str) => AllData.fromMap(json.decode(str));

String allDataToMap(AllData data) => json.encode(data.toMap());

class AllData {
  AllData({
    required this.id,
    required this.title,
    required this.image,
    required this.password,
    required this.username,
    required this.companyId,
    required this.email,
    required this.category,
    required this.brands,
    required this.contactPerson,
    required this.header_image,
    required this.footer_image,
    required this.inner_image,
    required this.phone,
    required this.selected_brand_bg_color,
    required this.primary_color,
    required this.title_color,
    required this.body_color,
    required this.card_bg_color,
    required this.card_border_color,
    required this.category_color,
    required this.selected_nav_bg_color,
  });

  int id;
  String title;
  String image;
  String password;
  String username;
  int companyId;
  dynamic email;
  List<Category> category;
  List<Brand> brands;
  List<Category> contactPerson;
  String header_image;
  String footer_image;
  String inner_image;
  String phone;
  Color selected_brand_bg_color;
  Color primary_color;
  Color title_color;
  Color body_color;
  Color card_bg_color;
  Color card_border_color;
  Color category_color;
  Color selected_nav_bg_color;


  static Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex"; // Add opacity if not included
    }
    return Color(int.parse(hex, radix: 16));
  }

  factory AllData.fromMap(Map<String, dynamic> json) => AllData(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    password: json["password"],
    username: json["username"],
    companyId: json["company_id"],
    email: json["email"],
    header_image: json["header_image"]!=null?json["header_image"]:"https://www.vipcarrental.ae/wp-content/uploads/2024/10/book-you-car.webp",
    footer_image: json["footer_image"]!=null?json["footer_image"]:"https://www.vipcarrental.ae/wp-content/uploads/2024/10/book-you-car.webp",
    inner_image: json["inner_image"]!=null?json["inner_image"]:"https://www.vipcarrental.ae/wp-content/uploads/2024/10/book-you-car.webp",
    phone: json["phone"]!=null?json["phone"]:"00971582706592",
    selected_brand_bg_color: json["selected_brand_bg_color"]!=null?hexToColor(json["selected_brand_bg_color"]):Colors.white,
    primary_color: json["primary_color"]!=null?hexToColor(json["primary_color"]):Colors.white,
    title_color: json["title_color"]!=null?hexToColor(json["title_color"]):Colors.white,
    body_color: json["body_color"]!=null?hexToColor(json["body_color"]):Colors.white,
    card_bg_color: json["card_bg_color"]!=null?hexToColor(json["card_bg_color"]):Colors.white,
    card_border_color: json["card_border_color"]!=null?hexToColor(json["card_border_color"]):Colors.white,
    category_color: json["category_color"]!=null?hexToColor(json["category_color"]):Colors.white,
    selected_nav_bg_color: json["selected_nav_bg_color"]!=null?hexToColor(json["selected_nav_bg_color"]):Colors.white,

    category: List<Category>.from(json["category"].map((x) => Category.fromMap(x))),
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromMap(x))),
    contactPerson: List<Category>.from(json["contact_person"].map((x) => Category.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "password": password,
    "username": username,
    "company_id": companyId,
    "email": email,
    "category": List<dynamic>.from(category.map((x) => x.toMap())),
    "brands": List<dynamic>.from(brands.map((x) => x.toMap())),
    "contact_person": List<dynamic>.from(contactPerson.map((x) => x.toMap())),
  };
}

class FilterData{
  List<Car> cars;
  FilterData({ required this.cars,});
  factory FilterData.fromMap(Map<String, dynamic> json) => FilterData(
    cars: List<Car>.from(json["cars"].map((x) => Car.fromMap(x))),
  );
}
class Category {
  Category({
    required this.id,
    required this.title,
    required this.image,
    required this.companyId,
    required this.cars,
    required this.phone,
  });

  int id;
  String title;
  String image;
  int companyId;
  List<Car>? cars;
  String phone;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    companyId: json["company_id"],
    cars: json["cars"] == null ? null : List<Car>.from(json["cars"].map((x) => Car.fromMap(x))),
    phone: json["phone"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "company_id": companyId,
    "cars": cars == null ? null : List<dynamic>.from(cars!.map((x) => x.toMap())),
    "phone": phone == null ? null : phone,
  };
}


class Brand {
  Brand({
    required this.id,
    required this.title,
    required this.image,
    required this.companyId,
  });

  int id;
  String title;
  String image;
  int companyId;


  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    companyId: json["company_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "company_id": companyId,
  };
}


class Car {
  Car({
    required this.carId,
    required this.shareLink,
    required this.image,
    required this.title,
    required this.year,
    required this.doors,
    required this.seets,
    required this.brandImage,
    required this.description,
    required this.id,
    required this.oldPrice,
    required this.price,
    required this.hotelId,
    required this.options,
    required this.insurance_price,
  });

  int carId;
  String shareLink;
  String image;
  String title;
  String year;
  int doors;
  int seets;
  dynamic brandImage;
  String description;
  int id;
  int oldPrice;
  int price;
  int insurance_price;
  int hotelId;
  List<Option> options;

  factory Car.fromMap(Map<String, dynamic> json) => Car(
    carId: json["car_id"] ?? -1,
    shareLink: json["share_link"] ?? "",
    image: json["image"] ?? "",
    title: json["title"] ?? "",
    year: json["year"] ?? "",
    doors: json["doors"] ?? "",
    seets: json["seets"] ?? "",
    brandImage: json["brand_image"] ?? "",
    description: json["description"] ?? "",
    id: json["id"] ?? -1,
    oldPrice: json["old_price"] ?? -1,
    price: json["price"] ?? -1,
    insurance_price: json["insurance_price"] ?? -1,
    hotelId: json["hotel_id"] ?? -1,
    options: List<Option>.from(json["options"].map((x) => Option.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "car_id": carId,
    "share_link" : shareLink,
    "image": image,
    "title": title,
    "year": year,
    "doors": doors,
    "seets": seets,
    "brand_image": brandImage,
    "description": description,
    "id": id,
    "old_price": oldPrice,
    "price": price,
    "hotel_id": hotelId,
    "options": List<dynamic>.from(options.map((x) => x.toMap())),
  };
}

class Option {
  Option({
    required this.id,
    required this.title,
    required this.color,
    required this.images,
    required this.carId,
  });

  int id;
  String title;
  String color;
  String images;
  int carId;

  factory Option.fromMap(Map<String, dynamic> json) => Option(
    id: json["id"],
    title: json["title"],
    color: json["color"],
    images: json["images"],
    carId: json["car_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "color": color,
    "images": images,
    "car_id": carId,
  };
}
