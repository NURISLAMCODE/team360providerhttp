import 'package:logger/logger.dart';
import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:team360/src/business_logics/models/attendence_report_response_model.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/business_logics/utils/log_debugger.dart';
import 'package:team360/src/services/api_services/base_api_caller.dart';

class AttendanceReportApiService {

  Future<ResponseObject> getAttendanceReportData() async {
    try {
      final _response = await BaseAPICaller.getRequest(
        //  '$BASE_URL/attendances/user/1',
       '$BASE_URL/attendances/user/${UserData.id.toString()}',
          token: UserData.accessToken);
      if (_response.success) {
        var attendanceReportModel =
            AttendanceReportResponseModel.fromJson(_response.returnValue);
        LogDebugger.instance.i(_response);
        return ResponseObject(
            object: attendanceReportModel, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: _response.errorMessage, id: ResponseCode.FAILED);
      }
    } catch (e) {
      LogDebugger.instance.e(e);
      return ResponseObject(object: e.toString(), id: ResponseCode.FAILED);
    }
  }
}
