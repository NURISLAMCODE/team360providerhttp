import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/services/shared_preference_services/shared_preference_services.dart';
import 'package:team360/src/views/ui/intro/intro_slider.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

import 'bottomnav/bottomnav_screen_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  bool? userLoggedIn;
  int duration = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      await checkVersionCode();
      print(SharedPrefsServices.getStringData("appVersion"));
      print(SharedPrefsServices.getStringData("appUpdate"));
      if(SharedPrefsServices.getStringData("appVersion") != SharedPrefsServices.getStringData("appUpdate")){
        print("clean");
        await deleteUser();
        await checkVersionUpdate();
      }
      getUserAuthState();
      checkState(context);
    });
  }

  Future<void> deleteUser() async {
    await SharedPrefsServices.clearAllData();
  }

  Future<void> checkVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await SharedPrefsServices.setStringData("appVersion", packageInfo.version);
  }

  Future<void> checkVersionUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await SharedPrefsServices.setStringData("appUpdate", packageInfo.version);
  }

  getUserAuthState() {
    UserData.accessToken = SharedPrefsServices.getStringData("accessToken");
    UserData.id = SharedPrefsServices.getIntData("id");
    UserData.name = SharedPrefsServices.getStringData("name");
    UserData.phone = SharedPrefsServices.getStringData("phone");
    UserData.photo = SharedPrefsServices.getStringData("photo");
    UserData.designation = SharedPrefsServices.getStringData("type");
    userLoggedIn = (UserData.accessToken ?? "") != "";
    UserData.checkIn = SharedPrefsServices.getStringData("checkIn");
    UserData.checkOut = SharedPrefsServices.getStringData("checkOut");
  }

  checkState(context) {
    Timer(Duration(seconds: duration), () {
      duration = 1;
      userLoggedIn == null ? checkState(context)
      : Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
          userLoggedIn!
          ? const BottomNavScreenLayout()
          : const IntroSliderScreen()
          ),
          (Route<dynamic> route) => false
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Image.asset("assets/images/icon.png"),
          ),
        ),
      ),
    );
  }
}
