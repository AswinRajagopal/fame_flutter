import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmprplanController extends GetxController {
  var isEmpLoading = true.obs;
  var empRes;
  bool isDisposed = false;
  ProgressDialog pr;

  @override
  void onInit() {
    // getEmprPlan();
    super.onInit();
  }

  void init({fromWhere}) {
    // if (isDisposed) return;
    print('init custom');
    getEmprPlan(fromWhere: fromWhere);
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void getEmprPlan({fromWhere}) async {
    print('getEmprPlan');
    // print('pr: $pr');
    // print('fromWhere: $fromWhere');
    try {
      isEmpLoading(true);
      if (pr != null && fromWhere == null) {
        await pr.show();
      }
      empRes = await RemoteServices().getEmprPlan();
      if (empRes != null) {
        isEmpLoading(false);
        if (pr != null && fromWhere == null) {
          await pr.hide();
        }
        if (empRes.success) {
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
      isEmpLoading(false);
      if (pr != null && fromWhere == null) {
        await pr.hide();
      }
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
      // isLoading(false);
      // await pr.hide();
    }
  }
}
