import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:team360/src/views/ui/login/login.dart';

import '../../app.dart';
import '../../business_logics/utils/log_debugger.dart';
import '../../views/widgets/scaffold_message.dart';
import '../shared_preference_services/shared_preference_services.dart';

class RequestReturnObject {
  bool success;
  dynamic returnValue;
  String errorMessage;
  int responseCode;

  RequestReturnObject({required this.errorMessage, required this.returnValue, required this.success, required this.responseCode});
}

class BaseAPICaller {

  BaseAPICaller._internal();

  // get api caller
  static Future<RequestReturnObject> getRequest(String url, {String? token}) async{
    try {
      Uri uri = Uri.parse(url);
      LogDebugger.instance.i(url);
      final _request =  http.MultipartRequest('GET', uri);
      _request.headers['Accept'] = 'application/json';
      _request.headers['Authorization'] = 'Bearer $token';
      final _response = await _request.send();
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        final _responseData = await _response.stream.transform(utf8.decoder).join();
        final decodedJson = json.decode(_responseData);
        print(decodedJson);
        // LogDebugger.instance.w(decodedJson);
        return RequestReturnObject(
            errorMessage: '',
            returnValue: decodedJson,
            success: true,
            responseCode: _response.statusCode);
      } else if (_response.statusCode == 401) {
        moveToLogin();
        return RequestReturnObject(
            errorMessage: 'Response code ${_response.statusCode}',
            returnValue: '',
            success: false,
            responseCode: _response.statusCode);
      } else {
        final _responseData = await _response.stream.transform(utf8.decoder).join();
        final decodedJson = json.decode(_responseData);
        LogDebugger.instance.w(decodedJson);
        // LogDebugger.instance.e(e);
        return RequestReturnObject(
            errorMessage: 'Response code ${_response.statusCode}',
            returnValue: decodedJson,
            success: false,
            responseCode: _response.statusCode);
      }
    } catch (e) {
      LogDebugger.instance.e(e);
      return RequestReturnObject(errorMessage: e.toString(), returnValue: "", success: false, responseCode: 400);
    }
  }

  // post api caller
  static Future<RequestReturnObject> postRequest(String url, Map<String, dynamic> data, {String? token, Iterable<http.MultipartFile>? images, bool? isLogin}) async{
    try {
      LogDebugger.instance.wtf(data);
      Uri uri = Uri.parse(url);
      final _request =  http.Request('POST', uri);
      _request.headers['Accept'] = 'application/json';
      _request.headers['Content-Type'] = 'application/json';
      if (token != null) _request.headers['Authorization'] = 'Bearer $token';
      _request.body = json.encode(data);
      final _response = await _request.send();
      LogDebugger.instance.w(token);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        final _responseData = await _response.stream.transform(utf8.decoder).join();
        final decodedJson = json.decode(_responseData);
        LogDebugger.instance.w(decodedJson);
        return RequestReturnObject(errorMessage: '', returnValue:  decodedJson, success: true, responseCode: _response.statusCode);
      } else if (_response.statusCode == 401) {
        if(isLogin != true) {
          moveToLogin();
        }
        return RequestReturnObject(
            errorMessage: 'Unauthorized',
            returnValue: '',
            success: false,
            responseCode: _response.statusCode);
      } else {
        final _responseData = await _response.stream.transform(utf8.decoder).join();
        final decodedJson = json.decode(_responseData);
        LogDebugger.instance.w(decodedJson);
        return RequestReturnObject(errorMessage: 'Status code ${_response.statusCode}', returnValue: decodedJson, success: false, responseCode: _response.statusCode);
      }
    } catch (e) {
      return RequestReturnObject(errorMessage: e.toString(), returnValue: "", success: false, responseCode: 400);
    }
  }

  // post api caller
  static Future<RequestReturnObject> postMultiPartRequest(String url, Map<String, String> data, {String? token, Iterable<http.MultipartFile>? images}) async{
    try {
      LogDebugger.instance.wtf(data);
      LogDebugger.instance.i("File");
      Uri uri = Uri.parse(url);
      final _request =  http.MultipartRequest('POST', uri);
      _request.headers['Accept'] = 'application/json';
      _request.headers['Content-Type'] = 'application/json';
      if (token != null) _request.headers['Authorization'] = 'Bearer $token';
      _request.fields.addAll(data);
      print('---' + images!.length.toString());
      _request.files.addAll(images);
      LogDebugger.instance.i(_request.files);
      final _response = await _request.send();
      LogDebugger.instance.w(_response.statusCode);
      LogDebugger.instance.w(token);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        final _responseData = await _response.stream.transform(utf8.decoder).join();
        final decodedJson = json.decode(_responseData);
        LogDebugger.instance.w(decodedJson);
        return RequestReturnObject(errorMessage: '', returnValue:  decodedJson, success: true, responseCode: _response.statusCode);
      } else if (_response.statusCode == 401) {
        moveToLogin();
        return RequestReturnObject(
            errorMessage: 'Response code ${_response.statusCode}',
            returnValue: '',
            success: false,
            responseCode: _response.statusCode);
      } else {
        final _responseData = await _response.stream.transform(utf8.decoder).join();
        final decodedJson = json.decode(_responseData);
        LogDebugger.instance.w(decodedJson);
        return RequestReturnObject(errorMessage: 'Status code ${_response.statusCode}', returnValue: decodedJson, success: false, responseCode: _response.statusCode);
      }
    } catch (e) {
      LogDebugger.instance.e(e);
      return RequestReturnObject(errorMessage: e.toString(), returnValue: "", success: false, responseCode: 400);
    }
  }

  // if token expires then it will move to the login screen
  static void moveToLogin() async {
    await SharedPrefsServices.setStringData('token', '');
    showScaffoldMessage(App.navigatorKey.currentState!.context, 'Your token has been expired! Please login again.');
    Navigator.pushAndRemoveUntil(App.navigatorKey.currentState!.context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
  }
}