import 'dart:async';

import '../views/leave_page.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ApplyLeaveController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;
  var leaveRes;
  var appLeaveRes;
  var ltVal = '';
  final List leaveTypeList = [];
  bool isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), getLeaveType);
    // getLeaveType();
  }

  void init() {
    print('init custom');
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void getLeaveType() async {
    if (isDisposed) {
      return;
    }
    try {
      isLoading(true);
      await pr.show();
      var leaveTypeRes = await RemoteServices().leaveType();
      if (leaveTypeRes != null) {
        await pr.hide();
        isLoading(false);
        print('leaveTypeRes valid: $leaveTypeRes');
        if (leaveTypeRes['success']) {
          for (var i = 0; i < leaveTypeRes['leaveTypeList'].length; i++) {
            leaveTypeList.add(leaveTypeRes['leaveTypeList'][i]);
          }
          print('leaveTypeList: $leaveTypeList');
        } else {
          Get.snackbar(
            'Error',
            'Leave type not found',
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

  void applyLeave(frmDt, toDt, reason, dayType, leaveTypeId) async {
    try {
      await pr.show();
      var appLeaveRes = await RemoteServices().applyLeave(
        frmDt,
        toDt,
        reason,
        dayType,
        leaveTypeId,
      );
      if (appLeaveRes != null) {
        await pr.hide();
        print('appLeaveRes valid: ${appLeaveRes.success}');
        if (appLeaveRes.success) {
          Get.snackbar(
            'Success',
            'Leave applied',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          Timer(Duration(seconds: 2), () {
            Get.offAll(LeavePage());
          });
        } else {
          Get.snackbar(
            'Error',
            'Leave does not applied',
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
