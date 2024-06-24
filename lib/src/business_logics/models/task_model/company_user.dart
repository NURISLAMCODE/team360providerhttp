class CompanyUser {
  bool? success;
  String? message;
  Data? data;

  CompanyUser({this.success, this.message, this.data});

  CompanyUser.fromJson(Map<String, dynamic> json) {
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
  List<CompanyUsers>? companyUser;

  Data({this.count, this.totalPage, this.companyUser});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalPage = json['totalPage'];
    if (json['users'] != null) {
      companyUser = <CompanyUsers>[];
      json['users'].forEach((v) {
        companyUser!.add(new CompanyUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totalPage'] = this.totalPage;
    if (this.companyUser != null) {
      data['users'] = this.companyUser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyUsers {
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
  Users? companyUser;
  Departments? departments;
  OfficeDivisions? officeDivisions;
  Designations? designations;
  Designations? jobTypes;
  Users? ReportingTo;

  CompanyUsers(
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
        this.companyUser,
        this.departments,
        this.officeDivisions,
        this.designations,
        this.jobTypes,
        this.ReportingTo});

  CompanyUsers.fromJson(Map<String, dynamic> json) {
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
    companyUser = json['users'] != null ? new Users.fromJson(json['users']) : null;
    departments = json['departments'] != null
        ? new Departments.fromJson(json['departments'])
        : null;
    officeDivisions = json['officeDivisions'] != null
        ? new OfficeDivisions.fromJson(json['officeDivisions'])
        : null;
    designations = json['designations'] != null
        ? new Designations.fromJson(json['designations'])
        : null;
    jobTypes = json['jobTypes'] != null
        ? new Designations.fromJson(json['jobTypes'])
        : null;
    ReportingTo = json['reportingTo'] != null
        ? new Users.fromJson(json['reportingTo'])
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
    if (this.companyUser != null) {
      data['users'] = this.companyUser!.toJson();
    }
    if (this.departments != null) {
      data['departments'] = this.departments!.toJson();
    }
    if (this.officeDivisions != null) {
      data['officeDivisions'] = this.officeDivisions!.toJson();
    }
    if (this.designations != null) {
      data['designations'] = this.designations!.toJson();
    }
    if (this.jobTypes != null) {
      data['jobTypes'] = this.jobTypes!.toJson();
    }
    if (this.ReportingTo != null) {
      data['reportingTo'] = this.ReportingTo!.toJson();
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

class Departments {
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

  Departments(
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

  Departments.fromJson(Map<String, dynamic> json) {
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
