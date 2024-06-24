// class LeaveRequestResponseModel {
//   bool? success;
//   Null? message;
//   Data? data;
//
//   LeaveRequestResponseModel({this.success, this.message, this.data});
//
//   LeaveRequestResponseModel.fromJson(Map<String, dynamic> json) {
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
//   int? userId;
//   String? leaveTypeId;
//   String? fromDate;
//   String? toDate;
//   String? noOfDays;
//   bool? status;
//   String? remarks;
//   String? updatedAt;
//   String? createdAt;
//
//   Data(
//       {this.id,
//         this.userId,
//         this.leaveTypeId,
//         this.fromDate,
//         this.toDate,
//         this.noOfDays,
//         this.status,
//         this.remarks,
//         this.updatedAt,
//         this.createdAt});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     leaveTypeId = json['leave_type_id'];
//     fromDate = json['from_date'];
//     toDate = json['to_date'];
//     noOfDays = json['no_of_days'];
//     status = json['status'];
//     remarks = json['remarks'];
//     updatedAt = json['updatedAt'];
//     createdAt = json['createdAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['leave_type_id'] = this.leaveTypeId;
//     data['from_date'] = this.fromDate;
//     data['to_date'] = this.toDate;
//     data['no_of_days'] = this.noOfDays;
//     data['status'] = this.status;
//     data['remarks'] = this.remarks;
//     data['updatedAt'] = this.updatedAt;
//     data['createdAt'] = this.createdAt;
//     return data;
//   }
// }

class LeaveRequestResponseModel {
  bool? success;
  String? message;
  Data? data;

  LeaveRequestResponseModel({this.success, this.message, this.data});

  LeaveRequestResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? count;
  int? totalPage;
  List<Leaves>? leaves;

  Data({this.count, this.totalPage, this.leaves});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalPage = json['totalPage'];
    if (json['leaves'] != null) {
      leaves = <Leaves>[];
      json['leaves'].forEach((v) {
        leaves!.add(new Leaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totalPage'] = this.totalPage;
    if (this.leaves != null) {
      data['leaves'] = this.leaves!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  int? id;
  int? userId;
  String? companyId;
  int? leaveTypeId;
  String? fromDate;
  String? toDate;
  int? noOfDays;
  bool? status;
  String? remarks;
  String? files;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  int? user_Id;
  int? leave_Type_Id;
  Users? users;
  LeaveType? leaveType;

  Leaves(
      {this.id,
        this.userId,
        this.companyId,
        this.leaveTypeId,
        this.fromDate,
        this.toDate,
        this.noOfDays,
        this.status,
        this.remarks,
        this.files,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user_Id,
        this.leave_Type_Id,
        this.users,
        this.leaveType});

  Leaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    leaveTypeId = json['leave_type_id'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    noOfDays = json['no_of_days'];
    status = json['status'];
    remarks = json['remarks'];
    files = json['files'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    userId = json['UserId'];
    leaveTypeId = json['LeaveTypeId'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    leaveType = json['leaveType'] != null
        ? new LeaveType.fromJson(json['leaveType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['leave_type_id'] = this.leaveTypeId;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['no_of_days'] = this.noOfDays;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['files'] = this.files;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['UserId'] = this.userId;
    data['LeaveTypeId'] = this.leaveTypeId;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    if (this.leaveType != null) {
      data['leaveType'] = this.leaveType!.toJson();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? type;
  String? phone;
  String? email;
  String? password;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Users(
      {this.id,
        this.name,
        this.type,
        this.phone,
        this.email,
        this.password,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}

class LeaveType {
  int? id;
  String? companyId;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  LeaveType(
      {this.id,
        this.companyId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  LeaveType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}

