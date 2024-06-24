class SubDepartmentListClass {
  bool? success;
  String? message;
  List<SubDepartment>? subDepartment;

  SubDepartmentListClass({this.success, this.message, this.subDepartment});

  SubDepartmentListClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      subDepartment = <SubDepartment>[];
      json['data'].forEach((v) {
        subDepartment!.add(new SubDepartment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.subDepartment != null) {
      data['data'] = this.subDepartment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubDepartment {
  int? id;
  String? companyId;
  int? office_Division_Id;
  String? name;
  String? email;
  String? logo;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? OfficeDivisionId;
  int? officeDivisionId;

  SubDepartment(
      {this.id,
        this.companyId,
        this.office_Division_Id,
        this.name,
        this.email,
        this.logo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.OfficeDivisionId,
        this.officeDivisionId});

  SubDepartment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    office_Division_Id = json['office_division_id'];
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
