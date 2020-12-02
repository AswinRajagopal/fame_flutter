import '../models/profile.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  // var userDetail = <Profile>.obs;
  Profile profileResponse;
  ProgressDialog pr;

  @override
  void onInit() {
    getEmpDeails();
    super.onInit();
  }

  void getEmpDeails() async {
    try {
      isLoading(true);
      // await pr.show();
      profileResponse = await RemoteServices().getEmpDetails();
      if (profileResponse != null) {
        isLoading(false);
        // await pr.hide();
        print('profileResponse valid: ${profileResponse.success}');
        if (profileResponse.success) {
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
      isLoading(false);
      // await pr.hide();
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
      isLoading(false);
      // await pr.hide();
    }
  }
}
