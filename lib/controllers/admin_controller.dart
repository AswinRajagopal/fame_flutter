import 'dart:async';

import '../utils/utils.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AdminController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;
  var resAddShift;
  var resAddClient;
  var resAddEmployee;
  final List clientList = [].obs;
  final List desList = [].obs;
  final List shiftList = [].obs;
  final List checkList = [];

  void addShift(shiftName, startTime, endTime) async {
    try {
      await pr.show();
      resAddShift = await RemoteServices().addShift(shiftName, startTime, endTime);
      if (resAddShift != null) {
        await pr.hide();
        // print('res valid: $res');
        if (resAddShift['success']) {
          Get.snackbar(
            null,
            'Shift created successfully',
            colorText: Colors.white,
            duration: Duration(seconds: 2),
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
          );
          Timer(Duration(seconds: 2), Get.back);
        } else {
          Get.snackbar(
            null,
            'Shift not created',
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

  void addClient(name, phone, clientId, inchargeId, address, lat, lng) async {
    try {
      await pr.show();
      resAddClient = await RemoteServices().addClient(name, phone, clientId, inchargeId, address, lat, lng);
      if (resAddClient != null) {
        await pr.hide();
        // print('res valid: $res');
        if (resAddClient['success']) {
          Get.snackbar(
            null,
            'Client created successfully',
            colorText: Colors.white,
            duration: Duration(seconds: 2),
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
          );
          Timer(Duration(seconds: 2), Get.back);
        } else {
          Get.snackbar(
            null,
            'Client not created',
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

  void getClient() async {
    clientList.clear();
    try {
      isLoading(true);
      await pr.show();
      var getClientRes = await RemoteServices().getClients();
      if (getClientRes != null) {
        await pr.hide();
        isLoading(false);
        // print('getClientRes valid: $getClientRes');
        if (getClientRes['success']) {
          for (var i = 0; i < getClientRes['clientsList'].length; i++) {
            clientList.add(getClientRes['clientsList'][i]);
          }
          // print('clientsList: $clientList');
        } else {
          // Get.snackbar(
          //   null,
          //   'Client not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
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

  void getDesignation() async {
    desList.clear();
    try {
      isLoading(true);
      await pr.show();
      var getDesRes = await RemoteServices().getDesignation();
      if (getDesRes != null) {
        await pr.hide();
        isLoading(false);
        // print('getClientRes valid: $getClientRes');
        if (getDesRes['success']) {
          for (var i = 0; i < getDesRes['designationsList'].length; i++) {
            desList.add(getDesRes['designationsList'][i]);
          }
          // print('clientsList: $clientList');
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

  void getShift(clientId) async {
    shiftList.clear();
    checkList.clear();
    try {
      isLoading(true);
      await pr.show();
      var getShiftRes = await RemoteServices().getShiftByClient(clientId);
      if (getShiftRes != null) {
        await pr.hide();
        isLoading(false);
        // print('getClientRes valid: $getClientRes');
        if (getShiftRes['success']) {
          for (var i = 0; i < getShiftRes['manpowerReqList'].length; i++) {
            if (!checkList.contains(getShiftRes['manpowerReqList'][i]['shift'])) {
              shiftList.add(getShiftRes['manpowerReqList'][i]);
              checkList.add(getShiftRes['manpowerReqList'][i]['shift']);
            }
          }
          // print('clientsList: $clientList');
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

  void addEmployee(name, address, email, phone, empid, sitePostedTo, gender, dob, design, shift) async {
    try {
      await pr.show();
      resAddEmployee = await RemoteServices().addEmployee(name, address, email, phone, empid, sitePostedTo, gender, dob, design, shift);
      if (resAddEmployee != null) {
        await pr.hide();
        // print('res valid: $res');
        if (resAddEmployee['success']) {
          Get.snackbar(
            null,
            'Employee created successfully',
            colorText: Colors.white,
            duration: Duration(seconds: 2),
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
          );
          Timer(Duration(seconds: 2), Get.back);
        } else {
          Get.snackbar(
            null,
            'Employee not created',
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
