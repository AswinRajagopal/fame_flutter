import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AttendanceController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List clientList = [].obs;
  final List timings = [].obs;
  var shiftTime;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), getClientTimings);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getClientTimings() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getClientTimings();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        // print('res valid: $res');
        if (res.success) {
          for (var i = 0; i < res.clientsandManpowerArrList.length; i++) {
            clientList.add(res.clientsandManpowerArrList[i]);
          }
          // print('clientList: $clientList');
        } else {
          Get.snackbar(
            'Error',
            'Client not found',
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
