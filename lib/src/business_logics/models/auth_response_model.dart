class AuthResponseModel {
  User? user;
  bool? success;
  String? accessToken;
  String? tokenType;
  int? expiresIn;

  AuthResponseModel(
      {this.user,
        this.success,
        this.accessToken,
        this.tokenType,
        this.expiresIn});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    success = json['success'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['success'] = success;
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? employeeId;
  String? email;
  String? username;
  String? phone;
  String? address;
  String? photo;
  String? url;
  String? imagePath;

  User(
      {this.id,
        this.name,
        this.employeeId,
        this.email,
        this.username,
        this.phone,
        this.address,
        this.photo,
        this.url,
        this.imagePath});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    employeeId = json['employee_id'];
    email = json['email'];
    username = json['username'];
    phone = json['phone'];
    address = json['address'];
    photo = json['photo'];
    url = json['url'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['employee_id'] = employeeId;
    data['email'] = email;
    data['username'] = username;
    data['phone'] = phone;
    data['address'] = address;
    data['photo'] = photo;
    data['url'] = url;
    data['image_path'] = imagePath;
    return data;
  }
}
