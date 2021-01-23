import 'dart:async';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
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
            null,
            'OTP verified successfully. You will be redirected shortly',
            colorText: Colors.white,
            backgroundColor: AppUtils().greenColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
          Timer(Duration(seconds: 4), () {
            Get.offAll(LoginPage());
          });
          // return true;
        } else {
          Get.snackbar(
            null,
            'OTP is wrong',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
          // return false;
        }
      }
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
      // return false;
    }
  }

  Future<bool> verifyForgotOTP(email, otp, context) async {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Processing please wait...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    pr.style(
      backgroundColor: Colors.white,
    );
    try {
      await pr.show();
      var forgotOtpResponse = await RemoteServices().forgotOtpVerify(email, otp);
      if (forgotOtpResponse != null) {
        await pr.hide();
        print('forgotOtpResponse valid: ${forgotOtpResponse['success']}');
        if (forgotOtpResponse['success'] != null && forgotOtpResponse['success']) {
          // Get.snackbar(
          //   null,
          //   'OTP verified successfully.',
          //   colorText: Colors.white,
          //   backgroundColor: AppUtils().greenColor,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
          return true;
        } else {
          Get.snackbar(
            null,
            'OTP is wrong',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
      return false;
    }
  }
}
