import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:team360/src/business_logics/models/task_model/assigned_by_me_model.dart';
import 'package:team360/src/business_logics/models/task_model/assigned_to_me_model.dart';
import 'package:team360/src/business_logics/models/task_model/company_user.dart';
import 'package:http/http.dart' as http;
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/utils/constants.dart';

import '../models/task_model/single_task_details_model.dart';
class TaskProvider extends ChangeNotifier{

  Future<CompanyUser?> getAllCompanyUser()  async {
    var response = await http.get(
      Uri.parse("${BASE_URL}/employee"),
      headers: <String,String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserData.accessToken}',
      }
    );

    if(response.statusCode == 200){
      return CompanyUser.fromJson(jsonDecode(response.body));
    }
  }
  
  Future<void> postTask({required Map<String,dynamic> data, required Function onSuccess ,required Function onFail}) async {
    try{
      var request = await http.post(
        Uri.parse("${BASE_URL}/tasks"),
        body: jsonEncode(data),
        headers: <String,String>{
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${UserData.accessToken}"
        },
      );

      if(request.statusCode == 200){
        onSuccess(jsonDecode(request.body)["message"]);
      }else{
        onFail(jsonDecode(request.body)["message"]);
      }
    } catch(e){
      onFail(e);
    }
  }

  Future<void> updatedTask({required int index,required Map<String,dynamic> data, required Function onSuccess ,required Function onFail}) async {
    try{
      var request = await http.post(
        Uri.parse("${BASE_URL}/tasks/${index}"),
        body: jsonEncode(data),
        headers: <String,String>{
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${UserData.accessToken}"
        },
      );

      if(request.statusCode == 200){
        onSuccess(jsonDecode(request.body)["message"]);
      }else{
        onFail(jsonDecode(request.body)["message"]);
      }
    } catch(e){
      onFail(e);
    }
  }
  

  Future<void> uploadImageFile({required File? filePath, required Function onSuccess, required Function onFail}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("${BASE_URL}/file"));
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      if (UserData.accessToken != null)
        request.headers['Authorization'] = 'Bearer ${UserData.accessToken}';
      request.files.add(
          await http.MultipartFile.fromPath('file', filePath!.path));
      http.StreamedResponse response = await request.send();

      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);


      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(decodedJson["data"]);
      } else {
        onFail(decodedJson["message"]);
      }
    } catch (e) {
      onFail(e.toString());
    }
  }
  
  Future<AssignedByMeModel?> getAssignedByMeTask({
    required String status,
    required String assigned_to,
    required String assigned_date_from,
    required String assigned_date_to,
    required String due_date_from,
    required String due_date_to,
    required String filter_status,
    required String title,
    required String type,
  }) async {
    if(type.isNotEmpty && (title.isNotEmpty || assigned_to != "" || assigned_date_from.isNotEmpty || assigned_date_to.isNotEmpty || filter_status.isNotEmpty || title.isNotEmpty || due_date_from.isNotEmpty || due_date_to.isNotEmpty)){
      print("All filter task");
      print("${BASE_URL}/tasks/filter?type=${type}&title=${title}&assigned_by=${assigned_to}&status=${filter_status}&due_date_from=${assigned_date_from}&due_date_to=${assigned_date_to}");
      var response = await http.get(
          Uri.parse("${BASE_URL}/tasks/filter?type=${type}&title=${title}&assigned_by=${assigned_to}&status=${filter_status}&due_date_from=${assigned_date_from}&due_date_to=${assigned_date_to}"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );

      if(response.statusCode == 200){
        return AssignedByMeModel.fromJson(jsonDecode(response.body));
      }
    }else if(status == "All"){
      print("All task");
      var response = await http.get(
          Uri.parse("${BASE_URL}/tasks/assigned-by-me"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );
      print(jsonDecode(response.body));
      if(response.statusCode == 200){
        return AssignedByMeModel.fromJson(jsonDecode(response.body));
      }
    }else{
      print("New task");
      var response = await http.get(
          Uri.parse("${BASE_URL}/tasks/assigned-by-me?status=${status}"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );

      if(response.statusCode == 200){
        return AssignedByMeModel.fromJson(jsonDecode(response.body));
      }
    }

  }

  Future<AssignedToMeModel?> getAssignedToMeTask({
    required String status,
    required String assigned_to,
    required String assigned_date_from,
    required String assigned_date_to,
    required String due_date_from,
    required String due_date_to,
    required String filter_status,
    required String title,
    required String type,
  }) async {

    if(type.isNotEmpty && (title.isNotEmpty || assigned_to != "" || assigned_date_from.isNotEmpty || assigned_date_to.isNotEmpty || filter_status.isNotEmpty || title.isNotEmpty || due_date_from.isNotEmpty || due_date_to.isNotEmpty)){
      print("All filter task");
      print("${BASE_URL}/tasks/filter?type=${type}&title=${title}&assigned_by=${assigned_to}&status=${filter_status}&due_date_from=${assigned_date_from}&due_date_to=${assigned_date_to}");
      var response = await http.get(
          Uri.parse("${BASE_URL}/tasks/filter?type=${type}&title=${title}&assigned_by=${assigned_to}&status=${filter_status}&due_date_from=${assigned_date_from}&due_date_to=${assigned_date_to}"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );

      if(response.statusCode == 200){
        return AssignedToMeModel.fromJson(jsonDecode(response.body));
      }
    }else if(status == "All"){
      print("All by me task");
      var response = await http.get(
          Uri.parse("${BASE_URL}/tasks"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );

      if(response.statusCode == 200){
        return AssignedToMeModel.fromJson(jsonDecode(response.body));
      }
    }else{
      print("All by me new task");
      var response = await http.get(
          Uri.parse("${BASE_URL}/tasks?status=${status}"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );

      if(response.statusCode == 200){
        return AssignedToMeModel.fromJson(jsonDecode(response.body));
      }
    }
  }

  Future<SingleTaskDetails?> singleTaskDetails(int id) async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/tasks/${id}"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    if(response.statusCode == 200){
      print(response.body);
      return SingleTaskDetails.fromJson(jsonDecode(response.body));
    }
  }

  Future<void> updateTaskStatus({required int id,required String status,required Function onSuccess,required Function onFail}) async {
    Map<String,dynamic> data = {
      "status": status,
    };


    var reponse = await http.post(
        Uri.parse("${BASE_URL}/tasks/${id}"),
        body: jsonEncode(data),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );

    if(reponse.statusCode == 200){
      onSuccess(jsonDecode(reponse.body)["message"]);
    }else{
      onFail(jsonDecode(reponse.body)["message"]);
    }
  }

  Future<void> reshudleTaskDate({required Map<String,dynamic> data,required int id,required Function onSuccess,required Function onFail}) async {

    var reponse = await http.post(
        Uri.parse("${BASE_URL}/tasks/re-schedule/${id}"),
        body: jsonEncode(data),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );

    if(reponse.statusCode == 200){
      onSuccess(jsonDecode(reponse.body)["message"]);
    }else{
      onFail(jsonDecode(reponse.body)["message"]);
    }
  }

}