import 'package:team360/src/business_logics/models/error_response_model.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {

  int _selectedBottomNavIndex = 0;
  int get selectedBottomNavIndex => _selectedBottomNavIndex;
  setBottomNavIndex(value) {
    _selectedBottomNavIndex = value;
    notifyListeners();
  }

  bool _isError = false;

  bool get isError => _isError;

  ErrorResponseModel? _errorResponse;

  ErrorResponseModel? get errorResponse => _errorResponse;
}