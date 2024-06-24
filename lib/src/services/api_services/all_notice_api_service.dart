import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:team360/src/business_logics/models/all_notice_response_model.dart';
import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:team360/src/business_logics/models/create_notice_response_model.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/business_logics/utils/log_debugger.dart';
import 'package:team360/src/services/api_services/base_api_caller.dart';
import 'package:http/http.dart' as http;

import '../../business_logics/models/error_response_model.dart';
import '../../business_logics/models/notice_model/notice_type_class.dart';

class AllNoticeResponseService {
  final Logger _logger = Logger();

  Future<ResponseObject> getAllNoticeData() async {
    try {
      final _response = await BaseAPICaller.getRequest('$BASE_URL/notices/department',
          token: UserData.accessToken);

      if (_response.success) {
        var allNoticeResponseModel =
            AllNoticeResponseModel.fromJson(_response.returnValue);

        LogDebugger.instance.i(ResponseObject(object: allNoticeResponseModel));
        return ResponseObject(
            object: allNoticeResponseModel, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: _response.errorMessage, id: ResponseCode.FAILED);
      }
    } catch (e) {
      LogDebugger.instance.e(e);
      return ResponseObject(object: e.toString(), id: ResponseCode.FAILED);
    }
  }


  Future<ResponseObject> createNoticeAPI({required String fromDate, required String toDate,required String type, required String notice}) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/notices');
      final request = http.Request("POST", uri);

      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer ${UserData.accessToken}';

      request.body = jsonEncode({
        "department_id":1,
        "from_date": fromDate,
        "to_date": toDate,
        "type": type,
        "notice": notice,
        "status": true
      });

      LogDebugger.instance.i(request.body);

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v('decoded: $decodedJson');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var createNoticeResponse = CreateNoticeResponseModel.fromJson(decodedJson);
        return ResponseObject(id: 200, object: createNoticeResponse);
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
