class AttendanceReportResponseModel {
  bool? success;
  Null? message;
  List<Data>? data;

  AttendanceReportResponseModel({this.success, this.message, this.data});

  AttendanceReportResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  int? officeDivisionId;
  int? departmentId;
  String? employeeId;
  String? checkIn;
  String? checkOut;
  String? checkInTime;
  String? checkOutTime;
  String? checkInRemarks;
  String? checkOutRemarks;
  String? checkInLocation;
  String? checkOutLocation;
  String? overtime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;


  Data(
      {this.id,
        this.userId,
        this.officeDivisionId,
        this.departmentId,
        this.employeeId,
        this.checkIn,
        this.checkOut,
        this.checkInTime,
        this.checkOutTime,
        this.checkInRemarks,
        this.checkOutRemarks,
        this.checkInLocation,
        this.checkOutLocation,
        this.overtime,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    officeDivisionId = json['office_division_id'];
    departmentId = json['department_id'];
    employeeId = json['employee_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    checkInRemarks = json['check_in_remarks'];
    checkOutRemarks = json['check_out_remarks'];
    checkInLocation = json['check_in_location'];
    checkOutLocation = json['check_out_location'];
    overtime = json['overtime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['office_division_id'] = this.officeDivisionId;
    data['department_id'] = this.departmentId;
    data['employee_id'] = this.employeeId;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['check_in_remarks'] = this.checkInRemarks;
    data['check_out_remarks'] = this.checkOutRemarks;
    data['check_in_location'] = this.checkInLocation;
    data['check_out_location'] = this.checkOutLocation;
    data['overtime'] = this.overtime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
