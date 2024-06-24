import 'package:team360/src/business_logics/models/auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:team360/src/business_logics/models/leave_request_response_model.dart';
import 'package:team360/src/business_logics/models/login_response_model.dart';
import 'package:team360/src/business_logics/models/otp_verify_response_model.dart';

import '../../services/repository.dart';
import '../models/api_response_object.dart';
import '../models/attendance_check_in_response_model.dart';
import '../models/attendence_requst_model.dart';
import '../models/error_response_model.dart';

class AttendaceProvider extends ChangeNotifier {

  bool _inProgress = false, _isError = false;
  ErrorResponseModel? _errorResponse;

  AttandanceCheckInRespnseModel? _checkInResponseModel;
  AttendanceCheckOutRequstModel? _attendanceRequstModel;

  bool get inProgress => _inProgress;
  bool get isError => _isError;

  ErrorResponseModel? get errorResponse => _errorResponse;
  AttendanceCheckOutRequstModel? get attendanceRequstModel => _attendanceRequstModel;
  AttandanceCheckInRespnseModel? get attandanceCheckInRespnseModel => _checkInResponseModel;



  Future<bool> attendanceInRequestProvider({required String time,  required String location,String? remarks}) async {
    try {
      final response = await repository.attandanceInRequestAPI(time: time,location: location, remarks: remarks);
      if (response?.id == ResponseCode.SUCCESSFUL) {
        _checkInResponseModel = response?.object as AttandanceCheckInRespnseModel;
        return true;
      } else {
        _isError = true;
        _errorResponse = response?.object as ErrorResponseModel;
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<bool> attendanceOutRequestProvider({required String time,  required String location,String? remarks}) async {
    try {
      final response = await repository.attandanceOutRequestAPI(time: time,location: location, remarks: remarks);
      if (response.id == ResponseCode.SUCCESSFUL) {
        _attendanceRequstModel = response.object as AttendanceCheckOutRequstModel;
        return true;
      } else {
        _isError = true;
        _errorResponse = response.object as ErrorResponseModel;
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}