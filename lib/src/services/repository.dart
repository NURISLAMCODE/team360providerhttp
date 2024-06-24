import 'dart:io';
import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:team360/src/services/api_services/all_notice_api_service.dart';
import 'package:team360/src/services/api_services/attendance_api_service.dart';
import 'package:team360/src/services/api_services/attendance_report_api_service.dart';
import 'package:team360/src/services/api_services/common_api_services.dart';
import 'package:team360/src/services/api_services/leave_api_service.dart';
import 'package:team360/src/services/api_services/user_api_service.dart';

import 'api_services/auth_api_services.dart';
import 'api_services/expenses_api_service.dart';

final repository = _Repository();

class _Repository {
  final AuthAPIServices _authAPIServices = AuthAPIServices();
  final CommonAPIServices _commonAPIServices = CommonAPIServices();
  final LeaveAPIServices _leaveAPIServices = LeaveAPIServices();
  final ExpenseAPIServices _expensesAPIServices = ExpenseAPIServices();
  final AttendanceAPIServices _attendanceAPIServices = AttendanceAPIServices();
  final UserApiService _userApiService = UserApiService();
  final AttendanceReportApiService _attendanceReportApiService =
      AttendanceReportApiService();
  final AllNoticeResponseService _allNoticeResponseService =
      AllNoticeResponseService();

  Future<ResponseObject> login({required String username, required String password}) => _authAPIServices.login(username: username, password: password);
  Future<ResponseObject> verifyOTP({required String email, required String otp}) => _authAPIServices.verifyOTP(email: email, otp: otp);
  Future<ResponseObject> leveTypeProvider() => _leaveAPIServices.getLeveTypeApi();
  Future<ResponseObject> getProfileData() => _userApiService.getProfileData();
  Future<ResponseObject> allLeaveTypeProvider() => _leaveAPIServices.getAllLeveTypeApi();
  Future<ResponseObject> leaveRequestAPI({required int id, required String leaveTypeId, required String fromDate, required String toDate, required String noOfDays, String? remarks,String? files}) => _leaveAPIServices.leaveRequestAPI(id: id, leveTypeId: leaveTypeId, fromDate: fromDate, toDate: toDate, noOfDays: noOfDays, remarks: remarks, file: files.toString());
  Future<ResponseObject> applicantFileUpload({required File image}) => _leaveAPIServices.applicantFileUpload(image);
  Future<ResponseObject> attandanceInRequestAPI({required String time, required String location, String? remarks}) => _attendanceAPIServices.checkInRequestAPI(time: time, location: location, remarks: remarks);
  Future<ResponseObject> attandanceOutRequestAPI({required String time, required String location, String? remarks}) => _attendanceAPIServices.checkOutRequestAPI(time: time, location: location, remarks: remarks);
  Future<ResponseObject> allExpensesTypeProvider(String startDate,String endDate) => _expensesAPIServices.getAlExpensesTypeApi(startDate,endDate);
  Future<ResponseObject> getAttendanceReportData() => _attendanceReportApiService.getAttendanceReportData();
  Future<ResponseObject> getAllNoticeData() => _allNoticeResponseService.getAllNoticeData();
  Future<ResponseObject> createNoticeProvider({required String fromDate, required String toDate, required String type, required String notice}) => _allNoticeResponseService.createNoticeAPI(fromDate: fromDate, toDate: toDate, type: type, notice: notice);
  Future<ResponseObject> profileUpdateProvider(
      {String? name,
          String? phone,
          String? email,
          String? gender,
          String? image,
          String? emergencyContact,
          String? bloodGroup}) =>
      _userApiService.updateProfileAPI(
          name: name,
          phone: phone,
          email: email,
          gender: gender,
          image: image,
          emergencyContact: emergencyContact,
          bloodGroup: bloodGroup);
}
