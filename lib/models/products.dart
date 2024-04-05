class Products {
  int? totalCount;
  List<Items>? items;
  List<Filters>? filters;

  Products({this.totalCount, this.items, this.filters});

  Products.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) { items!.add(Items.fromJson(v)); });
    }
    if (json['filters'] != null) {
      filters = <Filters>[];
      json['filters'].forEach((v) { filters!.add(Filters.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalCount'] = totalCount;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (filters != null) {
      data['filters'] = filters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? parentId;
  List<String>? parents;
  List<String>? images;
  String? name;
  String? imageUrl;
  String? price;
  String? vendor;
  String? shopStatus;

  Items({this.id, this.parentId, this.parents, this.name, this.imageUrl, this.images, this.price, this.vendor, this.shopStatus});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    parents = json['parents'].cast<String>();
    if (json['images'] != null) {
      var images2 = <String>[];
      var x = 0;

      for (var i in json['images']) {
        if (x < 12) images2.add(i);
        x++;
      }

      images = images2;
    } else {
      images = [];
    }
    name = json['name'];
    imageUrl = json['imageUrl'];
    price = json['price'];
    vendor = json['vendor'];
    shopStatus = json['shopStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['parents'] = parents;
    data['images'] = images;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['price'] = price;
    data['vendor'] = vendor;
    data['shopStatus'] = shopStatus;
    return data;
  }
}

class Filters {
  String? name;
  String? alias;
  String? min;
  String? max;
  Values? values;

  Filters({this.name, this.alias, this.min, this.max, this.values});

  Filters.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    alias = json['alias'];
    min = json['min'];
    max = json['max'];
    values = json['values'] != null ? Values.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['alias'] = alias;
    data['min'] = min;
    data['max'] = max;
    if (values != null) {
      data['values'] = values!.toJson();
    }
    return data;
  }
}

class Values {
  Map<String, dynamic>? values;

  Values({this.values});

  Values.fromJson(Map<String, dynamic> json) {
    values = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (values != null) {
      values!.forEach((key, value) {
        data['values'][key] = FilterValue.fromJson(value);
      });
    }
    return data;
  }
}

class FilterValue {
  String? alias;
  String? value;

  FilterValue({this.alias, this.value});

  FilterValue.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alias'] = alias;
    data['value'] = value;
    return data;
  }
}