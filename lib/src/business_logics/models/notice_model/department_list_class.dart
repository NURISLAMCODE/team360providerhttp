class DepartmentListClass {
  bool? success;
  String? message;
  Data? data;

  DepartmentListClass({this.success, this.message, this.data});

  DepartmentListClass.fromJson(Map<String, dynamic> json) {
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
  List<Divisions>? divisions;

  Data({this.count, this.totalPage, this.divisions});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalPage = json['totalPage'];
    if (json['divisions'] != null) {
      divisions = <Divisions>[];
      json['divisions'].forEach((v) {
        divisions!.add(new Divisions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totalPage'] = this.totalPage;
    if (this.divisions != null) {
      data['divisions'] = this.divisions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Divisions {
  int? id;
  String? companyId;
  String? name;
  String? email;
  String? logo;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Divisions(
      {this.id,
        this.companyId,
        this.name,
        this.email,
        this.logo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Divisions.fromJson(Map<String, dynamic> json) {
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
