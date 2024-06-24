import 'dart:convert';
import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:team360/src/business_logics/models/attendence_requst_model.dart';
import 'package:team360/src/business_logics/utils/log_debugger.dart';
import '../../business_logics/models/attendance_check_in_response_model.dart';
import '../../business_logics/models/error_response_model.dart';
import '../../business_logics/models/user_data_model.dart';
import '../../business_logics/utils/constants.dart';

class AttendanceAPIServices {

  final Logger _logger = Logger();


  Future<ResponseObject> checkInRequestAPI({required String time,required String location,String? remarks}) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/attendances/check-in');
      final request = http.Request("POST", uri);

      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer ${UserData.accessToken}';
      print(UserData.accessToken);

      request.body = jsonEncode({
        "time": time,
        "location":location,
        "remarks":remarks
      });
      LogDebugger.instance.i(request.body);

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);

      LogDebugger.instance.i(decodedJson);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var attendanceRequestResponse = AttandanceCheckInRespnseModel.fromJson(decodedJson);
        return ResponseObject(id: 200, object: attendanceRequestResponse);
      } else {
        return ResponseObject(
            id: response.statusCode,
            object: ErrorResponseModel.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.v(e.toString());
      return ResponseObject(id: 500, object: ErrorResponseModel());
    }
  }

  Future<ResponseObject> checkOutRequestAPI({required String time,required String location,String? remarks}) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/attendances/check-out');
      final request = http.Request("POST", uri);

      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer ${UserData.accessToken}';


      request.body = jsonEncode({
        "time": time,
        "location":location,
        "remarks":remarks
      });
      LogDebugger.instance.i(request.body);

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);

      LogDebugger.instance.i(decodedJson);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var attendanceRequestResponse = AttendanceCheckOutRequstModel.fromJson(decodedJson);
        return ResponseObject(id: 200, object: attendanceRequestResponse);
      } else {
        return ResponseObject(
            id: response.statusCode,
            object: ErrorResponseModel.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.v(e.toString());
      return ResponseObject(id: 500, object: ErrorResponseModel());
    }
  }

}
