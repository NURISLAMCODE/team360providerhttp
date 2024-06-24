import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team360/src/business_logics/models/auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:team360/src/business_logics/models/half_leave_model.dart';
import 'package:team360/src/business_logics/models/leave_request_response_model.dart';
import 'package:team360/src/business_logics/models/leve_type_response_model.dart';
import 'package:team360/src/business_logics/models/login_response_model.dart';
import 'package:team360/src/business_logics/models/otp_verify_response_model.dart';
import 'package:team360/src/business_logics/models/upload_file_model.dart';
import 'package:http/http.dart' as http;
import '../../services/repository.dart';
import '../models/all_leave_response_model.com.dart';
import '../models/api_response_object.dart';
import '../models/error_response_model.dart';
import '../models/leave_report_class.dart';
import '../models/user_data_model.dart';
import '../utils/constants.dart';
import '../utils/log_debugger.dart';

class LeaveProvider extends ChangeNotifier {

  bool _inProgress = false, _isError = false;
  ErrorResponseModel? _errorResponse;

  FileUploadModel uploadFile = FileUploadModel();
  LeaveRequestResponseModel? _leaveRequestResponseModel;
  LeaveTypeResponseModel? _leaveTypeResponseModel;
  AllLeaveResponseModel? _allLeaveRequestResponseModel;
HalfDayLeaveModel? _halfDayLeaveModel;
  bool get inProgress => _inProgress;
  bool get isError => _isError;
  String? fileName;
  ErrorResponseModel? get errorResponse => _errorResponse;
  LeaveTypeResponseModel? get leaveTypeResponseModel => _leaveTypeResponseModel;
  LeaveRequestResponseModel? get leaveRequestResponseModel => _leaveRequestResponseModel;
  AllLeaveResponseModel? get allLeaveRequestResponseModel => _allLeaveRequestResponseModel;
  FileUploadModel get bankDocument => uploadFile;
HalfDayLeaveModel? get halfDayLeaveModel => _halfDayLeaveModel;

