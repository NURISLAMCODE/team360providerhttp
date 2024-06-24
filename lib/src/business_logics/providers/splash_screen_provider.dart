import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:team360/src/business_logics/utils/constants.dart';
import '../models/splash_screen_content_model.dart';

class SplashScreenProvider extends ChangeNotifier {
  Future<SplashScreenContentModel?> getSplashScreenData() async {
    try {
      var response = await http
          .get(Uri.parse("${BASE_URL}/app-contents"),
          headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200 || response.statusCode == 201){
        return SplashScreenContentModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
  }
}
