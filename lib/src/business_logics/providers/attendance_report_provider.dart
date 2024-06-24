import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:team360/src/business_logics/models/attendence_report_response_model.dart';
import 'package:team360/src/business_logics/models/error_response_model.dart';
import 'package:team360/src/services/repository.dart';
import 'package:http/http.dart' as http;
import '../models/attendence_task_report.dart';
import '../models/user_data_model.dart';
import '../utils/constants.dart';

class AttendanceReportProvider extends ChangeNotifier {
  bool _inProgress = false, _isError = false;
  bool _profileDataProgress = false;
  ErrorResponseModel? _errorResponse;
  AttendanceReportResponseModel? _attendanceReportResponseModel;

  bool get inProgress => _inProgress;

  bool get isError => _isError;

  AttendanceReportResponseModel? get attendanceReportResponseModel =>
      _attendanceReportResponseModel;

  Future<bool> getAttendanceReportData() async {
    try {
      _profileDataProgress = false;
      notifyListeners();
      final response = await repository.getAttendanceReportData();
      if (response.id == 200) {
        _profileDataProgress = false;
        _attendanceReportResponseModel =
            response.object as AttendanceReportResponseModel;
        notifyListeners();
        return true;
      } else {
        _profileDataProgress = true;
        _isError = true;
        _errorResponse = response.object as ErrorResponseModel;
        notifyListeners();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<AttendenceReportClass?> attendenceReport({required int month,required int year}) async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/attendances/current-month?month=${month}&year=${year}"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );

    if(response.statusCode == 200){
      return AttendenceReportClass.fromJson(jsonDecode(response.body));
    }
  }

}
