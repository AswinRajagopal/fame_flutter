import 'dart:async';

import '../connection/remote_services.dart';
import '../views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ResetPasswordController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;
  var resetPasswordRes;

  void verifyOTP(emailId, newPass) async {
    try {
      await pr.show();
      var resetPassword = await RemoteServices().resetPassword(emailId, newPass);
      if (resetPassword != null) {
        await pr.hide();
        print('resetPassword valid: ${resetPassword['success']}');
        if (resetPassword['success']) {
          Get.snackbar(
            'Success',
            'Password reset successfully. You will be redirected shortly',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          Timer(Duration(seconds: 4), () {
            Get.offAll(LoginPage());
          });
          // return true;
        } else {
          Get.snackbar(
            'Error',
            'Something went wrong. Please try again later',
            colorText: Colors.white,
backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          // return false;
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
      // return false;
    }
  }
}
