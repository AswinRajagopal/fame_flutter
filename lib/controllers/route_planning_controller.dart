import 'dart:async';

import '../views/dashboard_page.dart';
import 'package:flutter/material.dart';

import '../connection/remote_services.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RoutePlanningController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;
  var allClientRes;
  bool isDisposed = false;
  final List clientList = [];
  final List mapCL = [].obs;
  final List mapID = [].obs;
  List sC = [].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), getClient);
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void getClient() async {
    if (isDisposed) {
      return;
    }
    try {
      isLoading(true);
      await pr.show();
      var clientRes = await RemoteServices().getClients();
      if (clientRes != null) {
        await pr.hide();
        isLoading(false);
        print('clientRes valid: $clientRes');
        if (clientRes['success']) {
          for (var i = 0; i < clientRes['clientsList'].length; i++) {
            clientList.add(clientRes['clientsList'][i]);
          }
          print('clientsList: $clientList');
        } else {
          Get.snackbar(
            'Error',
            'Client not found',
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

  void saveRPlan(assignedTo, planName, date, pitstops) async {
    try {
      await pr.show();
      var saveRplanRes = await RemoteServices().saveRoutePlan(
        assignedTo,
        planName,
        date,
        pitstops,
      );
      if (saveRplanRes != null) {
        await pr.hide();
        print('saveRplanRes valid: ${saveRplanRes.success}');
        if (saveRplanRes.success) {
          Get.snackbar(
            'Success',
            'Route plan created',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          Timer(Duration(seconds: 2), () {
            Get.offAll(DashboardPage());
          });
        } else {
          Get.snackbar(
            'Error',
            'Route plan not created',
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
