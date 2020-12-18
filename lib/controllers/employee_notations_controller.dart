import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EmployeeNotationsController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List designation = [].obs;
  final List notations = [].obs;
  // final List timings = [].obs;
  // var shiftTime;
  var p = 0.obs;
  var wo = 0.obs;
  var l = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getNotations(
    date,
    shift,
    clientId,
    orderBy,
    checkFilter,
  ) async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getNotations(
        date,
        shift,
        clientId,
        orderBy,
        checkFilter,
      );
      if (res != null) {
        isLoading(false);
        await pr.hide();
        // print('res valid: $res');
        if (res['success']) {
          // print('clientList: $clientList');
          // print(res.empDailyAttView);
          // print('here: ${res.attendanceNotations}');
          for (var j = 0; j < res['empDailyAttView'].length; j++) {
            if (res['empDailyAttView'][j]['attendanceAlias'] == 'P') {
              p.value++;
            } else if (res['empDailyAttView'][j]['attendanceAlias'] == 'WO') {
              wo.value++;
            } else if (res['empDailyAttView'][j]['attendanceAlias'] == 'L') {
              l.value++;
            }
          }
          for (var i = 0; i < res['designationsList'].length; i++) {
            designation.insert(
              int.parse(res['designationsList'][i]['designId']),
              res['designationsList'][i]['design'],
            );
          }
        } else {
          // Get.snackbar(
          //   'Error',
          //   'Notations not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.red,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
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

  Future<bool> giveAttendance(
    date,
    shift,
    clientId,
    alies,
    empId,
    designation,
    remarks,
    startTime,
    endTime,
  ) async {
    try {
      await pr.show();
      var attRes = await RemoteServices().giveAttendance(
        date,
        shift,
        clientId,
        alies,
        empId,
        designation,
        remarks,
        startTime,
        startTime,
      );
      if (attRes != null) {
        await pr.hide();
        if (attRes['success']) {
          return true;
        } else {
          Get.snackbar(
            'Error',
            'Attendance not given',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      print(e);
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
      return false;
    }
  }
}
