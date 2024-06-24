class NoticeData {
  bool? success;
  String? message;
  Data? data;

  NoticeData({this.success, this.message, this.data});

  NoticeData.fromJson(Map<String, dynamic> json) {
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
  List<NoticeType>? noticeType;

  Data({this.count, this.totalPage, this.noticeType});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalPage = json['totalPage'];
    if (json['noticeType'] != null) {
      noticeType = <NoticeType>[];
      json['noticeType'].forEach((v) {
        noticeType!.add(new NoticeType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totalPage'] = this.totalPage;
    if (this.noticeType != null) {
      data['noticeType'] = this.noticeType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NoticeType {
  int? id;
  int? companyId;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  NoticeType(
      {this.id,
        this.companyId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  NoticeType.fromJson(Map<String, dynamic> json) {
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
