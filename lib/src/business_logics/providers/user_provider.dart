import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:team360/src/business_logics/models/error_response_model.dart';
import 'package:team360/src/business_logics/models/profile_response_model.dart';
import 'package:team360/src/business_logics/models/profile_update_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/services/repository.dart';

import '../models/user_data_model.dart';

class UserProfileProvider extends ChangeNotifier {
  bool _inProgress = false,
      _isError = false;
  bool _profileDataProgress = false;
  ErrorResponseModel? _errorResponse;
  ProfileResponseModel? _profileResponseModel;
  ProfileUpdateResponseModel? _profileUpdateResponseModel;

  bool get inProgress => _inProgress;

  bool get isError => _isError;

  ProfileResponseModel? get profileResponseModel => _profileResponseModel;
  ProfileUpdateResponseModel? get profileUpdateResponseModel => _profileUpdateResponseModel;


  Future<ProfileResponseModel?> getProfileData() async{
    try{
      var response = await http.get(Uri.parse("${BASE_URL}/users/profile"),
          headers: <String, String> {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );
      if(response.statusCode == 200){
        return ProfileResponseModel.fromJson(jsonDecode(response.body));
      }
    }catch(e){
      print(e);
    }
  }

  // Future<bool> getProfileData() async {
  //   try {
  //     _profileDataProgress = false;
  //     notifyListeners();
  //     final response = await repository.getProfileData();
  //     if (response.id == 200) {
  //       _profileDataProgress = false;
  //       _profileResponseModel = response.object as ProfileResponseModel;
  //       notifyListeners();
  //       return true;
  //     } else {
  //       _profileDataProgress = true;
  //       _isError = true;
  //       _errorResponse = response.object as ErrorResponseModel;
  //       notifyListeners();
  //       return false;
  //     }
  //   }
  //   catch (e) {
  //     return false;
  //   }
  // }

  Future<void> profileUpdate({String? name, String? phone, String? email, String? gender, String? image, String? emergencyContact, String? bloodGroup,required Function onSuccess,required Function onFail}) async {

    Map<String,dynamic> data = {
      "name": name,
      "phone": phone,
      "email": email,
      "gender": gender,
      "image": image,
      "emergency_contact_phone" : emergencyContact,
      "blood_group" : bloodGroup,
      "reporting_to": 1
    };
    print(jsonEncode(data));


    var response = await http.post(
        Uri.parse("${BASE_URL}/users/app/profile"),
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

  Future<void> uploadImageFileForUser({required File? filePath, required Function onSuccess, required Function onFail}) async {
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


  // Future<bool> profileUpdateProvider({String? name,
  //     String? phone,
  //     String? email,
  //     String? gender,
  //     String? image,
  //     String? emergencyContact,
  //     String? bloodGroup}) async {
  //   try {
  //     final response = await repository.profileUpdateProvider(
  //         name: name,
  //         phone: phone,
  //         email: email,
  //         gender: gender,
  //         image: image,
  //         emergencyContact: emergencyContact,
  //         bloodGroup: bloodGroup,
  //     );
  //     if (response.id == ResponseCode.SUCCESSFUL) {
  //       _profileUpdateResponseModel = response.object as ProfileUpdateResponseModel;
  //       return true;
  //     } else {
  //       _isError = true;
  //       _errorResponse = response.object as ErrorResponseModel;
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }
  
  
  // Future<void>uploadImageFile(PickedFile? image,Function onSuccess,Function onFail) async {
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse("${BASE_URL}/file"));
  //     request.headers['Accept'] = 'application/json';
  //     request.headers['Content-Type'] = 'application/json';
  //     if (UserData.accessToken != null) request.headers['Authorization'] = 'Bearer ${UserData.accessToken}';
  //     request.files.add(await http.MultipartFile.fromPath('file', image!.path));
  //     http.StreamedResponse response = await request.send();
  //
  //     final responseData = await response.stream.transform(utf8.decoder).join();
  //     final decodedJson = json.decode(responseData);
  //
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       onSuccess(decodedJson["data"]);
  //     } else {
  //       onFail(decodedJson["message"]);
  //     }
  //   } catch (e) {
  //     onFail(e.toString());
  //   }
  //
  // }

  Future<void> passwordChange({required Map<String, dynamic> data, required Function onSuccess, required Function onFail}) async{
    try{
      var response = await http.post(Uri.parse("${BASE_URL}/users/app/update-password"),
          body: jsonEncode(data),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer ${UserData.accessToken}"
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

}


