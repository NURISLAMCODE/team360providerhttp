class LeaveTypeResponseModel {
  bool? success;
  Null? message;
  Data? data;

  LeaveTypeResponseModel({this.success, this.message, this.data});

  LeaveTypeResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<LeaveTypes>? leaveTypes;

  Data({this.count, this.totalPage, this.leaveTypes});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalPage = json['totalPage'];
    if (json['leaveTypes'] != null) {
      leaveTypes = <LeaveTypes>[];
      json['leaveTypes'].forEach((v) {
        leaveTypes!.add(new LeaveTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totalPage'] = this.totalPage;
    if (this.leaveTypes != null) {
      data['leaveTypes'] = this.leaveTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveTypes {
  int? id;
  String? companyId;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  LeaveTypes(
      {this.id,
        this.companyId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  LeaveTypes.fromJson(Map<String, dynamic> json) {
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
