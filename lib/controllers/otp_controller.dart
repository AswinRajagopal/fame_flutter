import 'dart:async';

import '../connection/remote_services.dart';
import '../views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class OTPController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;

  void verifyOTP(mobile, otp) async {
    try {
      await pr.show();
      var otpResponse = await RemoteServices.otpverify(
        mobile,
        otp,
      );
      if (otpResponse != null) {
        await pr.hide();
        print('otpResponse valid: ${otpResponse.success}');
        if (otpResponse.success) {
          // storeDetail(otpResponse);
          Get.snackbar(
            'Success',
            'OTP verified successfully. You will be redirected shortly',
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
            'OTP is wrong',
            colorText: Colors.white,
            backgroundColor: Colors.red,
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
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
      );
      // return false;
    } finally {
      await pr.hide();
      // return false;
    }
  }
}
