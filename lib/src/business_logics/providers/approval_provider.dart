import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/approveal_model/my_request_class.dart';
import '../models/user_data_model.dart';
import '../utils/constants.dart';

class ApprovalProvider extends ChangeNotifier{

  Future<MyRequestClass?> getAllMyRequest({required String type}) async {
    try{
      if(type == "All"){
        var response = await http.get(
            Uri.parse("${BASE_URL}/approver-summary/user"),
            headers: <String,String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${UserData.accessToken}',
            }
        );
        print(jsonDecode(response.body));
        if(response.statusCode == 200){
          return MyRequestClass.fromJson(jsonDecode(response.body));
        }
      }else{
        var response = await http.get(
            Uri.parse("${BASE_URL}/approver-summary/user?type=${type}"),
            headers: <String,String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${UserData.accessToken}',
            }
        );
        print(jsonDecode(response.body));
        if(response.statusCode == 200){
          return MyRequestClass.fromJson(jsonDecode(response.body));
        }
      }
    } catch (e){
      print(e);
    }
  }


  Future<MyRequestClass?> getAllAprover({required String type}) async {
    try{
      if(type == "All"){
        try{
          var response = await http.get(
              Uri.parse("${BASE_URL}/approver-summary"),
              headers: <String,String>{
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${UserData.accessToken}',
              }
          );
          print(jsonDecode(response.body));
          if(response.statusCode == 200){
            return MyRequestClass.fromJson(jsonDecode(response.body));
          }
        }catch (e){
          print(e);
        }
      }else{
        var response = await http.get(
            Uri.parse("${BASE_URL}/approver-summary?type=${type}"),
            headers: <String,String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${UserData.accessToken}',
            }
        );
        print(jsonDecode(response.body));
        if(response.statusCode == 200){
          return MyRequestClass.fromJson(jsonDecode(response.body));
        }
      }
    } catch (e){
      print(e);
    }
  }

  Future<void> approveRequest({required int index,required Function onSuccess,required Function onFail}) async {
    var response = await http.post(
        Uri.parse("${BASE_URL}/approver-summary/aprrover/${index}"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      onSuccess(jsonDecode(response.body)["message"]);
    }else{
      onFail(jsonDecode(response.body)["message"]);
    }
  }

  Future<void> approveRejected({required String remarks,required int index,required Function onSuccess,required Function onFail}) async {
    var data = {
      "remarks": remarks,
    };
    var response = await http.post(
        Uri.parse("${BASE_URL}/approver-summary/rejected/${index}"),
        body: jsonEncode(data),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      onSuccess(jsonDecode(response.body)["message"]);
    }else{
      onFail(jsonDecode(response.body)["message"]);
    }
  }

}