  Future<bool> getLeveType() async {
    try {
      _inProgress = false;
      notifyListeners();
      final response = await repository.leveTypeProvider();
      if (response.id == 200) {
        _inProgress = false;
        _leaveTypeResponseModel = response.object as LeaveTypeResponseModel;
        notifyListeners();
        return true;
      } else {
        _inProgress = true;
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

  Future<void> leavePost({required int id,required String leaveSlot,required String mode,required String leaveDate,required String leaveTypeId,required String fromDate, required String toDate,String? files ,required String noOfDays,String? remarks,required Function onSuccess,required Function onFail}) async {
    if(mode == "half-day"){
      Map<String,dynamic> data = {
        "mode": mode,
        "user_id": id,
        "leave_slot": leaveSlot,
        "leave_type_id": leaveTypeId,
        "leave_date": leaveDate,
        "no_of_days": noOfDays,
        "remarks": remarks,
        "files": files
      };
      print(jsonEncode(data));


      var response = await http.post(
          Uri.parse("${BASE_URL}/leaves"),
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
    }else{
      Map<String,dynamic> data = {
        "mode": mode,
        "user_id": id,
        "leave_type_id": leaveTypeId,
        "from_date": fromDate,
        "to_date": toDate,
        "no_of_days": noOfDays,
        "remarks": remarks,
        "files": files
      };
      print(jsonEncode(data));


      var response = await http.post(
          Uri.parse("${BASE_URL}/leaves"),
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
  }

  Future<bool> leaveRequestProvider({required int id,required String leaveTypeId,required String fromDate, required String toDate,String? files ,required String noOfDays,String? remarks}) async {
    try {
      final response = await repository.leaveRequestAPI(id: id, leaveTypeId: leaveTypeId, fromDate: fromDate, toDate: toDate,files: files,noOfDays: noOfDays, remarks: remarks);
      if (response.id == ResponseCode.SUCCESSFUL) {
        _leaveRequestResponseModel = response.object as LeaveRequestResponseModel;
        notifyListeners();
        return true;
      } else {
        _isError = true;
        _errorResponse = response.object as ErrorResponseModel;
        notifyListeners();
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  Future<bool> uploadPick() async {
    try {
      _inProgress = false;
      notifyListeners();
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf','jpg', 'png', 'txt' ],

      );
      if (result != null && result.files.single.path != null) {
        PlatformFile file = result.files.first;
        print(file.name);
        print(file.bytes);
        print(file.size);

        File file0 = File(result.files.single.path! ?? " ");

         fileName = file0.path;
        notifyListeners();
        return true;
      } else {
        print("file not found");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getAllLeveType() async {
    try {
      _inProgress = false;
      notifyListeners();
      final response = await repository.allLeaveTypeProvider();
      if (response.id == 200) {
        _inProgress = false;
        _allLeaveRequestResponseModel = response.object as AllLeaveResponseModel;
        notifyListeners();
        return true;
      } else {
        _inProgress = true;
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

  Future<void> uploadImageFileForLeave({required File? filePath, required Function onSuccess, required Function onFail}) async {
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


  Future<bool> uploadDocument({required File image}) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.applicantFileUpload(image: image);

    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      uploadFile = _response.object as FileUploadModel;
      notifyListeners();
      return true;
    } else {
      _inProgress = false;
      notifyListeners();
      _errorResponse = _response.object as ErrorResponseModel;
      return false;
    }
  }


  //HalfDayLeave
  Future<HalfDayLeaveModel?> halfDayGet() async{
    try{
      var response = await http.get(Uri.parse("${BASE_URL}/leaves/settings/app"),
          headers: <String, String> {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserData.accessToken}',
          }
      );
      if(response.statusCode == 200){
        return HalfDayLeaveModel.fromJson(jsonDecode(response.body));
      }
    }catch(e){
      print(e);
    }
  }

  //HalfDay Post
//   Future<void> halfDayLeavePost({http.Response}){
//
// }



  Future<AllLeaveResponseModel?> leaveFilter({required String status}) async {
    try{
      if(status == "All"){
        print("${BASE_URL}/leaves?user_id=${UserData.id}");
        var response = await http.get(
            Uri.parse("${BASE_URL}/leaves?user_id=${UserData.id}"),
            headers: <String,String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${UserData.accessToken}',
            }
        );
        print(jsonDecode(response.body));
        if(response.statusCode == 200){
          return AllLeaveResponseModel.fromJson(jsonDecode(response.body));
        }
      }else{
        print("${BASE_URL}/leaves?status=${status}&user_id=${UserData.id}");
        var response = await http.get(
            Uri.parse("${BASE_URL}/leaves?status=${status}&user_id=${UserData.id}"),
            headers: <String,String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${UserData.accessToken}',
            }
        );
        print(jsonDecode(response.body));
        if(response.statusCode == 200){
          return AllLeaveResponseModel.fromJson(jsonDecode(response.body));
        }
      }
    }catch (e){
      print(e);
    }

  }

  Future<LeaveReportClass?> leaveReport() async {
    var response = await http.get(
        Uri.parse("${BASE_URL}/leave-reports/app"),
        headers: <String,String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.accessToken}',
        }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      return LeaveReportClass.fromJson(jsonDecode(response.body));
    }
  }






// Future<bool> leaveRequestProvider({
  //   required int id,
  //   required String leaveTypeId,
  //   required String fromDate,
  //   required String toDate,
  //   required String noOfDays,
  //   String? remarks,
  //   required String files,
  // }) async {
  //   try {
  //     // Step 1: Upload a file
  //     final bool isFileUploaded = await uploadPick();
  //
  //     if (!isFileUploaded) {
  //       // Handle the case when the file upload fails
  //       return false;
  //     }
  //
  //     // Step 2: Send leave request with uploaded file
  //     final String uploadedFileName = fileName!; // Assuming fileName is a global variable
  //     final bool leaveRequestResult = await leaveRequestProvider(
  //       id: id,
  //       leaveTypeId: leaveTypeId,
  //       fromDate: fromDate,
  //       toDate: toDate,
  //       noOfDays: noOfDays,
  //       remarks: remarks,
  //       files: uploadedFileName,
  //     );
  //
  //     return leaveRequestResult;
  //   } catch (e) {
  //     // Handle any exceptions here
  //     return false;
  //   }
  // }

}