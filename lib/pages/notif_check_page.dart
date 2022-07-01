import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notif_check/pages/widgets.dart';
import 'package:notif_check/utils/function.dart';
import 'package:notif_check/utils/notif_controller.dart';

class NotifCheckPage extends StatefulWidget {
  const NotifCheckPage({Key? key}) : super(key: key);

  @override
  State<NotifCheckPage> createState() => _NotifCheckPageState();
}

class _NotifCheckPageState extends State<NotifCheckPage> {
  var controller = Get.put(NotifController());
  bool? isNotifDefault, isNotifApp;
  bool? isDeviceOnOptimization, isDeviceOnMute;
  bool? isDeviceOnConnection, isNotifSent;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    bool isDefault = await checkNotifDefaultPermission();
    bool isApp = await checkNotifAppPermission();
    bool isOnOptimization = await checkDeviceOnOptimization();
    bool isOnMute = await checkDeviceNotOnMute();
    bool isConnect = await checkDeviceConnection();
    bool isSent = await checkNotif();

    if (!mounted) return;
    setState(() {
      isNotifDefault = isDefault;
      isNotifApp = isApp;
      isDeviceOnOptimization = isOnOptimization;
      isDeviceOnMute = isOnMute;
      isDeviceOnConnection = isConnect;
      isNotifSent = isSent;
    });

    Timer(
      const Duration(seconds: 5),
      () {
        controller.setIsNotifLoading(false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Notif'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            customTile(
              'Checked app notification settings',
              isNotifApp,
            ),
            customTile(
              "Checked device's notification settings",
              isNotifDefault,
            ),
            customTile(
              'Checked battery is not on optimization',
              isDeviceOnOptimization,
            ),
            customTile(
              'Checked notification is not on mute',
              isDeviceOnMute,
            ),
            customTile(
              "Checked device's internet connection",
              isDeviceOnConnection,
            ),
            customTile(
              'Checked notification sent',
              isNotifSent,
            ),
            customTile(
              'Checked notification receive',
              controller.isNotifLoading.isTrue
                  ? null
                  : controller.isNotifReceive.isTrue,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                controller.setIsNotifLoading(true);
                controller.setIsNotifReceive(false);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const NotifCheckPage(),
                  ),
                );
              },
              child: const Text('Cek ulang'),
            ),
          ],
        ),
      ),
    );
  }
}
