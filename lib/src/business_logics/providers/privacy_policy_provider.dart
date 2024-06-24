
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/privacy_policy_model.dart';
import '../models/tearm_and_con_model.dart';
import '../models/user_data_model.dart';
import '../utils/constants.dart';

class PrivacyPolicyProvider extends ChangeNotifier{

  Future<PrivacyPolicyModel?> getPrivacyPolicyData() async {
    try {
      var response = await http
          .get(Uri.parse("${BASE_URL}/privacy-policy/app"),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          });
      print(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        return PrivacyPolicyModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
  }

//terms-conditions/app
  Future<TermAndConModel?> getTermAndConData() async {
    try {
      var response = await http
          .get(Uri.parse("${BASE_URL}/terms-conditions/app"),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          });
      print(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        return TermAndConModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
  }
}