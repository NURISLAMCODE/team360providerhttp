class CreateNoticeResponseModel {
  bool? success;
  Null? message;
  Data? data;

  CreateNoticeResponseModel({this.success, this.message, this.data});

  CreateNoticeResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? departmentId;
  String? fromDate;
  String? toDate;
  String? type;
  String? notice;
  bool? status;
  String? updatedAt;
  String? createdAt;

  Data(
      {this.id,
        this.departmentId,
        this.fromDate,
        this.toDate,
        this.type,
        this.notice,
        this.status,
        this.updatedAt,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    type = json['type'];
    notice = json['notice'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department_id'] = this.departmentId;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['type'] = this.type;
    data['notice'] = this.notice;
    data['status'] = this.status;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
