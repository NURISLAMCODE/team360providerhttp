import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:team360/src/services/notification_service/Payload.dart';
import 'package:team360/src/services/notification_service/local_notification_service.dart';
import 'package:team360/src/views/ui/splash_screen.dart';
import 'package:team360/src/views/utils/colors.dart';

Future<void> backgroundHandler(RemoteMessage? message) async {

  if (message != null) {
    Payload payload = Payload.fromJson(message.data);
    LocalNotificationService.createNotification(message, payload);
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          Payload payload = Payload.fromJson(message.data);
          LocalNotificationService.createNotification(message, payload);
        }
      });

      FirebaseMessaging.onMessage.listen((message) {
        Payload payload = Payload.fromJson(message.data);
        LocalNotificationService.createNotification(message, payload);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        Payload payload = Payload.fromJson(message.data);
        LocalNotificationService.createNotification(message, payload);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: MaterialColor(0xFF002E70, primaryColorMap)),
        home: const SplashScreen(),
      );
    });
  }
}
