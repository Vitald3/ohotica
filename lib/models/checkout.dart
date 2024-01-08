import 'package:ohotika/models/product.dart';

class Checkout {
  String? name;
  String? phone;
  String? code;
  int? platform;
  int? paymentMethod;
  int? shippingTotal;
  int? productTotal;
  int? rewardTotal;
  int? total;
  List<CheckoutProducts>? products;

  Checkout({this.name, this.phone, this.platform, this.code, this.paymentMethod, this.shippingTotal, this.productTotal, this.rewardTotal, this.total, this.products});

  Checkout.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    if (json['payment_method'] != null) {
      paymentMethod = json['payment_method'];
    }
    if (json['shipping_total'] != null) {
      shippingTotal = json['shipping_total'];
    }
    if (json['product_total'] != null) {
      productTotal = json['product_total'];
    }
    if (json['reward_total'] != null) {
      rewardTotal = json['reward_total'];
    }
    if (json['total'] != null) {
      total = json['total'];
    }
    if (json['platform'] != null) {
      platform = json['platform'];
    }
    if (json['code'] != null) {
      code = json['code'];
    }
    if (json['products'] != null) {
      products = <CheckoutProducts>[];
      json['products'].forEach((v) { products!.add(CheckoutProducts.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod;
    }
    if (shippingTotal != null) {
      data['shipping_total'] = shippingTotal;
    }
    if (productTotal != null) {
      data['product_total'] = productTotal;
    }
    if (rewardTotal != null) {
      data['reward_total'] = rewardTotal;
    }
    if (total != null) {
      data['total'] = total;
    }
    if (platform != null) {
      data['platform'] = platform;
    }
    if (code != null) {
      data['code'] = code;
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckoutProducts {
  String? id;
  String? name;
  int? quantity;
  Sizes? size;

  CheckoutProducts({this.id, this.name, this.quantity, this.size});

  CheckoutProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    if (json['size'] != null) {
      size = json['size'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['quantity'] = quantity;
    if (size != null) {
      data['size'] = size;
    }
    return data;
  }
}