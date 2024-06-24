import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:team360/src/business_logics/models/profile_response_model.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/business_logics/utils/log_debugger.dart';
import 'package:team360/src/services/api_services/base_api_caller.dart';
import 'package:http/http.dart' as http;

import '../../business_logics/models/error_response_model.dart';
import '../../business_logics/models/profile_update_response_model.dart';

class UserApiService {
  final Logger _logger = Logger();

  Future<ResponseObject> getProfileData() async {
    try {
      final _response = await BaseAPICaller.getRequest('$BASE_URL/users/profile', token: UserData.accessToken);
      if (_response.success) {
        var profileRequestResponse =
            ProfileResponseModel.fromJson(_response.returnValue);

        LogDebugger.instance.i(ResponseObject(object: profileRequestResponse));
        return ResponseObject(
            object: profileRequestResponse, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: _response.errorMessage, id: ResponseCode.FAILED);
      }
    } catch (e) {
      LogDebugger.instance.e(e);
      return ResponseObject(object: e.toString(), id: ResponseCode.FAILED);
    }
  }

  Future<ResponseObject> updateProfileAPI({
    String? name,
    String? phone,
    String? email,
    String? gender,
    String? image,
    String? emergencyContact,
    String? bloodGroup,
  }) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/users/app/profile');
      final request = http.Request("POST", uri);

      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer ${UserData.accessToken}';

      request.body = jsonEncode({
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "image": image,
        "emergency_contact_phone" : emergencyContact,
        "blood_group" : bloodGroup,
        "reporting_to": 1
      });

      LogDebugger.instance.i(request.body);

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v('decoded: $decodedJson');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var profileUpdateResponse =
            ProfileUpdateResponseModel.fromJson(decodedJson);
        return ResponseObject(id: 200, object: profileUpdateResponse);
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
}
