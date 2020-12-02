import 'dart:async';

import '../views/login_page.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignupController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;

  void registerUser(
    username,
    empid,
    password,
    mobile,
    fullname,
    email,
    companyname,
  ) async {
    try {
      await pr.show();
      var signupResponse = await RemoteServices.signup(
        username,
        empid,
        password,
        mobile,
        fullname,
        email,
        companyname,
      );
      if (signupResponse != null) {
        await pr.hide();
        print('signupResponse valid: ${signupResponse.success}');
        if (signupResponse.success) {
          // storeDetail(signupResponse);
          Get.snackbar(
            'Success',
            'Account created, you will be redirected to login page',
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
            'Account not created',
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
