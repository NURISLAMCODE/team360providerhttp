
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:team360/src/business_logics/models/all_expenses_response_model.dart';
import 'package:team360/src/business_logics/utils/constants.dart';

import '../../services/repository.dart';
import '../models/error_response_model.dart';
import 'package:http/http.dart' as http;

import '../models/expence_mdel/expence_perpose_model.dart';
import '../models/user_data_model.dart';

class ExpensesProvider extends ChangeNotifier {

  bool _inProgress = false,
      _isError = false;
  ErrorResponseModel? _errorResponse;
  AllExpensesResponseModel? _allExpensesRequestResponseModel;

  AllExpensesResponseModel? get allExpensesRequestResponseModel =>
      _allExpensesRequestResponseModel;
  String source = "";
  String destination = "";
  String toll_amount = "0";
  String amount = "";
  String KM = "";
  String pKmExpense = "0";
  String fileName = "";
  String despriction = "";
  String perpous = "";
  String pickDate = "";
  int totalAmount = 0;
  File? documentFile;
  bool state = false;
  String transport_type = "";
  List<dynamic> transports = [];
  List<dynamic> allTransportsList = [];
  List<dynamic> personalTransport = [];
  List<dynamic> publicTransport = [];


  Future<AllExpensesResponseModel?> getAllExpence({required String start_date,required String end_date,required String type}) async{
    if(start_date.isEmpty == true && end_date.isEmpty == true && type.isEmpty == true){
      print("fitst");
      var response = await http.get(
        Uri.parse("${BASE_URL}/expenses/employee"),
        headers: <String,String> {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        },
      );
      if(response.statusCode == 200 ||response.statusCode == 201){
        return AllExpensesResponseModel.fromJson(jsonDecode(response.body));
      }
    }else if(start_date.isEmpty == true && end_date.isEmpty == true){
      print("secnd");
      var response = await http.get(
        Uri.parse("${BASE_URL}/expenses/employee?type=${type}"),
        headers: <String,String> {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        },
      );
      if(response.statusCode == 200 ||response.statusCode == 201){
        return AllExpensesResponseModel.fromJson(jsonDecode(response.body));
      }
    }else{
      print("secnd");
      var response = await http.get(
        Uri.parse("${BASE_URL}/expenses/employee?from=${start_date}&to=${end_date}&type=${type}"),
        headers: <String,String> {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        },
      );
      if(response.statusCode == 200 ||response.statusCode == 201){
        return AllExpensesResponseModel.fromJson(jsonDecode(response.body));
      }
    }
  }

  Future<void> expensePost(Map<String, dynamic> data, Function onSuccess,
      Function onFail) async {
    var response = await http.post(
      Uri.parse("${BASE_URL}/expenses"),
      headers: <String,String> {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserData.accessToken}',
      },
      body: jsonEncode(data)
    );
    final decodedJson = jsonDecode(response.body);

    if(response.statusCode == 200 ||response.statusCode == 201){
      onSuccess(decodedJson["message"]);
    }else{
      onFail(decodedJson["message"]);
    }
  }

  Future<void> uploadImageFile(File? filePath, Function onSuccess,
      Function onFail) async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse("${BASE_URL}/file"));
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

  Future<ExpencePerposeModel?> getAllExpencePerpose() async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/purpose-types"),
        headers: <String,String> {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        },
    );
    if(response.statusCode == 200 ||response.statusCode == 201){
      return ExpencePerposeModel.fromJson(jsonDecode(response.body));
    }
  }

  Future<void> perKmExpense({required String km,required Function onFail,required Function onSuccess}) async {
    var response = await http.get(
      Uri.parse("${BASE_URL}/office-expense/per-km?km=${km}"),
      headers: <String,String> {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserData.accessToken}',
      },
    );
    if(response.statusCode == 200){
      onSuccess(jsonDecode(response.body)["data"]["totalCost"]);
    }else if(response.statusCode == 500){
      onFail("Company per kilo-meter expense is not given");
    }else{
      onFail("");
    }
  }


}