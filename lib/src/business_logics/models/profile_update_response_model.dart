class ProfileUpdateResponseModel {
  bool? success;
  String? message;
  //Data? data;

  ProfileUpdateResponseModel({this.success, this.message, /*this.data*/});

  ProfileUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    //data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    // if (this.data != null) {
    //   data['data'] = this.data!.toJson();
    // }
    return data;
  }
}

// class Data {
//   int? id;
//   String? employeeId;
//   String? name;
//   String? image;
//   String? designation;
//   String? type;
//   int? reportingTo;
//   String? joiningDate;
//   String? dateOfBirth;
//   String? phone;
//   String? gender;
//   Null? departmentId;
//   String? employementType;
//   String? bloodGroup;
//   String? nid;
//   String? nationality;
//   String? maritalStatus;
//   String? religion;
//   String? email;
//   String? password;
//   bool? status;
//   String? address;
//   String? emergencyContactName;
//   String? emergencyContactPhone;
//   String? emergencyContactRelationship;
//   String? createdAt;
//   String? updatedAt;
//   String? deletedAt;
//
//   Data(
//       {this.id,
//         this.employeeId,
//         this.name,
//         this.image,
//         this.designation,
//         this.type,
//         this.reportingTo,
//         this.joiningDate,
//         this.dateOfBirth,
//         this.phone,
//         this.gender,
//         this.departmentId,
//         this.employementType,
//         this.bloodGroup,
//         this.nid,
//         this.nationality,
//         this.maritalStatus,
//         this.religion,
//         this.email,
//         this.password,
//         this.status,
//         this.address,
//         this.emergencyContactName,
//         this.emergencyContactPhone,
//         this.emergencyContactRelationship,
//         this.createdAt,
//         this.updatedAt,
//         this.deletedAt,
//       });
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     employeeId = json['employee_id'];
//     name = json['name'];
//     image = json['image'];
//     designation = json['designation'];
//     type = json['type'];
//     reportingTo = json['reporting_to'];
//     joiningDate = json['joining_date'];
//     dateOfBirth = json['date_of_birth'];
//     phone = json['phone'];
//     gender = json['gender'];
//     departmentId = json['department_id'];
//     employementType = json['employement_type'];
//     bloodGroup = json['blood_group'];
//     nid = json['nid'];
//     nationality = json['nationality'];
//     maritalStatus = json['marital_status'];
//     religion = json['religion'];
//     email = json['email'];
//     password = json['password'];
//     status = json['status'];
//     address = json['address'];
//     emergencyContactName = json['emergency_contact_name'];
//     emergencyContactPhone = json['emergency_contact_phone'];
//     emergencyContactRelationship = json['emergency_contact_relationship'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     deletedAt = json['deletedAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['employee_id'] = this.employeeId;
//     data['name'] = this.name;
//     data['image'] = this.image;
//     data['designation'] = this.designation;
//     data['type'] = this.type;
//     data['reporting_to'] = this.reportingTo;
//     data['joining_date'] = this.joiningDate;
//     data['date_of_birth'] = this.dateOfBirth;
//     data['phone'] = this.phone;
//     data['gender'] = this.gender;
//     data['department_id'] = this.departmentId;
//     data['employement_type'] = this.employementType;
//     data['blood_group'] = this.bloodGroup;
//     data['nid'] = this.nid;
//     data['nationality'] = this.nationality;
//     data['marital_status'] = this.maritalStatus;
//     data['religion'] = this.religion;
//     data['email'] = this.email;
//     data['password'] = this.password;
//     data['status'] = this.status;
//     data['address'] = this.address;
//     data['emergency_contact_name'] = this.emergencyContactName;
//     data['emergency_contact_phone'] = this.emergencyContactPhone;
//     data['emergency_contact_relationship'] = this.emergencyContactRelationship;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['deletedAt'] = this.deletedAt;
//     return data;
//   }
// }
