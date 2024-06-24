import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:team360/src/business_logics/utils/constants.dart';

import '../models/scadual_calender_class/next_sevenday_working_Scadual.dart';
import '../models/scadual_calender_class/per_date_data.dart';
import '../models/scadual_calender_class/scadual_calender_class.dart';
import '../models/user_data_model.dart';

class SchadualProvider extends ChangeNotifier{
  List<PerDateData> allDateData = [];
  List<PerDateData> perDateData = [];
  Future<PerWeekSchedualWork?> getPerWeekWorkSchadual() async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/schedule-working"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      return PerWeekSchedualWork.fromJson(jsonDecode(response.body));
    }
  }

  Future<List<PerDateData>?> getTheSchudleCalender({required int year,required int month}) async {
    Map<String,dynamic> data = {
      "year" : year.toString(),
      "month" : month.toString()
    };
    print(jsonEncode(data));
    var url = Uri.https("${BASE_URI}","/backend/api/schedules",data);
    var response = await http.get(
        url,
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print("${DateFormat("EEEE").format(DateTime(year,month,1)) == "Saturday"}");
    if(DateFormat("EEEE").format(DateTime(year,month,1)) == "Sunday"){
      perDateData.clear();
      allDateData.clear();
      List<dynamic> data = jsonDecode(response.body)["data"];
      return perDateData = data.map((e) => PerDateData.fromJson(e)).toList();
    }else if(DateFormat("EEEE").format(DateTime(year,month,1)) == "Monday"){
      perDateData.clear();
      allDateData.clear();
      List<dynamic> data = jsonDecode(response.body)["data"];
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      allDateData = data.map((e) => PerDateData.fromJson(e)).toList();
      perDateData.addAll(allDateData);
      return perDateData;
    }else if(DateFormat("EEEE").format(DateTime(year,month,1)) == "Tuesday"){
      perDateData.clear();
      allDateData.clear();
      List<dynamic> data = jsonDecode(response.body)["data"];
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      allDateData = data.map((e) => PerDateData.fromJson(e)).toList();
      perDateData.addAll(allDateData);
      return perDateData;
    }else if(DateFormat("EEEE").format(DateTime(year,month,1)) == "Wednesday"){
      perDateData.clear();
      allDateData.clear();
      List<dynamic> data = jsonDecode(response.body)["data"];
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      allDateData = data.map((e) => PerDateData.fromJson(e)).toList();
      perDateData.addAll(allDateData);
      return perDateData;
    }else if(DateFormat("EEEE").format(DateTime(year,month,1)) == "Thursday"){
      perDateData.clear();
      allDateData.clear();
      List<dynamic> data = jsonDecode(response.body)["data"];
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      allDateData = data.map((e) => PerDateData.fromJson(e)).toList();
      perDateData.addAll(allDateData);
      return perDateData;
    }else if(DateFormat("EEEE").format(DateTime(year,month,1)) == "Friday"){
      perDateData.clear();
      allDateData.clear();
      List<dynamic> data = jsonDecode(response.body)["data"];
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      allDateData = data.map((e) => PerDateData.fromJson(e)).toList();
      perDateData.addAll(allDateData);
      return perDateData;
    }else if(DateFormat("EEEE").format(DateTime(year,month,1)) == "Saturday"){
      perDateData.clear();
      allDateData.clear();
      List<dynamic> data = jsonDecode(response.body)["data"];
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      perDateData.add(PerDateData(weekend: false,workingDay: false,leave: false,holiday: false));
      allDateData = data.map((e) => PerDateData.fromJson(e)).toList();
      perDateData.addAll(allDateData);
      return perDateData;
    }
  }


  Future<NextSevendayWorkSchadual?> getNextSevenDayWorkingDay() async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/schedules/next-schedules"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      return NextSevendayWorkSchadual.fromJson(jsonDecode(response.body));
    }
  }
}