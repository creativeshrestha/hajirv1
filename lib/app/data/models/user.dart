class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  bool? type;
  UserModel({this.id, this.name, this.email, this.phone, this.type});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'];
    type = json['type'] == 'candidate' ? false : true;
    // type = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
