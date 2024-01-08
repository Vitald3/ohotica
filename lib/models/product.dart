class Product {
  String? article;
  String? url;
  String? name;
  String? imageUrl;
  String? imageUrlOriginal;
  String? description;
  String? parentId;
  String? weight;
  String? price;
  int? balance;
  String? vendor;
  String? shopStatus;
  List<Thumbs>? images;
  List<String>? attributes;
  List<Sizes>? sizes;

  Product(
      {this.article,
        this.name,
        this.url,
        this.imageUrl,
        this.imageUrlOriginal,
        this.description,
        this.parentId,
        this.weight,
        this.price,
        this.balance,
        this.vendor,
        this.shopStatus,
        this.images,
        this.attributes,
        this.sizes});

  Product.fromJson(Map<String, dynamic> json) {
    article = json['article'];
    name = json['name'];
    url = json['url'];
    imageUrl = json['imageUrl'];
    imageUrlOriginal = json['imageUrlOriginal'];
    description = json['description'];
    parentId = json['parent_id'];
    weight = json['weight'];
    price = json['price'];
    balance = json['balance'];
    vendor = json['vendor'];
    shopStatus = json['shopStatus'];

    if (json['images'] != null) {
      images = <Thumbs>[];
      json['images'].forEach((v) { images!.add(Thumbs.fromJson(v)); });
    }
    if (json['attributes'] != null) {
      attributes = json['attributes'].cast<String>();
    }
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) { sizes!.add(Sizes.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['article'] = article;
    data['name'] = name;
    data['url'] = url;
    data['imageUrl'] = imageUrl;
    data['imageUrlOriginal'] = imageUrlOriginal;
    data['description'] = description;
    data['parent_id'] = parentId;
    data['weight'] = weight;
    data['price'] = price;
    data['balance'] = balance;
    data['vendor'] = vendor;
    data['shopStatus'] = shopStatus;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (attributes != null) {
      data['attributes'] = attributes;
    }
    if (sizes != null) {
      data['sizes'] = sizes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sizes {
  String? name;
  String? value;

  Sizes({this.name, this.value});

  Sizes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class Thumbs {
  String? thumb;
  String? original;

  Thumbs({this.thumb, this.original});

  Thumbs.fromJson(Map<String, dynamic> json) {
    thumb = json['thumb'];
    original = json['original'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumb'] = thumb;
    data['original'] = original;
    return data;
  }
}