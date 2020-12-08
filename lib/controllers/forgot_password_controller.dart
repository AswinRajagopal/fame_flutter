import 'dart:async';

import '../views/login_page.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ForgotPasswordController extends GetxController {
  ProgressDialog pr;

  void forgotPassword(email) async {
    try {
      await pr.show();
      var fpResponse = await RemoteServices.forgorPassword(email);
      if (fpResponse != null) {
        await pr.hide();
        print('fpResponse valid: ${fpResponse.success}');
        if (fpResponse.success) {
          Get.snackbar(
            'Success',
            'Please check your email. You will be redirected shortly',
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
        } else {
          Get.snackbar(
            'Error',
            'Email address is not associated with any account',
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
    } finally {
      await pr.hide();
    }
  }
}
