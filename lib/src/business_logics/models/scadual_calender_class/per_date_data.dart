class PerDateData {
  String? date;
  String? day;
  bool? workingDay;
  bool? leave;
  bool? holiday;
  bool? weekend;
  String? holiday_title;

  PerDateData({this.workingDay, this.leave, this.holiday, this.weekend, this.holiday_title, this.date, this.day});

  PerDateData.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    workingDay = json['working_day'];
    leave = json['leave'];
    holiday = json['holiday'];
    weekend = json['weekend'];
    holiday_title = json['holiday_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    data['working_day'] = this.workingDay;
    data['leave'] = this.leave;
    data['holiday_title'] = this.holiday_title;
    data['holiday'] = this.holiday;
    data['weekend'] = this.weekend;
    return data;
}
}