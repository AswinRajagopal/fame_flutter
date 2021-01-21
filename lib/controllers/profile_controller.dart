import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  // var userDetail = <Profile>.obs;
  var profileRes;
  ProgressDialog pr;
  var endPoint = 'register';
  bool isDisposed = false;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  // void init() {
  //   print('init custom');
  //   getEmpDetails();
  // }

  void getEmpDetails() async {
    try {
      isLoading(true);
      await pr.show();
      profileRes = await RemoteServices().getEmpDetails();
      print('profileRes valid: $profileRes');
      if (profileRes != null) {
        if (profileRes['success']) {
          if (profileRes['profileImage'] == null) {
            endPoint = 'register';
            await RemoteServices().box.put('pImg', '');
          } else {
            endPoint = 'update_image';
            await RemoteServices().box.put('pImg', profileRes['profileImage']['image'].split(',').last);
          }
        } else {
          Get.snackbar(
            'Message',
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
        isLoading(false);
        await pr.hide();
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      Get.snackbar(
        'Message',
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
