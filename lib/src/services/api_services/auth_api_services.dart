import 'dart:convert';

import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:team360/src/business_logics/models/login_after_otp_response.dart';
import 'package:team360/src/business_logics/models/login_response_model.dart';
import 'package:team360/src/business_logics/models/otp_verify_response_model.dart';
import 'package:team360/src/business_logics/utils/log_debugger.dart';
import '../../business_logics/models/error_response_model.dart';
import '../../business_logics/models/user_data_model.dart';
import '../../business_logics/utils/constants.dart';
import '../shared_preference_services/shared_preference_services.dart';

class AuthAPIServices {

  final Logger _logger = Logger();



  saveUserData(OTPVerifyResponseModel authModel) {
    if(authModel.data?.token != null) {
      SharedPrefsServices.setStringData("accessToken", authModel.data?.token as String);
      UserData.accessToken = authModel.data?.token;
    }

    SharedPrefsServices.setIntegerData("id", authModel.data?.id ?? 0);
    SharedPrefsServices.setStringData("id_no", authModel.data?.idNo ?? "");
    SharedPrefsServices.setStringData("name", authModel.data?.name ?? "");
    SharedPrefsServices.setStringData("phone", authModel.data?.phone ?? "");
    SharedPrefsServices.setStringData("address", authModel.data?.address ?? "");
    SharedPrefsServices.setStringData("type", authModel.data?.type ?? "");
    SharedPrefsServices.setBooleanData("isLead", authModel.data!.isLead!);
    SharedPrefsServices.setBooleanData("isApprover", authModel.data!.isApprover!);
    //SharedPrefsServices.setStringData("photo", authModel.data?.photo ?? "");


    UserData.id = authModel.data?.id;
    UserData.employeeId = authModel.data?.idNo;
    UserData.name = authModel.data?.name;
    UserData.address = authModel.data?.address;
    UserData.phone = authModel.data?.phone;
    UserData.designation = authModel.data?.type;
    UserData.photo = authModel.data?.image;
    UserData.isLead = authModel.data?.isLead;
    UserData.isApprover = authModel.data?.isApprover;

    //UserData.photo = authModel.photo;

  }

  saveLoginUserData(LoginAfterOtpResponseModel authModel) {
    if(authModel.data?.token != null) {
      SharedPrefsServices.setStringData("accessToken", authModel.data?.token as String);
      UserData.accessToken = authModel.data?.token;
    }

    SharedPrefsServices.setIntegerData("id", authModel.data?.id ?? 0);
    SharedPrefsServices.setStringData("id_no", authModel.data?.idNo ?? "");
    SharedPrefsServices.setStringData("name", authModel.data?.name ?? "");
    SharedPrefsServices.setStringData("phone", authModel.data?.phone ?? "");
    SharedPrefsServices.setStringData("address", authModel.data?.address ?? "");
    SharedPrefsServices.setStringData("type", authModel.data?.type ?? "");
    SharedPrefsServices.setBooleanData("isLead", authModel.data!.isLead!);
    SharedPrefsServices.setBooleanData("isApprover", authModel.data!.isApprover!);
    //SharedPrefsServices.setStringData("photo", authModel.data?.photo ?? "");


    UserData.id = authModel.data?.id;
    UserData.employeeId = authModel.data?.idNo;
    UserData.name = authModel.data?.name;
    UserData.address = authModel.data?.address;
    UserData.phone = authModel.data?.phone;
    UserData.designation = authModel.data?.type;
    UserData.photo = authModel.data?.image;
    UserData.isLead = authModel.data?.isLead;
    UserData.isApprover = authModel.data?.isApprover;

    //UserData.photo = authModel.photo;

  }

  Future<ResponseObject> login({required String username, required String password}) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/auth/login/otp');
      final request = http.Request("POST", uri);

      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';

      request.body = jsonEncode({
        'email': username,
        'password': password
      });

      LogDebugger.instance.i(request.body);

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v('decoded: $decodedJson');
      if (response.statusCode == 200 || response.statusCode == 201) {
        if(decodedJson["data"]["require_send_otp"] == true && decodedJson["data"]["require_change_password"] == true){
          var loginResponse = LoginResponseModel.fromJson(decodedJson);
          return ResponseObject(id: 200, object: loginResponse);
        }else if(decodedJson["data"]["require_send_otp"] == true && decodedJson["data"]["require_change_password"] == false){
          var loginResponse = LoginResponseModel.fromJson(decodedJson);
          return ResponseObject(id: 200, object: loginResponse);
        }else if(decodedJson["data"]["require_send_otp"] == false && decodedJson["data"]["require_change_password"] == true){
          var loginResponse = LoginResponseModel.fromJson(decodedJson);
          return ResponseObject(id: 200, object: loginResponse);
        }else{
          var loginResponse = LoginAfterOtpResponseModel.fromJson(decodedJson);
          saveLoginUserData(loginResponse);
          return ResponseObject(id: 200, object: loginResponse);
        }

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


  // Future<ResponseObject> verifyOTP({required String email, required String otp }) async {
  //
  //   try {
  //     // LogDebugger.instance.wtf();
  //     final _response =
  //     await BaseAPICaller.getRequest('$BASE_URL/auth/login/otp-verify',token: UserData.accessToken;
  //     LogDebugger.instance.i(_response);
  //
  //     if (_response.success) {
  //       var otpRequestResponse = OTPVerifyResponseModel.fromJson(_response.returnValue);
  //
  //       return ResponseObject(
  //           object: otpRequestResponse,
  //           id: ResponseCode.SUCCESSFUL);
  //     } else {
  //       return ResponseObject(
  //           object: _response.errorMessage, id: ResponseCode.FAILED);
  //     }
  //   } catch (e) {
  //     LogDebugger.instance.e(e);
  //     return ResponseObject(object: e.toString(), id: ResponseCode.FAILED);
  //   }
  // }


  Future<ResponseObject> verifyOTP({required String email, required String otp}) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/auth/login/otp-verify');
      final request = http.Request("POST", uri);

      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';

      request.body = jsonEncode({
        'email': email,
        'otp': otp
      });

      LogDebugger.instance.i(request.body);

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v('decoded: $decodedJson');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var otpVeifyResponseModel = OTPVerifyResponseModel.fromJson(decodedJson);
        saveUserData(otpVeifyResponseModel);
        return ResponseObject(id: 200, object: otpVeifyResponseModel);
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
