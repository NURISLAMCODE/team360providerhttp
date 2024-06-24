import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:team360/src/business_logics/models/all_leave_response_model.com.dart';
import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:team360/src/business_logics/models/leave_request_response_model.dart';
import 'package:team360/src/business_logics/models/leve_file_upload_model.dart';

import 'package:team360/src/business_logics/utils/log_debugger.dart';
import 'package:team360/src/services/api_services/base_api_caller.dart';

import '../../business_logics/models/error_response_model.dart';
import '../../business_logics/models/leve_type_response_model.dart';
import '../../business_logics/models/upload_file_model.dart';
import '../../business_logics/models/user_data_model.dart';
import '../../business_logics/utils/constants.dart';
import '../image_compresson_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LeaveAPIServices {

  final Logger _logger = Logger();
  

  Future<ResponseObject> leaveRequestAPI({required int id,required String leveTypeId, required String fromDate, required String toDate,String? file,required String noOfDays,String? remarks}) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/leaves');
      final request = http.Request("POST", uri);

      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer ${UserData.accessToken}';

      request.body = jsonEncode({
        "user_id": id,
        "leave_type_id": leveTypeId,
        "from_date": fromDate,
        "to_date": toDate,
        "no_of_days": noOfDays,
        "remarks": remarks,
        "files": file
      });

      LogDebugger.instance.i(request.body);

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v('decoded: $decodedJson');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var leaveRequestResponse = LeaveRequestResponseModel.fromJson(decodedJson);

        return ResponseObject(id: 200, object: leaveRequestResponse);
      } else {
        return ResponseObject(
            id: response.statusCode,
            object: ErrorResponseModel.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.v(e.toString());
      return ResponseObject(id: 500, object: ErrorResponseModel());
    }
  }


  Future<ResponseObject> getLeveTypeApi() async {
    try {
      final response = await BaseAPICaller.getRequest('$BASE_URL/leave-types',
          token: UserData.accessToken);

      if (response.success) {
        var leaveTypeResponseMode =
        LeaveTypeResponseModel.fromJson(response.returnValue);

        LogDebugger.instance.i(ResponseObject(object: leaveTypeResponseMode));
        return ResponseObject(
            object: leaveTypeResponseMode, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: response.errorMessage, id: ResponseCode.FAILED);
      }
    } catch (e) {
      LogDebugger.instance.e(e);
      return ResponseObject(object: e.toString(), id: ResponseCode.FAILED);
    }
  }

  Future<ResponseObject> getAllLeveTypeApi() async {

    try {
      final response = await BaseAPICaller.getRequest('$BASE_URL/leaves',
          token: UserData.accessToken);

      if (response.success) {
        var allLeaveTypeResponseModel =
        AllLeaveResponseModel.fromJson(response.returnValue);

        LogDebugger.instance.i(ResponseObject(object: allLeaveTypeResponseModel));
        return ResponseObject(
            object: allLeaveTypeResponseModel, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: response.errorMessage, id: ResponseCode.FAILED);
      }
    } catch (e) {
      LogDebugger.instance.e(e);
      return ResponseObject(object: e.toString(), id: ResponseCode.FAILED);
    }
  }


  Future<ResponseObject> applicantFileUpload(File image) async {
    try {
      // final _image = await _getMultipartFile(image, "doc");
      // final _response = await BaseAPICaller.postMultiPartRequest(BASE_URL + "/applicantfileupload", {},
      //     images: [_image]);
      await _getMultipartFile(image, "image");
      var request = http.MultipartRequest('POST', Uri.parse(BASE_URL + "/file"));
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      if (UserData.accessToken != null) request.headers['Authorization'] = 'Bearer ${UserData.accessToken}';
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      http.StreamedResponse response = await request.send();

      LogDebugger.instance.i("File upload");
      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      LogDebugger.instance.i(decodedJson);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LogDebugger.instance.i("Success");
        return ResponseObject(
            object: FileUploadModel.fromJson(decodedJson),
            id: ResponseCode.SUCCESSFUL);
      } else {
        LogDebugger.instance.i("Failed");
        return ResponseObject(
            object: "", id: ResponseCode.FAILED);
      }
    } catch (e) {
      LogDebugger.instance.i("Error");
      LogDebugger.instance.e(e);
      return ResponseObject(object: e.toString(), id: ResponseCode.FAILED);
    }
  }

  Future<http.MultipartFile> _getMultipartFile(
      File image, String attribute) async {
    File file = File("");
    //
    if (ImageCompressionService.instance.fileSize(image) > 2) {
      final dir = await path_provider.getTemporaryDirectory();
      final fileSize =
      ImageCompressionService.instance.fileSize(image); // 500mb
      final ratioOfQuality = 100 - ((fileSize - 2) / (fileSize / 100));
      final targetPath = "${dir.absolute.path}/temp.jpg";
      file = (await ImageCompressionService.instance
          .testCompressAndGetFile(image, targetPath, ratioOfQuality.floor()));
    } else {
      file = image;
      LogDebugger.instance
          .v('original: ${ImageCompressionService.instance.fileSize(image)}');
    }
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();

    final multipartFile = http.MultipartFile(
      attribute,
      stream,
      length,
      filename: basename(file.path),
    );

    return multipartFile;
  }
}
