class HalfDayLeaveModel {
  bool? success;
  String? message;
  Data? data;

  HalfDayLeaveModel({this.success, this.message, this.data});

  HalfDayLeaveModel.fromJson(Map<String, dynamic> json) {
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
  bool? allowHalfDay;
  List<HalfDay>? days;

  Data({this.allowHalfDay, this.days});

  Data.fromJson(Map<String, dynamic> json) {
    allowHalfDay = json['allow_half_day'];
    if (json['days'] != null) {
      days = <HalfDay>[];
      json['days'].forEach((v) {
        days!.add(new HalfDay.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allow_half_day'] = this.allowHalfDay;
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HalfDay {
  int? id;
  String? title;

  HalfDay({this.id, this.title});

  HalfDay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
