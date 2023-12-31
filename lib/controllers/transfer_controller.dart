import 'dart:async';

import 'package:fame/controllers/dbcal_controller.dart';
import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TransferController extends GetxController {
  var isLoading = true.obs;
  DBCalController calController = Get.put(DBCalController());
  ProgressDialog pr;
  var shiftRes;
  var res;
  final List shiftList = [];
  final List checkList = [];
  final List stores=[].obs;
  bool isDisposed = false;
  final List transferList = [].obs;

  void getShift(clientId) async {
    shiftList.clear();
    checkList.clear();
    try {
      isLoading(true);
      // await pr.show();
      var res = await RemoteServices().getShift(clientId);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        update();
        print('shiftRes valid: $res');
        if (res['success']) {
          if (res['manpowerReqList'] != null) {
            for (var i = 0; i < res['manpowerReqList'].length; i++) {
              // print(res['manpowerReqList'][i]['shift']);
              // print(checkList.contains(res['manpowerReqList'][i]['shift']));
              if (!checkList.contains(res['manpowerReqList'][i]['shift'])) {
                shiftList.add(res['manpowerReqList'][i]);
                checkList.add(res['manpowerReqList'][i]['shift']);
              }
            }
          }
          print('shiftRes: $shiftList');
        } else {
          Get.snackbar(
            null,
            'Shift not found',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
        }
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      update();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
    }
  }

  void getStores()async{
    stores.clear();
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getStores();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        update();
        if (res['success']) {
          print('storeRes:$res');
          if (res['storeNames'] != null) {
            for (var i = 0; i < res['storeNames'].length; i++) {
              stores.add(res['storeNames'][i]);
            }
          }
          // print('leaveList: $leaveList');
        } else {
          Get.snackbar(
            null,
            'stores not found',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
        }
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      update();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
    }
  }

  void newTransfer(employeeId, fromPeriod, toPeriod, currentUnit, shift, toUnit,storeCode) async {
    try {
      await pr.show();
      var transferRes = await RemoteServices().newTransfer(employeeId, fromPeriod, toPeriod, currentUnit, shift, toUnit,storeCode);
      if (transferRes != null) {
        await pr.hide();
        print('transferRes valid: ${transferRes['success']}');
        if (transferRes['success']) {
          Get.snackbar(
            null,
            'Transfer addedd successfully',
            colorText: Colors.white,
            backgroundColor: AppUtils().greenColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
            duration: Duration(
              seconds: 2,
            ),
          );
          Timer(Duration(seconds: 2), () {
            Get.back();
            getTransferList();
          });
        } else {
          Get.snackbar(
            null,
            'Transfer add failed',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
        }
      }
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
    }
  }



  void newRoster(employeeId, fromPeriod, toPeriod, currentUnit, shift, toUnit,storeCode,clentId,design) async {
    // try {/
      await pr.show();
      var transferRes = await RemoteServices().newRoster(employeeId, fromPeriod, toPeriod, currentUnit, shift, toUnit,storeCode,clentId,design);
      if (transferRes != null) {
        await pr.hide();
        print('transferRes valid: ${transferRes['success']}');
        if (transferRes['success']) {
          Get.snackbar(
            null,
            'Transfer addedd successfully',
            colorText: Colors.white,
            backgroundColor: AppUtils().greenColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
            duration: Duration(
              seconds: 2,
            ),
          );
          Timer(Duration(seconds: 2), () {
            DateTime dateTime = new DateFormat("yyyy-MM-dd").parse(fromPeriod);
            var month =
            '${dateTime.month.toString().padLeft(2, '0')}${dateTime.year.toString().substring(2)}';
            Get.back();
            calController.getRoster(month, employeeId);
          });
        } else {
          Get.snackbar(
            null,
            'Transfer add failed',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
        }
      }
    // } catch (e) {
    //   print(e);
    //   await pr.hide();
    //   Get.snackbar(
    //     null,
    //     'Something went wrong! Please try again later',
    //     colorText: Colors.white,
    //     backgroundColor: Colors.black87,
    //     snackPosition: SnackPosition.BOTTOM,
    //     margin: EdgeInsets.symmetric(
    //       horizontal: 8.0,
    //       vertical: 10.0,
    //     ),
    //     padding: EdgeInsets.symmetric(
    //       horizontal: 12.0,
    //       vertical: 18.0,
    //     ),
    //     borderRadius: 5.0,
    //   );
    // }
  }

  void getTransferList() async {
    transferList.clear();
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getTransferList();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res.success) {
          if (res.transferList != null) {
            for (var i = 0; i < res.transferList.length; i++) {
              transferList.add(res.transferList[i]);
            }
          }
          // print('leaveList: $leaveList');
        } else {
          Get.snackbar(
            null,
            'Transfer not found',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
        }
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
    }
  }

  void aprRejTransfer(empId, clientId, orderId, status) async {
    try {
      await pr.show();
      var appRejRes = await RemoteServices().aprRejTransfer(empId, clientId, orderId, status);
      if (appRejRes != null) {
        await pr.hide();
        print('appRejRes: $appRejRes');
        if (appRejRes['success']) {
          Get.snackbar(
            null,
            'Transfer request updated',
            colorText: Colors.white,
            backgroundColor: AppUtils().greenColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
            duration: Duration(
              seconds: 2,
            ),
          );
          getTransferList();
        } else {
          Get.snackbar(
            null,
            'Transfer request not updated',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
        }
      }
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
    }
  }
}
