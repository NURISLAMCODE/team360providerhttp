import 'dart:convert';

import 'package:team360/src/business_logics/models/auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:team360/src/business_logics/models/login_after_otp_response.dart';
import 'package:team360/src/business_logics/models/login_response_model.dart';
import 'package:team360/src/business_logics/models/otp_verify_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:team360/src/business_logics/models/user_data_model.dart';
import '../../services/repository.dart';
import '../models/api_response_object.dart';
import '../models/error_response_model.dart';
import '../utils/constants.dart';

class AuthProvider extends ChangeNotifier {

  bool _inProgress = false, _isError = false;
  ErrorResponseModel? _errorResponse;
  AuthResponseModel? _authResponse;
  LoginResponseModel? _loginResponse;
  LoginAfterOtpResponseModel? _loginAfterResponseModel;
  OTPVerifyResponseModel? _otpVerifyResponse;

  bool get inProgress => _inProgress;
  bool get isError => _isError;

  ErrorResponseModel? get errorResponse => _errorResponse;
  AuthResponseModel? get authResponse => _authResponse;
  LoginResponseModel? get loginResponse => _loginResponse;
  LoginAfterOtpResponseModel? get loginAfterResponseModel => _loginAfterResponseModel;
  OTPVerifyResponseModel? get otpVerifyResponse => _otpVerifyResponse;

  Future<bool> login({required String username, required String password}) async {
    _inProgress = true;
    _loginResponse = null;
    _loginAfterResponseModel = null;
    notifyListeners();
    final response = await repository.login(username: username, password: password);
    if (response.id == 200) {
      try{
        _inProgress = false;
        _loginResponse = response.object as LoginResponseModel;
        notifyListeners();
        return true;
      }catch (e){
        _inProgress = false;
        _loginAfterResponseModel = response.object as LoginAfterOtpResponseModel;
        notifyListeners();
        return true;
      }
    } else {
      _inProgress = false;
      _isError = true;
      _errorResponse = response.object as ErrorResponseModel;
      notifyListeners();
      return false;
    }
  }

  Future<void> forgotPassword({required Map<String, dynamic> data, required Function onSuccess, required Function onFail}) async{
    try{
      var response = await http.post(Uri.parse("${BASE_URL}/forgot-pass/app"),
          body: jsonEncode(data),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/json",
            // "Authorization": "Bearer ${UserData.accessToken}"
          });
      if(response.statusCode == 200){
        onSuccess(jsonDecode(response.body)["message"]);
      }else{
        onFail(jsonDecode( response.body)["message"]);
      }
    }catch(e){
      print(e.toString());
      onFail(e.toString());
    }
  }
//Sign up
  Future<void> signUp({required Map<String, dynamic> data, required Function onSuccess, required Function onFail}) async{
    try{
      var response = await http.post(Uri.parse("${BASE_URL}/sign-up"),
          body: jsonEncode(data),
          headers: <String, String> {
            "Accept": "application/json",
            "Content-Type": "application/json",
          });
      if(response.statusCode == 200 || response.statusCode == 201){
        onSuccess(jsonDecode(response.body)["message"]);
      }else{
        onFail(jsonDecode(response.body)["message"]);
      }
    }catch(e){
      onFail(e);
    }
}

//forgotPasswordOtp
  Future<void> sendOtpPassword({required Map<String, dynamic> data, required Function onSuccess, required Function onFail}) async{
    try{
      var response = await http.post(Uri.parse("${BASE_URL}/auth/login/otp-verify"),
          body: jsonEncode(data),
          headers: <String, String> {
            "Accept": "application/json",
            "Content-Type": "application/json",
          });
      if(response.statusCode == 200 || response.statusCode == 201){
        onSuccess(jsonDecode(response.body)["message"]);
      }else{
        onFail(jsonDecode(response.body)["message"]);
      }
    }catch(e){
      onFail(e);
    }
  }
//New Login user to set password
  Future<void> setPassword({
  required Map<String, dynamic> data,
    required Function onSuccess,required Function onFail
}) async{
    print(UserData.accessToken);
    try{
      var response = await http.post(Uri.parse("${BASE_URL}/users/app/reset-password"),
      body: jsonEncode(data),
      headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );
      if(response.statusCode == 200  || response.statusCode == 201){
        onSuccess(
          jsonDecode(response.body)["message"]);
        }else{
        onFail(jsonDecode(response.body)["message"]);
      }
    }catch(e){
      onFail(e);
    }
  }
  
  Future<bool> verifyOTP({required String email,required String otp}) async {
    try {
      final response = await repository.verifyOTP(email: email, otp: otp);
      if (response.id == ResponseCode.SUCCESSFUL) {
        _otpVerifyResponse = response.object as OTPVerifyResponseModel;
        notifyListeners();
        return true;
      } else {
        _isError = true;
        _errorResponse = response.object as ErrorResponseModel;
        notifyListeners();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}