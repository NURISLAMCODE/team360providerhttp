class AllLeaveResponseModel {
  bool? success;
  String? message;
  Data? data;

  AllLeaveResponseModel({this.success, this.message, this.data});

  AllLeaveResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? companyId;
  int? leaveTypeId;
  String? fromDate;
  String? toDate;
  double? noOfDays;
  String? status;
  String? remarks;
  String? files;
  String? reason;
  int? approvedBy;
  int? reportingToId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? UserId;
  int? LeaveTypeId;
  Users? users;
  Designations? leaveType;
  ApprovedBy? approvedByUser;

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
        this.reason,
        this.approvedBy,
        this.reportingToId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.UserId,
        this.LeaveTypeId,
        this.users,
        this.leaveType,
        this.approvedByUser});

  Leaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    leaveTypeId = json['leave_type_id'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    noOfDays = double.parse(json['no_of_days'].toString());
    status = json['status'];
    remarks = json['remarks'];
    files = json['files'];
    reason = json['reason'];
    approvedBy = json['approved_by'];
    reportingToId = json['reporting_to_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    UserId = json['UserId'];
    LeaveTypeId = json['LeaveTypeId'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    leaveType = json['leaveType'] != null
        ? new Designations.fromJson(json['leaveType'])
        : null;
    approvedByUser = json['approvedBy'] != null
        ? new ApprovedBy.fromJson(json['approvedBy'])
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
    data['reason'] = this.reason;
    data['approved_by'] = this.approvedBy;
    data['reporting_to_id'] = this.reportingToId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['UserId'] = this.UserId;
    data['LeaveTypeId'] = this.LeaveTypeId;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    if (this.leaveType != null) {
      data['leaveType'] = this.leaveType!.toJson();
    }
    if (this.approvedByUser != null) {
      data['approvedBy'] = this.approvedByUser!.toJson();
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
  Employee? employee;

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
        this.deletedAt,
        this.employee});

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
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
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
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    return data;
  }
}

class Employee {
  int? id;
  int? userId;
  int? companyId;
  String? idNo;
  String? image;
  int? designationId;
  int? reportingTo;
  String? joiningDate;
  String? dateOfBirth;
  String? gender;
  int? officeDivisionId;
  int? departmentId;
  int? jobTypeId;
  String? bloodGroup;
  String? nid;
  String? nationality;
  String? maritalStatus;
  String? religion;
  bool? status;
  String? address;
  String? emergencyContactName;
  String? emergencyContactPhone;
  String? emergencyContactRelationship;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? UserId;
  int? OfficeDivisionId;
  int? DepartmentId;
  int? JobTypeId;
  int? DesignationId;
  Departments? departments;
  Designations? designations;

  Employee(
      {this.id,
        this.userId,
        this.companyId,
        this.idNo,
        this.image,
        this.designationId,
        this.reportingTo,
        this.joiningDate,
        this.dateOfBirth,
        this.gender,
        this.officeDivisionId,
        this.departmentId,
        this.jobTypeId,
        this.bloodGroup,
        this.nid,
        this.nationality,
        this.maritalStatus,
        this.religion,
        this.status,
        this.address,
        this.emergencyContactName,
        this.emergencyContactPhone,
        this.emergencyContactRelationship,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.UserId,
        this.OfficeDivisionId,
        this.DepartmentId,
        this.JobTypeId,
        this.DesignationId,
        this.departments,
        this.designations});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    idNo = json['id_no'];
    image = json['image'];
    designationId = json['designation_id'];
    reportingTo = json['reporting_to'];
    joiningDate = json['joining_date'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    officeDivisionId = json['office_division_id'];
    departmentId = json['department_id'];
    jobTypeId = json['job_type_id'];
    bloodGroup = json['blood_group'];
    nid = json['nid'];
    nationality = json['nationality'];
    maritalStatus = json['marital_status'];
    religion = json['religion'];
    status = json['status'];
    address = json['address'];
    emergencyContactName = json['emergency_contact_name'];
    emergencyContactPhone = json['emergency_contact_phone'];
    emergencyContactRelationship = json['emergency_contact_relationship'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    UserId = json['UserId'];
    OfficeDivisionId = json['OfficeDivisionId'];
    DepartmentId = json['DepartmentId'];
    JobTypeId = json['JobTypeId'];
    DesignationId = json['DesignationId'];
    departments = json['departments'] != null
        ? new Departments.fromJson(json['departments'])
        : null;
    designations = json['designations'] != null
        ? new Designations.fromJson(json['designations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['id_no'] = this.idNo;
    data['image'] = this.image;
    data['designation_id'] = this.designationId;
    data['reporting_to'] = this.reportingTo;
    data['joining_date'] = this.joiningDate;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['office_division_id'] = this.officeDivisionId;
    data['department_id'] = this.departmentId;
    data['job_type_id'] = this.jobTypeId;
    data['blood_group'] = this.bloodGroup;
    data['nid'] = this.nid;
    data['nationality'] = this.nationality;
    data['marital_status'] = this.maritalStatus;
    data['religion'] = this.religion;
    data['status'] = this.status;
    data['address'] = this.address;
    data['emergency_contact_name'] = this.emergencyContactName;
    data['emergency_contact_phone'] = this.emergencyContactPhone;
    data['emergency_contact_relationship'] = this.emergencyContactRelationship;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['UserId'] = this.UserId;
    data['OfficeDivisionId'] = this.OfficeDivisionId;
    data['DepartmentId'] = this.DepartmentId;
    data['JobTypeId'] = this.JobTypeId;
    data['DesignationId'] = this.DesignationId;
    if (this.departments != null) {
      data['departments'] = this.departments!.toJson();
    }
    if (this.designations != null) {
      data['designations'] = this.designations!.toJson();
    }
    return data;
  }
}

class Departments {
  int? id;
  String? companyId;
  int? officeDivisionId;
  String? name;
  String? email;
  String? logo;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? OfficeDivisionId;
  int? office_Division_Id;

  Departments(
      {this.id,
        this.companyId,
        this.officeDivisionId,
        this.name,
        this.email,
        this.logo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.OfficeDivisionId,
        this.office_Division_Id});

  Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    officeDivisionId = json['office_division_id'];
    name = json['name'];
    email = json['email'];
    logo = json['logo'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    OfficeDivisionId = json['OfficeDivisionId'];
    office_Division_Id = json['officeDivisionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['office_division_id'] = this.officeDivisionId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['OfficeDivisionId'] = this.OfficeDivisionId;
    data['officeDivisionId'] = this.office_Division_Id;
    return data;
  }
}

class Designations {
  int? id;
  String? companyId;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Designations(
      {this.id,
        this.companyId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Designations.fromJson(Map<String, dynamic> json) {
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

class ApprovedBy {
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

  ApprovedBy(
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

  ApprovedBy.fromJson(Map<String, dynamic> json) {
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
