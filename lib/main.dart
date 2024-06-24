import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team360/src/app.dart';
import 'package:team360/src/business_logics/providers/all_notice_provider.dart';
import 'package:team360/src/business_logics/providers/app_provider.dart';
import 'package:team360/src/business_logics/providers/approval_provider.dart';
import 'package:team360/src/business_logics/providers/attendance_provider.dart';
import 'package:team360/src/business_logics/providers/attendance_report_provider.dart';
import 'package:team360/src/business_logics/providers/auth_provider.dart';
import 'package:team360/src/business_logics/providers/contact_list_provider.dart';
import 'package:team360/src/business_logics/providers/expenses_provider.dart';
import 'package:team360/src/business_logics/providers/leave_provider.dart';
import 'package:team360/src/business_logics/providers/privacy_policy_provider.dart';
import 'package:team360/src/business_logics/providers/schadual_provider.dart';
import 'package:team360/src/business_logics/providers/splash_screen_provider.dart';
import 'package:team360/src/business_logics/providers/task_provider.dart';
import 'package:team360/src/business_logics/providers/user_provider.dart';
import 'package:team360/src/services/notification_service/local_notification_service.dart';
import 'package:team360/src/services/shared_preference_services/shared_preference_services.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark
      )
  );

  final List<ChangeNotifierProvider> providerList = [
    ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<LeaveProvider>(create: (_) => LeaveProvider()),
    ChangeNotifierProvider<SchadualProvider>(create: (_) => SchadualProvider()),
    ChangeNotifierProvider<ExpensesProvider>(create: (_) => ExpensesProvider()),
    ChangeNotifierProvider<AttendaceProvider>(create: (_) => AttendaceProvider()),
    ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
    ChangeNotifierProvider<ApprovalProvider>(create: (_)=> ApprovalProvider()),
    ChangeNotifierProvider<ContactListProvider>(create: (_) => ContactListProvider()),
    ChangeNotifierProvider<UserProfileProvider>(create: (_) => UserProfileProvider()),
    ChangeNotifierProvider<AttendanceReportProvider>(create: (_) => AttendanceReportProvider()),
    ChangeNotifierProvider<AllNoticeProvider>(create: (_) => AllNoticeProvider()),
    ChangeNotifierProvider<SplashScreenProvider>(create: (_) => SplashScreenProvider()),
    ChangeNotifierProvider<PrivacyPolicyProvider>(create: (_) => PrivacyPolicyProvider()),

  ];
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "...", appId: "...",
      messagingSenderId: "...", projectId: "..."));
  LocalNotificationService.initialize();

  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp();
  //   LocalNotificationService.initialize();
  // }
  await SharedPrefsServices.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
      MultiProvider(
          providers: providerList,
          child: const App()
      )
  );
}