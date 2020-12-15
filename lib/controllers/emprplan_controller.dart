import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmprplanController extends GetxController {
  var isEmpLoading = true.obs;
  var empRes;
  bool isDisposed = false;

  @override
  void onInit() {
    // getEmprPlan();
    super.onInit();
  }

  void init() {
    // if (isDisposed) return;
    print('init custom');
    getEmprPlan();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void getEmprPlan() async {
    try {
      isEmpLoading(true);
      empRes = await RemoteServices().getEmprPlan();
      if (empRes != null) {
        isEmpLoading(false);
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
