class MyRequestClass {
  bool? success;
  String? message;
  List<MyRequest>? data;

  MyRequestClass({this.success, this.message, this.data});

  MyRequestClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MyRequest>[];
      json['data'].forEach((v) {
        data!.add(new MyRequest.fromJson(v));
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

class MyRequest {
  int? id;
  String? companyId;
  int? userId;
  int? expenseId;
  int? leaveId;
  String? type;
  String? year;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Expense? expense;
  Leave? leave;
  CreatedBy? user;
  CreatedBy? reportingTo;
  CreatedBy? approver;

  MyRequest(
      {this.id,
        this.companyId,
        this.userId,
        this.expenseId,
        this.leaveId,
        this.type,
        this.year,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.expense,
        this.leave,
        this.user,
        this.reportingTo,
        this.approver});

  MyRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    expenseId = json['expense_id'];
    leaveId = json['leave_id'];
    type = json['type'];
    year = json['year'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    expense = json['expense'] != null ? new Expense.fromJson(json['expense']) : null;
    leave = json['leave'] != null ? new Leave.fromJson(json['leave']) : null;
    user = json['user'] != null ? new CreatedBy.fromJson(json['user']) : null;
    reportingTo = json['reportingTo'] != null ? new CreatedBy.fromJson(json['reportingTo']) : null;
    approver = json['approver'] != null ? new CreatedBy.fromJson(json['approver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['expense_id'] = this.expenseId;
    data['leave_id'] = this.leaveId;
    data['type'] = this.type;
    data['year'] = this.year;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    if (this.expense != null) {
      data['expense'] = this.expense!.toJson();
    }
    if (this.leave != null) {
      data['leave'] = this.leave!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.reportingTo != null) {
      data['reportingTo'] = this.reportingTo!.toJson();
    }
    if (this.approver != null) {
      data['approver'] = this.approver!.toJson();
    }
    return data;
  }
}

class Expense {
  int? id;
  String? type;
  String? expenseDate;
  int? totalPerson;
  int? amount;
  int? purposeTypeId;
  int? expenseCurrencyId;
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
  PurposeType? purposeType;
  ExpenseCurrency? expenseCurrency;
  List<ApproverExpenseDetails>? expenseDetails;
  CreatedBy? approvedBy;
  CreatedBy? createdBy;

  Expense(
      {this.id,
        this.type,
        this.expenseDate,
        this.totalPerson,
        this.amount,
        this.purposeTypeId,
        this.expenseCurrencyId,
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
        this.purposeType,
        this.expenseCurrency,
        this.expenseDetails,
        this.approvedBy,
        this.createdBy});

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    expenseDate = json['expense_date'];
    totalPerson = json['total_person'];
    amount = json['amount'];
    purposeTypeId = json['purpose_type_id'];
    expenseCurrencyId = json['expense_currency_id'];
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
    expenseCurrency = json['expenseCurrency'] !=null
        ? new ExpenseCurrency.fromJson(json['expenseCurrency'])
        : null;
    purposeType = json['purposeType'] != null
        ? new PurposeType.fromJson(json['purposeType'])
        : null;
    if (json['expenseDetails'] != null) {
      expenseDetails = <ApproverExpenseDetails>[];
      json['expenseDetails'].forEach((v) {
        expenseDetails!.add(new ApproverExpenseDetails.fromJson(v));
      });
    }
    approvedBy = json['approvedBy'] != null
        ? new CreatedBy.fromJson(json['approvedBy'])
        : null;
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
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
    data['expense_currency_id'] = this.expenseCurrencyId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['file'] = this.file;
    data['created_by'] = this.created_By;
    data['approved_by'] = this.approved_By;
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
    if(this.approvedBy != null){
      data['approvedBy'] = this.approvedBy!.toJson();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    return data;
  }
}

class ApproverExpenseDetails {
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

  ApproverExpenseDetails(
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

  ApproverExpenseDetails.fromJson(Map<String, dynamic> json) {
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
        this.deletedAt});

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

class PurposeType {
  int? id;
  String? companyId;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  PurposeType(
      {this.id,
        this.companyId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  PurposeType.fromJson(Map<String, dynamic> json) {
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



class Leave {
  int? id;
  int? user_Id;
  int? companyId;
  int? leave_Type_Id;
  String? fromDate;
  String? toDate;
  double? noOfDays;
  String? status;
  String? remarks;
  String? files;
  String? reason;
  int? approved_By;
  int? reportingToId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? userId;
  int? leaveTypeId;
  LeaveType? leaveType;
  CreatedBy? approvedBy;
  CreatedBy? users;

  Leave(
      {this.id,
        this.user_Id,
        this.companyId,
        this.leave_Type_Id,
        this.fromDate,
        this.toDate,
        this.noOfDays,
        this.status,
        this.remarks,
        this.files,
        this.reason,
        this.approved_By,
        this.reportingToId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.userId,
        this.leaveTypeId,
        this.leaveType,
        this.approvedBy,
        this.users});

  Leave.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user_Id = json['user_id'];
    companyId = json['company_id'];
    leave_Type_Id = json['leave_type_id'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    noOfDays = double.parse(json['no_of_days'].toString());
    status = json['status'];
    remarks = json['remarks'];
    files = json['files'];
    reason = json['reason'];
    approved_By = json['approved_by'];
    reportingToId = json['reporting_to_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    userId = json['UserId'];
    leaveTypeId = json['LeaveTypeId'];
    leaveType = json['leaveType'] != null
        ? new LeaveType.fromJson(json['leaveType'])
        : null;
    approvedBy = json['approvedBy'] != null
        ? new CreatedBy.fromJson(json['approvedBy'])
        : null;
    users = json['users'] != null ? new CreatedBy.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.user_Id;
    data['company_id'] = this.companyId;
    data['leave_type_id'] = this.leave_Type_Id;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['no_of_days'] = this.noOfDays;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['files'] = this.files;
    data['reason'] = this.reason;
    data['approved_by'] = this.approved_By;
    data['reporting_to_id'] = this.reportingToId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['UserId'] = this.userId;
    data['LeaveTypeId'] = this.leaveTypeId;
    if (this.leaveType != null) {
      data['leaveType'] = this.leaveType!.toJson();
    }
    if(this.approvedBy != null){
      data['approvedBy'] = this.approvedBy!.toJson();
    }
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    return data;
  }
}

class LeaveType {
  int? id;
  String? companyId;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  LeaveType(
      {this.id,
        this.companyId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  LeaveType.fromJson(Map<String, dynamic> json) {
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
