class AllExpensesResponseModel {
  bool? success;
  String? message;
  Data? data;

  AllExpensesResponseModel({this.success, this.message, this.data});

  AllExpensesResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<Expenses>? expenses;

  Data({this.count, this.totalPage, this.expenses});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalPage = json['totalPage'];
    if (json['expenses'] != null) {
      expenses = <Expenses>[];
      json['expenses'].forEach((v) {
        expenses!.add(new Expenses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totalPage'] = this.totalPage;
    if (this.expenses != null) {
      data['expenses'] = this.expenses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expenses {
  int? id;
  String? type;
  String? expenseDate;
  int? totalPerson;
  int? amount;
  int? purposeTypeId;
  String? description;
  String? status;
  String? file;
  int? created_By;
  int? approved_By;
  int? companyId;
  int? reportingToId;
  String? remarks;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<ExpenseDetails>? expenseDetails;
  CreatedBy? createdBy;
  CreatedBy? approvedBy;
  ExpenseCurrency? expenseCurrency;
  Designations? purposeType;

  Expenses(
      {this.id,
        this.type,
        this.expenseDate,
        this.totalPerson,
        this.amount,
        this.purposeTypeId,
        this.description,
        this.status,
        this.file,
        this.created_By,
        this.approved_By,
        this.companyId,
        this.reportingToId,
        this.remarks,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.expenseDetails,
        this.createdBy,
        this.approvedBy,
        this.expenseCurrency,
        this.purposeType});

  Expenses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    expenseDate = json['expense_date'];
    totalPerson = json['total_person'];
    amount = json['amount'];
    purposeTypeId = json['purpose_type_id'];
    description = json['description'];
    status = json['status'];
    file = json['file'];
    created_By = json['created_by'];
    approved_By = json['approved_by'];
    companyId = json['company_id'];
    reportingToId = json['reporting_to_id'];
    remarks = json['remarks'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    if (json['expenseDetails'] != null) {
      expenseDetails = <ExpenseDetails>[];
      json['expenseDetails'].forEach((v) {
        expenseDetails!.add(new ExpenseDetails.fromJson(v));
      });
    }
    expenseCurrency = json['expenseCurrency'] != null ?
        new ExpenseCurrency.fromJson(json['expenseCurrency']) : null ;
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    approvedBy = json['approvedBy'] != null
        ? new CreatedBy.fromJson(json['approvedBy'])
        : null;
    purposeType = json['purposeType'] != null
        ? new Designations.fromJson(json['purposeType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['expense_date'] = this.expenseDate;
    data['total_person'] = this.totalPerson;
    data['amount'] = this.amount;
    data['purpose_type_id'] = this.purposeTypeId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['file'] = this.file;
    data['created_by'] = this.createdBy;
    data['approved_by'] = this.approvedBy;
    data['company_id'] = this.companyId;
    data['reporting_to_id'] = this.reportingToId;
    data['remarks'] = this.remarks;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    if (this.expenseDetails != null) {
      data['expenseDetails'] =
          this.expenseDetails!.map((v) => v.toJson()).toList();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    if (this.approvedBy != null) {
      data['approvedBy'] = this.approvedBy!.toJson();
    }
    if (this.purposeType != null) {
      data['purposeType'] = this.purposeType!.toJson();
    }
    if (this.expenseCurrency != null) {
      data['expenseCurrency'] = this.expenseCurrency!.toJson();
    }
    return data;
  }
}

class ExpenseCurrency {
  int? id;
  String? symbol;
  String? name;
  String? symbolNative;
  String? decimalDigits;
  String? rounding;
  String? code;
  String? namePlural;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ExpenseCurrency(
      {this.id,
        this.symbol,
        this.name,
        this.symbolNative,
        this.decimalDigits,
        this.rounding,
        this.code,
        this.namePlural,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  ExpenseCurrency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    name = json['name'];
    symbolNative = json['symbol_native'];
    decimalDigits = json['decimal_digits'];
    rounding = json['rounding'];
    code = json['code'];
    namePlural = json['name_plural'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['symbol'] = this.symbol;
    data['name'] = this.name;
    data['symbol_native'] = this.symbolNative;
    data['decimal_digits'] = this.decimalDigits;
    data['rounding'] = this.rounding;
    data['code'] = this.code;
    data['name_plural'] = this.namePlural;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}


class ExpenseDetails {
  int? id;
  int? expenseId;
  String? modeOfTransport;
  String? transportType;
  String? source;
  String? destination;
  int? km;
  String? tollNo;
  int? amount;
  String? file;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? ExpenseId;

  ExpenseDetails(
      {this.id,
        this.expenseId,
        this.modeOfTransport,
        this.transportType,
        this.source,
        this.destination,
        this.km,
        this.tollNo,
        this.amount,
        this.file,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.ExpenseId});

  ExpenseDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expenseId = json['expense_id'];
    modeOfTransport = json['mode_of_transport'];
    transportType = json['transport_type'];
    source = json['source'];
    destination = json['destination'];
    km = json['km'];
    tollNo = json['toll_no'];
    amount = json['amount'];
    file = json['file'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    ExpenseId = json['ExpenseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expense_id'] = this.expenseId;
    data['mode_of_transport'] = this.modeOfTransport;
    data['transport_type'] = this.transportType;
    data['source'] = this.source;
    data['destination'] = this.destination;
    data['km'] = this.km;
    data['toll_no'] = this.tollNo;
    data['amount'] = this.amount;
    data['file'] = this.file;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['ExpenseId'] = this.ExpenseId;
    return data;
  }
}

class CreatedBy {
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

  CreatedBy(
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

  CreatedBy.fromJson(Map<String, dynamic> json) {
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
  Designations? designations;
  Departments? departments;

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
        this.designations,
        this.departments});

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
    designations = json['designations'] != null
        ? new Designations.fromJson(json['designations'])
        : null;
    departments = json['departments'] != null
        ? new Departments.fromJson(json['departments'])
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
    if (this.designations != null) {
      data['designations'] = this.designations!.toJson();
    }
    if (this.departments != null) {
      data['departments'] = this.departments!.toJson();
    }
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
  Null? deletedAt;

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
