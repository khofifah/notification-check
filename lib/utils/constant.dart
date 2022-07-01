import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const String prefNotifEnable = 'isNotifEnable';
const String prefNotifReceive = 'isNotifReceive';
const String serverKey =
    'AAAAWYw4vrI:APA91bGsex1OYZyvDHl7Vk8X-9SgGqlZRukYcr4JdZQmDY18Dd8XS9FteI1k7z63tylS-Z4hYS_sdn1D1jVngONDWfxCfYMd4jqgeYBOQ0qtZDFEhKxw313d79iYF5PvA7rtQYLvB1SR';

Future<String?> topicName() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.nodename;
  } else {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }
}
