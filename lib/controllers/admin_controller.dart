import 'dart:async';

import '../utils/utils.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AdminController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;
  var resAddShift;
  var resAddClient;

  void addShift(shiftName, startTime, endTime) async {
    try {
      isLoading(true);
      await pr.show();
      resAddShift = await RemoteServices().addShift(shiftName, startTime, endTime);
      if (resAddShift != null) {
        isLoading(false);
        await pr.hide();
        // print('res valid: $res');
        if (resAddShift['success']) {
          Get.snackbar(
            'Success',
            'Shift created successfully',
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            backgroundColor: AppUtils().greenColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          Timer(Duration(seconds: 2), Get.back);
        } else {
          Get.snackbar(
            'Error',
            'Shift not created',
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
