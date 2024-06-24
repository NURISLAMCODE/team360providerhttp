class AttendenceReportClass {
  bool? success;
  String? message;
  Data? data;

  AttendenceReportClass({this.success, this.message, this.data});

  AttendenceReportClass.fromJson(Map<String, dynamic> json) {
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
  List<Result>? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? date;
  String? day;
  bool? isPresent;
  bool? isDalay;
  bool? isEarlyLeave;
  bool? isAbsent;
  bool? isLeave;
  bool? isHoliday;
  List<Attendance>? attendance;

  Result(
      {this.date,
        this.day,
        this.isPresent,
        this.isDalay,
        this.isEarlyLeave,
        this.isAbsent,
        this.isLeave,
        this.isHoliday,
        this.attendance});

  Result.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    isPresent = json['is_present'];
    isDalay = json['is_dalay'];
    isEarlyLeave = json['is_early_leave'];
    isAbsent = json['is_absent'];
    isLeave = json['is_leave'];
    isHoliday = json['is_holiday'];
    if (json['attendance'] != null) {
      attendance = <Attendance>[];
      json['attendance'].forEach((v) {
        attendance!.add(new Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['is_present'] = this.isPresent;
    data['is_dalay'] = this.isDalay;
    data['is_early_leave'] = this.isEarlyLeave;
    data['is_absent'] = this.isAbsent;
    data['is_leave'] = this.isLeave;
    data['is_holiday'] = this.isHoliday;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  int? id;
  int? userId;
  int? officeDivisionId;
  int? departmentId;
  int? employeeId;
  String? companyId;
  String? checkIn;
  String? checkOut;
  String? checkInTime;
  String? checkOutTime;
  String? checkInRemarks;
  String? checkOutRemarks;
  String? checkInLocation;
  String? checkOutLocation;
  bool? lateCount;
  int? lateInMinutes;
  String? overtime;
  bool? earlyCheckoutCount;
  bool? isPresent;
  bool? isAbsent;
  bool? isLeave;
  bool? isHoliday;
  String? actionDate;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? UserId;
  int? OfficeDivisionId;
  int? DepartmentId;
  int? EmployeeId;

  Attendance(
      {this.id,
        this.userId,
        this.officeDivisionId,
        this.departmentId,
        this.employeeId,
        this.companyId,
        this.checkIn,
        this.checkOut,
        this.checkInTime,
        this.checkOutTime,
        this.checkInRemarks,
        this.checkOutRemarks,
        this.checkInLocation,
        this.checkOutLocation,
        this.lateCount,
        this.lateInMinutes,
        this.overtime,
        this.earlyCheckoutCount,
        this.isPresent,
        this.isAbsent,
        this.isLeave,
        this.isHoliday,
        this.actionDate,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.UserId,
        this.OfficeDivisionId,
        this.DepartmentId,
        this.EmployeeId});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    officeDivisionId = json['office_division_id'];
    departmentId = json['department_id'];
    employeeId = json['employee_id'];
    companyId = json['company_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    checkInRemarks = json['check_in_remarks'];
    checkOutRemarks = json['check_out_remarks'];
    checkInLocation = json['check_in_location'];
    checkOutLocation = json['check_out_location'];
    lateCount = json['late_count'];
    lateInMinutes = json['late_in_minutes'];
    overtime = json['overtime'];
    earlyCheckoutCount = json['early_checkout_count'];
    isPresent = json['is_present'];
    isAbsent = json['is_absent'];
    isLeave = json['is_leave'];
    isHoliday = json['is_holiday'];
    actionDate = json['action_date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    UserId = json['UserId'];
    OfficeDivisionId = json['OfficeDivisionId'];
    DepartmentId = json['DepartmentId'];
    EmployeeId = json['employeeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['office_division_id'] = this.officeDivisionId;
    data['department_id'] = this.departmentId;
    data['employee_id'] = this.employeeId;
    data['company_id'] = this.companyId;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['check_in_remarks'] = this.checkInRemarks;
    data['check_out_remarks'] = this.checkOutRemarks;
    data['check_in_location'] = this.checkInLocation;
    data['check_out_location'] = this.checkOutLocation;
    data['late_count'] = this.lateCount;
    data['late_in_minutes'] = this.lateInMinutes;
    data['overtime'] = this.overtime;
    data['early_checkout_count'] = this.earlyCheckoutCount;
    data['is_present'] = this.isPresent;
    data['is_absent'] = this.isAbsent;
    data['is_leave'] = this.isLeave;
    data['is_holiday'] = this.isHoliday;
    data['action_date'] = this.actionDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['UserId'] = this.UserId;
    data['OfficeDivisionId'] = this.OfficeDivisionId;
    data['DepartmentId'] = this.DepartmentId;
    data['employeeId'] = this.EmployeeId;
    return data;
  }
}
