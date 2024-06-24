import 'dart:convert';

import 'package:team360/src/business_logics/utils/log_debugger.dart';
import 'package:team360/src/services/notification_service/Payload.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:team360/src/views/ui/bottomnav/bottomnav_screen_layout.dart';

class LocalNotificationService {
  late BuildContext context;
  static final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher")
    );
    notificationPlugin.initialize(
      initializationSettings,
      onSelectNotification: (jsonOb) {
        // Payload payload = Payload.fromJson(jsonDecode(jsonOb.toString()));

        // if (payload.type == "deals") {
        //   Navigator.pushNamed(
        //       GlobalVariable.navState.currentContext!, AppRoute.product,
        //       arguments: ScreenArguments(data: {
        //         "url": payload.clickAction.toString(),
        //         "category": "Offers",
        //         "numberofChildren": 0,
        //         "subcategoryUrl": ""
        //       }));
        // } else {
        //   Navigator.pushNamed(
        //       GlobalVariable.navState.currentContext!, AppRoute.order);
        // }


        LogDebugger.instance.i("Finding Route");
        if(GlobalKey<NavigatorState>().currentContext != null) {
          LogDebugger.instance.i("Found Route");
          Navigator.pushAndRemoveUntil(
              GlobalKey<NavigatorState>().currentContext!,
              MaterialPageRoute(builder: (context) => const BottomNavScreenLayout()),
                  (Route<dynamic> route) => false
          );
        }
      },
    );
  }

  static void createNotification(RemoteMessage message, Payload payload) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    BigPictureStyleInformation? bigPictureInformation;

    if(payload.image != null) {
      var response = await http.get(Uri.parse( payload.image!));
      var bigPicture = ByteArrayAndroidBitmap(response.bodyBytes);
      bigPictureInformation = BigPictureStyleInformation(
        bigPicture,
        largeIcon: const DrawableResourceAndroidBitmap("@mipmap/launcher_icon"),
        contentTitle: message.notification?.title,
        summaryText: message.notification?.body,
      );
    }


    final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "team360", "Aftab Agro Care Channel",
            channelDescription: "This is Aftab Agro Care Channel",
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: "@mipmap/launcher_icon",
            styleInformation: bigPictureInformation
        )
    );

    await notificationPlugin.show(id, message.notification?.title,
        message.notification?.body, notificationDetails,
        payload: jsonEncode(payload));
  }
}
