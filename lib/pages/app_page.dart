import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notif_check/pages/notif_check_page.dart';
import 'package:notif_check/utils/constant.dart';
import 'package:notif_check/utils/firebase_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  bool isNotifEnable = true;

  @override
  void initState() {
    super.initState();
    notifHandling();
    setNotifStatus();
  }

  setNotifStatus({bool? isEnable}) async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      if (isEnable == null) {
        isNotifEnable = prefs.getBool(prefNotifEnable) ?? false;
      } else {
        isNotifEnable = isEnable;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                setNotifStatus(isEnable: !isNotifEnable);
                checkSubscribeTopic(isEnable: !isNotifEnable);
              },
              child: Text(
                '${isNotifEnable ? 'Unable' : 'Enable'} Notif',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const NotifCheckPage());
              },
              child: const Text(
                'Check Notif',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
