import 'dart:async';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SOSController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  TextEditingController sosNumber = TextEditingController();

  void getEmpDetails() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getEmpDetails();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        // print('profileRes valid: ${res.success}');
        if (res['empDetails'] == null || res['empDetails']['sosNumber'] == null) {
        } else {
          update([sosNumber.text = res['empDetails']['sosNumber']]);
        }
        if (res['success']) {
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

  void updateSOS(sosNumber) async {
    try {
      await pr.show();
      var sosRes = await RemoteServices().updateSOS(sosNumber);
      if (sosRes != null) {
        await pr.hide();
        print('sosRes valid: ${sosRes['success']}');
        if (sosRes['success']) {
          Get.snackbar(
            'Success',
            'SOS number updated successfully',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(
              seconds: 2,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          Timer(Duration(seconds: 2), Get.back);
        } else {
          Get.snackbar(
            'Error',
            'SOS number not updated',
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
