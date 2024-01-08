class ContactResponse {
  bool? success;
  String? error;
  ContactResponseD? contact;

  ContactResponse({
    this.success,
    this.error,
    this.contact
  });

  ContactResponse.fromJson(Map<String, dynamic> json) {
    if (json['success'] != null) {
      success = json['success'];
    }
    if (json['error'] != null) {
      error = json['error'];
    }
    if (json['contact'] != null) {
      contact = ContactResponseD.fromJson(json['contact']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (success != null) {
      data['success'] = success;
    }
    if (error != null) {
      data['error'] = error;
    }
    if (contact != null) {
      data['contact'] = contact;
    }
    return data;
  }
}

class ContactResponseD {
  String? id;
  String? name;
  String? photo;
  String? phone;
  String? email;
  int? reward;

  ContactResponseD({
    this.id,
    this.name,
    this.photo,
    this.phone,
    this.email,
    this.reward
  });

  ContactResponseD.fromJson(Map<String, dynamic> json) {
    if (json['ID'] != null) {
      id = json['ID'];
    }
    if (json['NAME'] != null) {
      name = json['NAME'];
    }
    if (json['PHOTO'] != null) {
      photo = json['PHOTO'];
    }
    if (json['PHONE'] != null) {
      phone = json['PHONE'];
    }
    if (json['EMAIL'] != null) {
      email = json['EMAIL'];
    }
    if (json['reward'] != null) {
      reward = json['reward'];
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
    if (photo != null) {
      data['PHOTO'] = photo;
    }
    if (phone != null) {
      data['PHONE'] = phone;
    }
    if (email != null) {
      data['EMAIL'] = email;
    }
    if (reward != null) {
      data['reward'] = reward;
    }
    return data;
  }
}