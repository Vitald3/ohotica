import 'dart:convert';

import 'categories.dart';

class Cart {
  int? cartId;
  String? pid;
  String? name;
  int? quantity;
  double? price;
  String? size;
  String? sizeName;
  String? imageUrl;
  String? article;
  Categories? category;

  Cart({
    this.cartId,
    this.pid,
    this.name,
    this.quantity,
    this.price,
    this.size,
    this.sizeName,
    this.imageUrl,
    this.article,
    this.category
  });

  Map<String, dynamic> toMap() {
    return {
      'cart_id': cartId,
      'pid': pid,
      'name': name,
      'quantity': quantity,
      'price': price,
      'size': size,
      'size_name': sizeName,
      'image_url': imageUrl,
      'article': article,
      'category': jsonEncode(category)
    };
  }

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
      cartId: json['cart_id'],
      pid: json['pid'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      size: json['size'],
      sizeName: json['size_name'],
      imageUrl: json['image_url'],
      article: json['article'],
      category: Categories.fromJson(jsonDecode(json['category']))
  );

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    pid = json['pid'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    size = json['size'];
    sizeName = json['size_name'];
    imageUrl = json['image_url'];
    article = json['article'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['pid'] = pid;
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    data['size'] = size;
    data['size_name'] = sizeName;
    data['image_url'] = imageUrl;
    data['article'] = article;
    data['category'] = category;
    return data;
  }
}