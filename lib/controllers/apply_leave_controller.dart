import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import '../views/leave_page.dart';

class ApplyLeaveController extends GetxController {
  var isLoading = true.obs;
  var isLoadingBalance = true.obs;
  ProgressDialog pr;
  var leaveRes;
  var empId="888";
  var appLeaveRes;
  var ltVal = '';
  final List leaveTypeList = [];
  final List leaveBalance = [].obs;
  var reportingManager = 'N/A'.obs;
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
      var leaveTypeRes = await RemoteServices().leaveType(empId);
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
            null,
            'Leave type not found',
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

  void getLeaveBalance() async {
    leaveBalance.clear();
    reportingManager('N/A');
    try {
      isLoadingBalance(true);
      var leaveBalanceRes = await RemoteServices().getLeaveBalance(empId);
      if (leaveBalanceRes != null) {
        isLoadingBalance(false);
        print('leaveBalanceRes: $leaveBalanceRes');
        if (leaveBalanceRes['success']) {
          if (leaveBalanceRes['reportingManager'] != null) reportingManager(leaveBalanceRes['reportingManager']);
          for (var i = 0; i < leaveBalanceRes['leaveTypeList'].length; i++) {
            var leaveType = leaveBalanceRes['leaveTypeList'][i];
            for (var j = 0; j < leaveBalanceRes['empLeaveBalanceList'].length; j++) {
              var leaveBal = leaveBalanceRes['empLeaveBalanceList'][j];
              if (leaveType['leaveTypeId'] == leaveBal['leaveTypeId']) {
                var addLeave = {
                  'value': leaveBal['value'].toString(),
                  'leaveTypeName': leaveType['leaveTypeName'],
                  'fill': double.parse(leaveBal['value'].toString()) / double.parse(leaveType['maxValue'].toString()),
                };
                leaveBalance.add(addLeave);
              }
            }
          }
          print('leaveBalance: $leaveBalance');
        } else {
          Get.snackbar(
            null,
            'Something went wrong while getting leave balance',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            borderRadius: 5.0,
          );
        }
      }
    } catch (e) {
      print(e);
      isLoadingBalance(false);
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    }
  }

  void applyLeave(frmDt, toDt, reason, dayType, leaveTypeId) async {
    try {
      await pr.show();
      var appLeaveRes = await RemoteServices().applyLeave(frmDt, toDt, reason,
          dayType, leaveTypeId, empId);
      if (appLeaveRes != null) {
        await pr.hide();
        print('appLeaveRes valid: ${appLeaveRes['success']}');
        if (appLeaveRes['success']) {
          Get.snackbar(
            null,
            'Leave applied',
            colorText: Colors.white,
            backgroundColor: AppUtils().greenColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            borderRadius: 5.0,
          );
          Timer(Duration(seconds: 2), () {
            Get.offAll(LeavePage());
          });
        } else {
          await showDialog(
            context: Get.context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Leave not applied!',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        appLeaveRes['msg'] ?? 'Leave does not applied',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Okay',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
