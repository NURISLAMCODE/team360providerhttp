class ProfileResponseModel {
  bool? success;
  String? message;
  Data? data;

  ProfileResponseModel({this.success, this.message, this.data});

  ProfileResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? type;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Employee? employee;

  Data(
      {this.id,
        this.name,
        this.type,
        this.phone,
        this.email,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.employee});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    phone = json['phone'];
    email = json['email'];
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
  int? userid;
  int? officedivisionid;
  int? departmentid;
  int? jobtypeid;
  int? designationid;
  Departments? departments;
  OfficeDivisions? officeDivisions;
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
        this.userid,
        this.officedivisionid,
        this.departmentid,
        this.jobtypeid,
        this.designationid,
        this.departments,
        this.officeDivisions,
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
    userId = json['UserId'];
    officeDivisionId = json['OfficeDivisionId'];
    departmentId = json['DepartmentId'];
    jobTypeId = json['JobTypeId'];
    designationId = json['DesignationId'];
    departments = json['departments'] != null
        ? new Departments.fromJson(json['departments'])
        : null;
    officeDivisions = json['officeDivisions'] != null
        ? new OfficeDivisions.fromJson(json['officeDivisions'])
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
    data['UserId'] = this.userId;
    data['OfficeDivisionId'] = this.officeDivisionId;
    data['DepartmentId'] = this.departmentId;
    data['JobTypeId'] = this.jobTypeId;
    data['DesignationId'] = this.designationId;
    if (this.departments != null) {
      data['departments'] = this.departments!.toJson();
    }
    if(this.officeDivisions != null) {
      data['officeDivisions'] = this.officeDivisions!.toJson();
    }
    if(this.designations != null){
      data['designations'] = this.designations!.toJson();
    }
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
  int? officedivisionid;
  int? office_division_id;

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
        this.officedivisionid,
        this.office_division_id});

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
    officeDivisionId = json['OfficeDivisionId'];
    officeDivisionId = json['officeDivisionId'];
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
    data['OfficeDivisionId'] = this.officeDivisionId;
    data['officeDivisionId'] = this.officeDivisionId;
    return data;
  }
}