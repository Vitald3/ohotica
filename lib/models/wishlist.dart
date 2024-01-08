import 'dart:convert';

import 'categories.dart';

class Wishlist {
  int? id;
  String? pid;
  String? name;
  double? price;
  String? imageUrl;
  Categories? category;

  Wishlist({
    this.id,
    this.pid,
    this.name,
    this.price,
    this.imageUrl,
    this.category
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pid': pid,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'category': jsonEncode(category)
    };
  }

  factory Wishlist.fromMap(Map<String, dynamic> json) => Wishlist(
      id: json['id'],
      pid: json['pid'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['image_url'],
      category: Categories.fromJson(jsonDecode(json['category']))
  );

  Wishlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    name = json['name'];
    price = json['price'];
    imageUrl = json['image_url'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pid'] = pid;
    data['name'] = name;
    data['price'] = price;
    data['image_url'] = imageUrl;
    data['category'] = category;
    return data;
  }
}