import 'dart:convert';

import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter_mute/flutter_mute.dart';
import 'package:get/get.dart';
import 'package:notif_check/utils/constant.dart';
import 'package:notif_check/utils/notif_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:dio/dio.dart';

Future<bool> checkNotifDefaultPermission() async {
  bool isGranted = await Permission.notification.isGranted;
  return isGranted;
}

Future<bool> checkNotifAppPermission() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(prefNotifEnable) ?? false;
}

Future<bool> checkDeviceNotOnMute() async {
  RingerMode ringerMode = await FlutterMute.getRingerMode();
  return ringerMode == RingerMode.Normal;
}

Future<bool> checkDeviceOnOptimization() async {
  bool isBatteryOptimizationDisabled =
      await DisableBatteryOptimization.isBatteryOptimizationDisabled ?? false;

  return !isBatteryOptimizationDisabled;
}

Future<bool> checkDeviceConnection() async {
  bool isConnected = await ConnectivityWrapper.instance.isConnected;
  return isConnected;
}

Future<bool> checkNotif() async {
  String? topic = await topicName();
  var controller = Get.put(NotifController());

  bool isNotifAppEnable = await checkNotifAppPermission();
  if (!isNotifAppEnable) {
    controller.isNotifReceive(false);
    controller.isNotifLoading(false);
    return false;
  }

  try {
    var response = await Dio().post(
      'https://fcm.googleapis.com/fcm/send',
      data: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'body': 'Testing Notif',
            'title': 'Yeay notif'
          },
          'to': '/topics/${topic ?? ''}',
        },
      ),
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      ),
    );
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
