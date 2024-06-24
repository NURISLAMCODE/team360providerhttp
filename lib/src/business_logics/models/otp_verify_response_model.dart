// class OTPVerifyResponseModel {
//   bool? success;
//   String? message;
//   Data? data;
//
//   OTPVerifyResponseModel({this.success, this.message, this.data});
//
//   OTPVerifyResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   String? idNo;
//   String? name;
//   String? type;
//   String? phone;
//   String? address;
//   String? image;
//   bool? isLead;
//   String? token;
//
//   Data(
//       {this.id,
//         this.idNo,
//         this.name,
//         this.type,
//         this.phone,
//         this.address,
//         this.image,
//         this.isLead,
//         this.token});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     idNo = json['id_no'];
//     name = json['name'];
//     type = json['type'];
//     phone = json['phone'];
//     address = json['address'];
//     image = json['image'];
//     isLead = json['is_lead'];
//     token = json['token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['id_no'] = this.idNo;
//     data['name'] = this.name;
//     data['type'] = this.type;
//     data['phone'] = this.phone;
//     data['address'] = this.address;
//     data['image'] = this.image;
//     data['token'] = this.token;
//     data['is_lead'] = this.isLead;
//     return data;
//   }
// }
//

class OTPVerifyResponseModel {
  bool? success;
  String? message;
  Data? data;

  OTPVerifyResponseModel({this.success, this.message, this.data});

  OTPVerifyResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? idNo;
  String? name;
  String? type;
  String? phone;
  bool? requireChangePassword;
  String? address;
  String? image;
  bool? isLead;
  bool? isApprover;
  String? token;

  Data(
      {this.id,
        this.idNo,
        this.name,
        this.type,
        this.phone,
        this.requireChangePassword,
        this.address,
        this.image,
        this.isLead,
        this.isApprover,
        this.token});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idNo = json['id_no'];
    name = json['name'];
    type = json['type'];
    phone = json['phone'];
    requireChangePassword = json['require_change_password'];
    address = json['address'];
    image = json['image'];
    isLead = json['is_lead'];
    isApprover = json['is_approver'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_no'] = this.idNo;
    data['name'] = this.name;
    data['type'] = this.type;
    data['phone'] = this.phone;
    data['require_change_password'] = this.requireChangePassword;
    data['address'] = this.address;
    data['image'] = this.image;
    data['is_lead'] = this.isLead;
    data['is_approver'] = this.isApprover;
    data['token'] = this.token;
    return data;
  }
}
