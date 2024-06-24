class LoginResponseModel {
  bool? success;
  String? message;
  Data? data;

  LoginResponseModel({this.success, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? email;
  bool? requireSendOtp;
  bool? requireChangePassword;
  int? time;
  String? token;

  Data({this.email, this.requireSendOtp, this.time});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    requireSendOtp = json['require_send_otp'];
    requireChangePassword = json['require_change_password'];
    token = json['token'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['require_send_otp'] = this.requireSendOtp;
    data['require_change_password']= this.requireChangePassword;
    data['token'] = this.token;
    data['time'] = this.time;
    return data;
  }
}
