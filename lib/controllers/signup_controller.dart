import 'dart:async';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignupController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;
  var signupResponse;

  Future<bool> registerUser(
    username,
    empid,
    empNo,
    password,
    mobile,
    fullname,
    email,
    companyname,
  ) async {
    try {
      await pr.show();
      signupResponse = await RemoteServices.signup(
        username,
        empid,
        empNo,
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
            'Account created, please verify mobile by otp',
            colorText: Colors.white,
            backgroundColor: AppUtils().greenColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          // Timer(Duration(seconds: 4), () {
          //   Get.offAll(LoginPage());
          // });
          return true;
        } else {
          Get.snackbar(
            'Error',
            'Account not created',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          return false;
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
      return false;
    } finally {
      await pr.hide();
      return signupResponse.success;
    }
  }
}
