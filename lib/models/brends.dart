class Brands {
  List<String>? brands;

  Brands({this.brands});

  Brands.fromJson(Map<String, dynamic> json) {
    brands = json['Brendy'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Brendy'] = brands;
    return data;
  }
}