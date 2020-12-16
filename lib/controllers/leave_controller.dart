import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LeaveController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List leaveList = [];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), getLeaveList);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getLeaveList() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getLeaveList();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        // print('res valid: $res');
        if (res.success) {
          for (var i = 0; i < res.leaveList.length; i++) {
            leaveList.add(res.leaveList[i]);
          }
          print('leaveList: $leaveList');
        } else {
          Get.snackbar(
            'Error',
            'Leave not found',
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
