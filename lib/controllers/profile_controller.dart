import '../models/profile.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  // var userDetail = <Profile>.obs;
  Profile profileRes;
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

  void init() {
    print('init custom');
    getEmpDeails();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void getEmpDeails() async {
    if (isDisposed) {
      return;
    }
    try {
      isLoading(true);
      await pr.show();
      profileRes = await RemoteServices().getEmpDetails();
      if (profileRes != null) {
        isLoading(false);
        await pr.hide();
        print('profileRes valid: ${profileRes.success}');
        if (profileRes.success) {
          if (profileRes.profileImage == null) {
            endPoint = 'register';
            await RemoteServices().box.put('pImg', '');
          } else {
            endPoint = 'update_image';
            await RemoteServices().box.put('pImg', profileRes.profileImage.image.split(',').last);
          }
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
    }
  }
}
