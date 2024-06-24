class LeaveReportClass {
  bool? success;
  String? message;
  List<Data>? data;

  LeaveReportClass({this.success, this.message, this.data});

  LeaveReportClass.fromJson(Map<String, dynamic> json) {
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
  String? title;
  double? total;
  double? available;

  Data({this.title, this.total, this.available});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    total = double.parse(json['total'].toString());
    available = double.parse(json['available'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['total'] = this.total;
    data['available'] = this.available;
    return data;
  }
}
