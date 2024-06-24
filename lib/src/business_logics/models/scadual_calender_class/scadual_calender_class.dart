class PerWeekSchedualWork {
  bool? success;
  String? message;
  List<PerWeekSchedualWorkList>? perWeekSchedualWorkList;

  PerWeekSchedualWork({this.success, this.message, this.perWeekSchedualWorkList});

  PerWeekSchedualWork.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      perWeekSchedualWorkList = <PerWeekSchedualWorkList>[];
      json['data'].forEach((v) {
        perWeekSchedualWorkList!.add(new PerWeekSchedualWorkList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.perWeekSchedualWorkList != null) {
      data['data'] = this.perWeekSchedualWorkList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PerWeekSchedualWorkList {
  String? date;
  String? dayName;
  String? startTime;
  String? endTime;
  String? graceInTime;
  String? dutyArea;

  PerWeekSchedualWorkList({this.date,
        this.dayName,
        this.startTime,
        this.endTime,
        this.graceInTime,
        this.dutyArea
      });

  PerWeekSchedualWorkList.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dayName = json['day_Name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    graceInTime = json['grace_in_time'];
    dutyArea = json['duty_area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day_Name'] = this.dayName;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['grace_in_time'] = this.graceInTime;
    data['duty_area']= this.dutyArea;
    return data;
  }
}
