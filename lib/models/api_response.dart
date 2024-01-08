class ApiResponse {
  bool? success;
  String? url;
  String? error;
  String? code;
  dynamic contactId;
  Contact? contact;
  int? orderId;
  List<Deals>? activeDeals;
  List<Deals>? historyDeals;

  ApiResponse({this.success, this.url, this.error, this.code, this.contactId, this.contact, this.orderId, this.activeDeals, this.historyDeals});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['active_deals'] != null) {
      activeDeals = <Deals>[];
      json['active_deals'].forEach((v) { activeDeals!.add(Deals.fromJson(v)); });
    }
    if (json['history_deals'] != null) {
      historyDeals = <Deals>[];
      json['history_deals'].forEach((v) { historyDeals!.add(Deals.fromJson(v)); });
    }
    if (json['success'] != null) {
      success = json['success'];
    }
    if (json['url'] != null) {
      url = json['url'];
    }
    if (json['order_id'] != null) {
      orderId = json['order_id'];
    }
    if (json['error'] != null) {
      error = json['error'];
    }
    if (json['code'] != null) {
      code = json['code'];
    }
    if (json['contactId'] != null) {
      contactId = json['contactId'];
    }
    if (json['contact'] != null) {
      contact = Contact.fromJson(json['contact']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (activeDeals != null) {
      data['active_deals'] = activeDeals!.map((v) => v.toJson()).toList();
    }
    if (historyDeals != null) {
      data['history_deals'] = historyDeals!.map((v) => v.toJson()).toList();
    }
    if (success != null) {
      data['success'] = success;
    }
    if (url != null) {
      data['url'] = url;
    }
    if (orderId != null) {
      data['order_id'] = orderId;
    }
    if (error != null) {
      data['error'] = error;
    }
    if (code != null) {
      data['code'] = code;
    }
    if (contactId != null) {
      data['contactId'] = contactId;
    }
    if (contact != null) {
      data['contact'] = contact;
    }
    return data;
  }
}

class Deals {
  String? id;
  String? status;
  String? currencyId;
  String? opportunity;
  String? date;
  String? originId;
  int? reward;
  List<OrderProduct>? items;

  Deals({
    this.id,
    this.status,
    this.currencyId,
    this.opportunity,
    this.date,
    this.originId,
    this.reward,
    this.items
  });

  Deals.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    status = json['STATUS_NAME'];
    currencyId = json['CURRENCY_ID'];
    opportunity = json['OPPORTUNITY'];
    date = json['DATE'];
    originId = json['ORIGIN_ID'];
    reward = json['reward'];
    if (json['ITEMS'] != null) {
      items = <OrderProduct>[];
      json['ITEMS'].forEach((v) {
        items!.add(OrderProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['STATUS_NAME'] = status;
    data['CURRENCY_ID'] = currencyId;
    data['OPPORTUNITY'] = opportunity;
    data['DATE'] = date;
    data['ORIGIN_ID'] = originId;
    data['reward'] = reward;
    if (items != null) {
      data['ITEMS'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderProduct {
  String? id;
  String? name;
  int? price;
  int? quantity;
  String? sku;
  String? image;
  String? size;

  OrderProduct({
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.sku,
    this.image,
    this.size
  });

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    name = json['NAME'];
    price = json['PRICE'];
    quantity = json['QUANTITY'];
    sku = json['SKU_CODE'];
    image = json['IMAGE_URL'];
    size = json['SIZE_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['NAME'] = name;
    data['PRICE'] = price;
    data['QUANTITY'] = quantity;
    data['SKU_CODE'] = sku;
    data['IMAGE_URL'] = image;
    data['SIZE_NAME'] = size;
    return data;
  }
}

class Contact {
  String? id;
  String? name;
  int? reward;
  String? phone;

  Contact({
    this.id,
    this.name,
    this.reward,
    this.phone
  });

  Contact.fromJson(Map<String, dynamic> json) {
    if (json['ID'] != null) {
      id = json['ID'];
    }
    if (json['NAME'] != null) {
      name = json['NAME'];
    }
    if (json['UF_CRM_BONUS_CRM4_BONUS_BALANCE'] != null && json['UF_CRM_BONUS_CRM4_BONUS_BALANCE'] != "") {
      reward = int.parse(json['UF_CRM_BONUS_CRM4_BONUS_BALANCE']);
    }
    if (json['PHONE'] != null && json['PHONE'].isNotEmpty && json['PHONE'][0]['VALUE'] != null) {
      phone = json['PHONE'][0]['VALUE'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['ID'] = id;
    }
    if (name != null) {
      data['NAME'] = name;
    }
    if (reward != null) {
      data['UF_CRM_BONUS_CRM4_BONUS_BALANCE'] = reward;
    }
    if (phone != null) {
      data['PHONE'] = [{'VALUE': phone}];
    }
    return data;
  }
}