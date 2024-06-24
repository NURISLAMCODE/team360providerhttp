class NextSevendayWorkSchadual {
  bool? success;
  String? message;
  List<Data>? data;

  NextSevendayWorkSchadual({this.success, this.message, this.data});

  NextSevendayWorkSchadual.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? date;
  String? day;
  bool? workingDay;
  bool? leave;
  bool? holiday;
  bool? weekend;
  String? holidayTitle;

  Data(
      {this.date,
        this.day,
        this.workingDay,
        this.leave,
        this.holiday,
        this.weekend,
        this.holidayTitle});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    workingDay = json['working_day'];
    leave = json['leave'];
    holiday = json['holiday'];
    weekend = json['weekend'];
    holidayTitle = json['holiday_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['working_day'] = this.workingDay;
    data['leave'] = this.leave;
    data['holiday'] = this.holiday;
    data['weekend'] = this.weekend;
    data['holiday_title'] = this.holidayTitle;
    return data;
  }
}
