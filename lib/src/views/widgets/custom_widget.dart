import 'package:fluttertoast/fluttertoast.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:flutter/material.dart';

final customWidget = _CustomWidget();

class _CustomWidget {

  AppBar? appbar({String? title, actions, backgroundColor}) {
    return AppBar(
      elevation: 0,
      bottomOpacity: 0,
      backgroundColor: kWhiteColor,
      titleTextStyle: TextStyle(color: backgroundColor ?? kThemeColor),
      toolbarTextStyle: TextStyle(color: backgroundColor ?? kThemeColor),
      iconTheme: IconThemeData(color: backgroundColor ?? kThemeColor),
      title: Text(title ?? "", style: kLargeTitleTextStyle),
      actions: actions
    );
  }

  showCustomSnackbar(context, String? errorMessage) {
    Fluttertoast.showToast(
        msg: "${errorMessage}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  showCustomSuccessSnackbar(context, String? successMessage) {
    Fluttertoast.showToast(
        msg: "${successMessage}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}