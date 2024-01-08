class Categories {
  String? id;
  String? parentId;
  String? title;
  String? imageUrl;
  String? iconUrl;

  Categories({this.id, this.parentId, this.title, this.imageUrl, this.iconUrl});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    iconUrl = json['iconUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    data['iconUrl'] = iconUrl;
    return data;
  }
}