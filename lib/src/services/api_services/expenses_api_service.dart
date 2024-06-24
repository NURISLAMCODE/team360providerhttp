import 'package:team360/src/business_logics/models/all_expenses_response_model.dart';
import 'package:team360/src/business_logics/models/api_response_object.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:team360/src/business_logics/utils/log_debugger.dart';
import 'package:team360/src/services/api_services/base_api_caller.dart';
import '../../business_logics/models/user_data_model.dart';
import '../../business_logics/utils/constants.dart';

class ExpenseAPIServices {

  final Logger _logger = Logger();


  Future<ResponseObject> getAlExpensesTypeApi(String startDate,String endDate) async {

  try {
    if(startDate == "" && endDate == ""){
      final _response = await BaseAPICaller.getRequest('$BASE_URL/expenses/employee',
          token: UserData.accessToken);

      if (_response.success) {
        var allExpensesTypeResponseModel =
        AllExpensesResponseModel.fromJson(_response.returnValue);

        LogDebugger.instance.i(ResponseObject(object: allExpensesTypeResponseModel));
        return ResponseObject(
            object: allExpensesTypeResponseModel, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: _response.errorMessage, id: ResponseCode.FAILED);
      }
    }else if(startDate != "" ){
      final _response = await BaseAPICaller.getRequest('$BASE_URL/expenses/employee?from=${startDate}',
          token: UserData.accessToken);

      if (_response.success) {
        var allExpensesTypeResponseModel =
        AllExpensesResponseModel.fromJson(_response.returnValue);

        LogDebugger.instance.i(ResponseObject(object: allExpensesTypeResponseModel));
        return ResponseObject(
            object: allExpensesTypeResponseModel, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: _response.errorMessage, id: ResponseCode.FAILED);
      }
    }else if(endDate != "" ){
      final _response = await BaseAPICaller.getRequest('$BASE_URL/expenses/employee?to=${startDate}',
          token: UserData.accessToken);

      if (_response.success) {
        var allExpensesTypeResponseModel =
        AllExpensesResponseModel.fromJson(_response.returnValue);

        LogDebugger.instance.i(ResponseObject(object: allExpensesTypeResponseModel));
        return ResponseObject(
            object: allExpensesTypeResponseModel, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: _response.errorMessage, id: ResponseCode.FAILED);
      }
    }else{
      final _response = await BaseAPICaller.getRequest('$BASE_URL/expenses/employee?from=${startDate}&to=${endDate}',
          token: UserData.accessToken);

      if (_response.success) {
        var allExpensesTypeResponseModel =
        AllExpensesResponseModel.fromJson(_response.returnValue);

        LogDebugger.instance.i(ResponseObject(object: allExpensesTypeResponseModel));
        return ResponseObject(
            object: allExpensesTypeResponseModel, id: ResponseCode.SUCCESSFUL);
      } else {
        return ResponseObject(
            object: _response.errorMessage, id: ResponseCode.FAILED);
      }
    }

  } catch (e) {
    LogDebugger.instance.e(e);
    return ResponseObject(object: e.toString(), id: ResponseCode.FAILED);
  }
}
}
