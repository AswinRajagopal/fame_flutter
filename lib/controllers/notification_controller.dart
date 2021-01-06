import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List notificationList = [].obs;

  void getNotification() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getNotification();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['empActivities'] != null) {
            for (var i = 0; i < res['empActivities'].length; i++) {
              notificationList.add(res['empActivities'][i]);
            }
          }
        } else {
          Get.snackbar(
            'Error',
            'Something went wrong! Please try again later',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      Get.snackbar(
        'Error',
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
      );
    }
  }
}
