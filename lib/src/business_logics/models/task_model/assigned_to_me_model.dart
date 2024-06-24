  class AssignedToMeModel {
    bool? success;
    String? message;
    Data? data;

    AssignedToMeModel({this.success, this.message, this.data});

    AssignedToMeModel.fromJson(Map<String, dynamic> json) {
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
    List<Tasks>? tasks;

    Data({this.count, this.totalPage, this.tasks});

    Data.fromJson(Map<String, dynamic> json) {
      count = json['count'];
      totalPage = json['totalPage'];
      if (json['tasks'] != null) {
        tasks = <Tasks>[];
        json['tasks'].forEach((v) {
          tasks!.add(new Tasks.fromJson(v));
        });
      }
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['count'] = this.count;
      data['totalPage'] = this.totalPage;
      if (this.tasks != null) {
        data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }

  class Tasks {
    int? id;
    String? title;
    String? description;
    String? dueDate;
    String? file;
    bool? urgent;
    int? createdBy;
    int? companyId;
    bool? reSchedule;
    String? reson;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;
    List<TaskUsers>? taskUsers;
    AssignedTo? assignedTo;

    Tasks(
        {this.id,
          this.title,
          this.description,
          this.dueDate,
          this.file,
          this.urgent,
          this.createdBy,
          this.companyId,
          this.reSchedule,
          this.reson,
          this.createdAt,
          this.updatedAt,
          this.deletedAt,
          this.taskUsers,
          this.assignedTo});

    Tasks.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      title = json['title'];
      description = json['description'];
      dueDate = json['due_date'];
      file = json['file'];
      urgent = json['urgent'];
      createdBy = json['created_by'];
      companyId = json['company_id'];
      reSchedule = json['re_schedule'];
      reson = json['reson'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];
      deletedAt = json['deletedAt'];
      if (json['taskUsers'] != null) {
        taskUsers = <TaskUsers>[];
        json['taskUsers'].forEach((v) {
          taskUsers!.add(new TaskUsers.fromJson(v));
        });
      }
      assignedTo = json['createdBy'] != null
          ? new AssignedTo.fromJson(json['createdBy'])
          : null;
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['title'] = this.title;
      data['description'] = this.description;
      data['due_date'] = this.dueDate;
      data['file'] = this.file;
      data['urgent'] = this.urgent;
      data['created_by'] = this.createdBy;
      data['company_id'] = this.companyId;
      data['re_schedule'] = this.reSchedule;
      data['reson'] = this.reson;
      data['createdAt'] = this.createdAt;
      data['updatedAt'] = this.updatedAt;
      data['deletedAt'] = this.deletedAt;
      if (this.taskUsers != null) {
        data['taskUsers'] = this.taskUsers!.map((v) => v.toJson()).toList();
      }
      if (this.assignedTo != null) {
        data['createdBy'] = this.assignedTo!.toJson();
      }
      return data;
    }
  }

  class TaskUsers {
    int? id;
    int? companyId;
    int? taskId;
    int? assignedTo;
    String? status;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;
    AssignedTo? assignTo;

    TaskUsers(
        {this.id,
          this.companyId,
          this.taskId,
          this.assignedTo,
          this.status,
          this.createdAt,
          this.updatedAt,
          this.deletedAt,
          this.assignTo});

    TaskUsers.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      companyId = json['company_id'];
      taskId = json['task_id'];
      assignedTo = json['assigned_to'];
      status = json['status'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];
      deletedAt = json['deletedAt'];
      assignTo = json['assignedTo'] != null
          ? new AssignedTo.fromJson(json['assignedTo'])
          : null;
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['company_id'] = this.companyId;
      data['task_id'] = this.taskId;
      data['assigned_to'] = this.assignedTo;
      data['status'] = this.status;
      data['createdAt'] = this.createdAt;
      data['updatedAt'] = this.updatedAt;
      data['deletedAt'] = this.deletedAt;
      if (this.assignTo != null) {
        data['assignedTo'] = this.assignTo!.toJson();
      }
      return data;
    }
  }

  class AssignedTo {
    int? id;
    String? name;
    String? type;
    String? phone;
    String? email;
    String? password;
    bool? requireChangePassword;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;
    Employee? employee;

    AssignedTo(
        {this.id,
          this.name,
          this.type,
          this.phone,
          this.email,
          this.password,
          this.requireChangePassword,
          this.createdAt,
          this.updatedAt,
          this.deletedAt,
          this.employee});

    AssignedTo.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      type = json['type'];
      phone = json['phone'];
      email = json['email'];
      password = json['password'];
      requireChangePassword = json['require_change_password'];
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
      OfficeDivisionId = json['OfficeDivisionId'];
      DepartmentId = json['DepartmentId'];
      JobTypeId = json['JobTypeId'];
      DesignationId = json['DesignationId'];
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
      data['OfficeDivisionId'] = this.OfficeDivisionId;
      data['DepartmentId'] = this.DepartmentId;
      data['JobTypeId'] = this.JobTypeId;
      data['DesignationId'] = this.DesignationId;
      if (this.designations != null) {
        data['designations'] = this.designations!.toJson();
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
