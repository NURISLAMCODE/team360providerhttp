class AllNoticeResponseModel {
  bool? success;
  String? message;
  Data? data;

  AllNoticeResponseModel({this.success, this.message, this.data});

  AllNoticeResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<Notices>? notices;

  Data({this.count, this.totalPage, this.notices});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalPage = json['totalPage'];
    if (json['notices'] != null) {
      notices = <Notices>[];
      json['notices'].forEach((v) {
        notices!.add(new Notices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totalPage'] = this.totalPage;
    if (this.notices != null) {
      data['notices'] = this.notices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notices {
  int? id;
  int? officeDivisionId;
  int? departmentId;
  String? companyId;
  int? noticeTypeId;
  String? fromDate;
  String? toDate;
  String? notice;
  bool? status;
  int? userId;
  String? createdAtUnix;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? DepartmentId;
  int? OfficeDivisionId;
  int? UserId;
  Users? users;
  OfficeDivisions? officeDivisions;
  //List<AllDepartments>? departments;
  AllDepartments? departments;
  AllNoticeType? noticeType;

  Notices(
      {this.id,
        this.officeDivisionId,
        this.departmentId,
        this.companyId,
        this.noticeTypeId,
        this.fromDate,
        this.toDate,
        this.notice,
        this.status,
        this.userId,
        this.createdAtUnix,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.DepartmentId,
        this.OfficeDivisionId,
        this.UserId,
        this.users,
        this.departments,
        this.noticeType,this.officeDivisions});

  Notices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    officeDivisionId = json['office_division_id'];
    departmentId = json['department_id'];
    companyId = json['company_id'];
    noticeTypeId = json['notice_type_id'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    notice = json['notice'];
    status = json['status'];
    userId = json['user_id'];
    createdAtUnix = json['created_at_unix'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    DepartmentId = json['DepartmentId'];
    OfficeDivisionId = json['OfficeDivisionId'];
    UserId = json['UserId'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    // if (json['departments'] != null) {
    //   departments = <AllDepartments>[];
    //   json['departments'].forEach((v) {
    //     departments!.add(new AllDepartments.fromJson(v));
    //   });
    // }
    departments = json['departments'] != null
        ? new AllDepartments.fromJson(json['departments'])
        : null;
    noticeType = json['noticeType'] != null
        ? new AllNoticeType.fromJson(json['noticeType'])
        : null;
    officeDivisions = json['officeDivisions'] != null
        ? new OfficeDivisions.fromJson(json['officeDivisions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['office_division_id'] = this.officeDivisionId;
    data['department_id'] = this.departmentId;
    data['company_id'] = this.companyId;
    data['notice_type_id'] = this.noticeTypeId;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['notice'] = this.notice;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['created_at_unix'] = this.createdAtUnix;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['DepartmentId'] = this.DepartmentId;
    data['OfficeDivisionId'] = this.OfficeDivisionId;
    data['UserId'] = this.UserId;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    // if (this.departments != null) {
    //   data['departments'] = this.departments!.map((v) => v.toJson()).toList();
    // }
    if (this.departments != null) {
      data['departments'] = this.departments!.toJson();
    }
    if (this.noticeType != null) {
      data['noticeType'] = this.noticeType!.toJson();
    }
    if (this.officeDivisions != null) {
      data['officeDivisions'] = this.officeDivisions!.toJson();
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
  bool? requireChangePassword;
  bool? isFirstUser;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Users(
      {this.id,
        this.name,
        this.type,
        this.phone,
        this.email,
        this.password,
        this.requireChangePassword,
        this.isFirstUser,
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
    requireChangePassword = json['require_change_password'];
    isFirstUser = json['is_first_user'];
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
    data['require_change_password'] = this.requireChangePassword;
    data['is_first_user'] = this.isFirstUser;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}

class AllDepartments {
  int? id;
  String? companyId;
  int? office_division_id;
  String? name;
  String? email;
  String? logo;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? OfficeDivisionId;
  int? officeDivisionId;

  AllDepartments(
      {this.id,
        this.companyId,
        this.office_division_id,
        this.name,
        this.email,
        this.logo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.OfficeDivisionId,
        this.officeDivisionId});

  AllDepartments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    office_division_id = json['office_division_id'];
    name = json['name'];
    email = json['email'];
    logo = json['logo'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    OfficeDivisionId = json['OfficeDivisionId'];
    officeDivisionId = json['officeDivisionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['office_division_id'] = this.office_division_id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['OfficeDivisionId'] = this.OfficeDivisionId;
    data['officeDivisionId'] = this.officeDivisionId;
    return data;
  }
}

class OfficeDivisions {
  int? id;
  String? companyId;
  String? name;
  String? email;
  String? logo;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  OfficeDivisions(
      {this.id,
        this.companyId,
        this.name,
        this.email,
        this.logo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  OfficeDivisions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    email = json['email'];
    logo = json['logo'];
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
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}



class AllNoticeType {
  int? id;
  int? companyId;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  AllNoticeType(
      {this.id,
        this.companyId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  AllNoticeType.fromJson(Map<String, dynamic> json) {
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
