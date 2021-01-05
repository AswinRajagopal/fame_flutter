import 'package:flutter/material.dart';

import '../connection/remote_services.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SupportController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;

  void getSupport() async {
    // print('pr: $pr');
    // print('fromWhere: $fromWhere');
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getSupport();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res.success) {
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
}
