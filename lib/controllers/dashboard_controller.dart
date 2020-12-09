import 'dart:async';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isDashboardLoading = true.obs;
  var isStatusLoading = true.obs;
  var isAttendanceLoading = true.obs;
  var isLeaveStatusLoading = true.obs;
  var isCalendarLoading = true.obs;
  var response;

  @override
  void onInit() {
    super.onInit();
    Timer(Duration(seconds: 4), () {
      isStatusLoading(false);
    //   isAttendanceLoading(false);
    //   isLeaveStatusLoading(false);
    //   isCalendarLoading(false);
    });
    getDashboardDetails();
  }

  void getDashboardDetails() async {
    try {
      isDashboardLoading(true);
      response = await RemoteServices().getDashboardDetails();
      if (response != null) {
        isDashboardLoading(false);
        print('dbResponse valid: ${response.success}');
        if (response.success) {
        } else {
          Get.snackbar(
            'Error',
            'Something went wrong! Please try again later',
            colorText: Colors.white,
            backgroundColor: Colors.red,
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
      isDashboardLoading(false);
      Get.snackbar(
        'Error',
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
      );
    } finally {
      // isLoading(false);
      // await pr.hide();
    }
  }
}
