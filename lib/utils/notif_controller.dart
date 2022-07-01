import 'package:get/get.dart';

class NotifController extends GetxController {
  RxBool isNotifReceive = false.obs;
  RxBool isNotifLoading = true.obs;

  setIsNotifReceive(bool isReceive) {
    isNotifReceive = RxBool(isReceive);
  }

  setIsNotifLoading(bool isLoading) {
    isNotifLoading = RxBool(isLoading);
  }
}
