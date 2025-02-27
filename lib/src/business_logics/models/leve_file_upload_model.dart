class LeveFileUploadModel {
  bool? success;
  String? message;
  String? data;

  LeveFileUploadModel({this.success, this.message, this.data});

  LeveFileUploadModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
