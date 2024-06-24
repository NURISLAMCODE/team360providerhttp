import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/contact_list_model/Contact_list_model.dart';
import '../models/notice_model/department_list_class.dart';
import '../models/user_data_model.dart';
import '../utils/constants.dart';

class ContactListProvider extends ChangeNotifier{

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

  Future<EmployeeListClass?> getAllEmployeeList({required int department_id,required int office_division_id}) async {
    if(department_id == 0 && office_division_id == 0){
      print("1");
      var response = await http.get(
          Uri.parse("${BASE_URL}/employee-list"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );
      print(jsonDecode(response.body));
      if(response.statusCode == 200){
        return EmployeeListClass.fromJson(jsonDecode(response.body));
      }
    }else if(department_id != 0 && office_division_id == 0){
      print("2");
      var response = await http.get(
          Uri.parse("${BASE_URL}/employee-list?department_id=${department_id}"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );
      print(jsonDecode(response.body));
      if(response.statusCode == 200){
        return EmployeeListClass.fromJson(jsonDecode(response.body));
      }
    }else if(department_id == 0 && office_division_id != 0){
      print("3");
      var response = await http.get(
          Uri.parse("${BASE_URL}/employee-list?office_division_id=${office_division_id}"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );
      print(jsonDecode(response.body));
      if(response.statusCode == 200){
        return EmployeeListClass.fromJson(jsonDecode(response.body));
      }
    }else{
      print("4");
      var response = await http.get(
          Uri.parse("${BASE_URL}employee-list?department_id=${department_id}&office_division_id=${office_division_id}"),
          headers: <String,String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );
      print(jsonDecode(response.body));
      if(response.statusCode == 200){
        return EmployeeListClass.fromJson(jsonDecode(response.body));
      }
    }
  }

}