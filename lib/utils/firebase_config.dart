import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:notif_check/utils/constant.dart';
import 'package:notif_check/utils/notif_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  executeMessage(message);
}

executeMessage(RemoteMessage message) async {
  var controller = Get.put(NotifController());
  await controller.setIsNotifReceive(true);
  await controller.setIsNotifLoading(false);

  flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.data["title"],
    message.data["body"],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        playSound: true,
        icon: '@drawable/ic_launcher',
      ),
    ),
    payload: jsonEncode(message.data),
  );
}

notifHandling() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) =>
        onNotifClicked(navigatorKey, payload!),
  );

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
    if (notificationAppLaunchDetails.payload != null) {
      onNotifClicked(navigatorKey, notificationAppLaunchDetails.payload!);
    }
  }

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      executeMessage(message);
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    executeMessage(message);
  });
}

checkSubscribeTopic({bool? isEnable}) async {
  final prefs = await SharedPreferences.getInstance();
  bool isNotifEnable;

  if (isEnable == null) {
    isNotifEnable = prefs.getBool(prefNotifEnable) ?? false;
  } else {
    isNotifEnable = isEnable;
    prefs.setBool(prefNotifEnable, isEnable);
  }

  if (isNotifEnable) {
    subscribeTopic();
  } else {
    unSubscribeTopic();
  }
}

subscribeTopic() async {
  String topic = await topicName() ?? 'tes';
  FirebaseMessaging.instance.subscribeToTopic(topic);
}

unSubscribeTopic() async {
  String topic = await topicName() ?? 'tes';
  FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}

onDidReceiveLocalNotification(
  int id,
  String? title,
  String? body,
  String? payload,
) async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () async {
            onNotifClicked(navigatorKey, payload!);
          },
        )
      ],
    ),
  );
}

onNotifClicked(navigatorKey, String dataJson) async {
  debugPrint(dataJson);
}
