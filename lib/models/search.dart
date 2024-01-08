class Search {
  List<SearchCategories>? categories;
  List<SearchProducts>? products;

  Search({this.categories, this.products});

  Search.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <SearchCategories>[];
      json['categories'].forEach((v) {
        categories!.add(SearchCategories.fromJson(v));
      });
    }
    if (json['items'] != null) {
      products = <SearchProducts>[];
      json['items'].forEach((v) {
        products!.add(SearchProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['items'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchCategories {
  String? image;
  String? name;
  String? href;

  SearchCategories({this.image, this.name, this.href});

  SearchCategories.fromJson(Map<String, dynamic> json) {
    image = json['imageUrl'];
    name = json['name'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['href'] = href;
    return data;
  }
}

class SearchProducts {
  String? productId;
  String? parentId;
  String? thumb;
  String? name;
  String? price;
  String? href;

  SearchProducts({this.productId, this.parentId, this.thumb, this.name, this.price, this.href});

  SearchProducts.fromJson(Map<String, dynamic> json) {
    productId = json['id'];
    parentId = json['parent_id'];
    thumb = json['imageUrl'];
    name = json['name'];
    price = json['price'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = productId;
    data['parent_id'] = parentId;
    data['imageUrl'] = thumb;
    data['name'] = name;
    data['price'] = price;
    data['href'] = href;
    return data;
  }
}