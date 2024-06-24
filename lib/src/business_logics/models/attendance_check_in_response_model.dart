class AttandanceCheckInRespnseModel {
  bool? success;
  String? message;
  Data? data;

  AttandanceCheckInRespnseModel({this.success, this.message, this.data});

  AttandanceCheckInRespnseModel.fromJson(Map<String, dynamic> json) {
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
  int? companyId;
  int? userId;
  int? officeDivisionId;
  int? departmentId;
  String? checkIn;
  String? checkInTime;
  String? checkInLocation;
  String? checkInRemarks;
  String? updatedAt;
  String? createdAt;

  Data(
      {this.id,
        this.companyId,
        this.userId,
        this.officeDivisionId,
        this.departmentId,
        this.checkIn,
        this.checkInTime,
        this.checkInLocation,
        this.checkInRemarks,
        this.updatedAt,
        this.createdAt
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    officeDivisionId = json['office_division_id'];
    departmentId = json['department_id'];
    checkIn = json['check_in'];
    checkInTime = json['check_in_time'];
    checkInLocation = json['check_in_location'];
    checkInRemarks = json['check_in_remarks'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['office_division_id'] = this.officeDivisionId;
    data['department_id'] = this.departmentId;
    data['check_in'] = this.checkIn;
    data['check_in_time'] = this.checkInTime;
    data['check_in_location'] = this.checkInLocation;
    data['check_in_remarks'] = this.checkInRemarks;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
