import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:team360/src/business_logics/models/all_notice_response_model.dart';
import 'package:team360/src/business_logics/models/create_notice_response_model.dart';
import 'package:team360/src/business_logics/models/error_response_model.dart';
import 'package:team360/src/business_logics/models/notice_model/sub_department_list_class.dart';
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/services/repository.dart';
import 'package:http/http.dart' as http;
import '../models/api_response_object.dart';
import '../models/notice_model/department_list_class.dart';
import '../models/notice_model/notice_type_class.dart';
import '../models/user_data_model.dart';

class AllNoticeProvider extends ChangeNotifier{

  bool _inProgress = false,
      _isError = false;
  bool _profileDataProgress = false;
  ErrorResponseModel? _errorResponse;
  AllNoticeResponseModel? _allNoticeResponseModel;
  CreateNoticeResponseModel? _createNoticeResponseModel;

  bool get inProgress => _inProgress;

  bool get isError => _isError;

  AllNoticeResponseModel? get allNoticeResponseModel => _allNoticeResponseModel;
  CreateNoticeResponseModel? get createNoticeResponseModel => _createNoticeResponseModel;


  Future<bool> getAllNoticeData() async {
    try {
      _profileDataProgress = false;
      notifyListeners();
      final response = await repository.getAllNoticeData();
      if (response.id == 200) {
        _profileDataProgress = false;
        _allNoticeResponseModel = response.object as AllNoticeResponseModel;
        notifyListeners();
        return true;
      } else {
        _profileDataProgress = true;
        _isError = true;
        _errorResponse = response.object as ErrorResponseModel;
        notifyListeners();
        return false;
      }
    }
    catch (e) {
      return false;
    }
  }


  Future<AllNoticeResponseModel?> getAllNoticeInNoticePage() async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/notices/department"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      return AllNoticeResponseModel.fromJson(jsonDecode(response.body));
    }
  }

  Future<void> createNotice({required Map<String,dynamic> data,required Function onSuccess,required Function onFail}) async {
    var response = await http.post(
        Uri.parse("${BASE_URL}/notices"),
        body: jsonEncode(data),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );

    if(response.statusCode == 200){
      onSuccess("Notice Create Successfully");
    }else{
      onFail("${jsonDecode(response.body)["message"]}");
    }
  }

  Future<void> updateNotice({required int id,required Map<String,dynamic> data,required Function onSuccess,required Function onFail}) async {
    var response = await http.patch(
        Uri.parse("${BASE_URL}/notices/${id}"),
        body: jsonEncode(data),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );

    if(response.statusCode == 200){
      onSuccess("Notice Update Successfully");
    }else{
      onFail("${jsonDecode(response.body)["message"]}");
    }
  }

  Future<void> deleteNotice({required int id,required Function onSuccess,required Function onFail}) async {
    var response = await http.delete(
        Uri.parse("${BASE_URL}/notices/${id}"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );

    if(response.statusCode == 200){
      onSuccess("Notice Delete Successfully");
    }else{
      onFail("${jsonDecode(response.body)["message"]}");
    }
  }

  Future<NoticeData?> getAllNoticeType() async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/notice-type"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      return NoticeData.fromJson(jsonDecode(response.body));
    }
  }

  Future<DepartmentListClass?> getAllDepartmentList() async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/office-divisions"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      return DepartmentListClass.fromJson(jsonDecode(response.body));
    }
  }

  Future<SubDepartmentListClass?> getAllSubDepartment(int department_id) async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/departments/by-division/${department_id}"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      return SubDepartmentListClass.fromJson(jsonDecode(response.body));
    }
  }
}