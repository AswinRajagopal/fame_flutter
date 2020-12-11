import 'dart:async';

import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isDashboardLoading = true.obs;
  var response;
  var todayString = (DateFormat.E().format(DateTime.now()).toString() +
          ' ' +
          DateFormat.d().format(DateTime.now()).toString() +
          ' ' +
          DateFormat.MMM().format(DateTime.now()).toString() +
          ', ' +
          DateFormat('h:mm').format(DateTime.now()).toString() +
          '' +
          DateFormat('a').format(DateTime.now()).toString().toLowerCase())
      .obs;
  var greetings = '...'.obs;

  @override
  void onInit() {
    print('dbc onInit');
    // getDashboardDetails();
    // updateTime();
    super.onInit();
  }

  void init() {
    print('init custom');
    getDashboardDetails();
    updateTime();
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value = DateFormat.E().format(DateTime.now()).toString() +
          ' ' +
          DateFormat.d().format(DateTime.now()).toString() +
          ' ' +
          DateFormat.MMM().format(DateTime.now()).toString() +
          ', ' +
          DateFormat('h:mm').format(DateTime.now()).toString() +
          '' +
          DateFormat('a').format(DateTime.now()).toString().toLowerCase();

      var hour = DateTime.now().hour;
      if (hour < 12) {
        greetings.value = 'morning';
      } else if (hour < 17) {
        greetings.value = 'afternoon';
      } else {
        greetings.value = 'evening';
      }
    });
  }

  void getDashboardDetails() async {
    try {
      isDashboardLoading(true);
      print('response:');
      response = await RemoteServices().getDashboardDetails();
      if (response != null) {
        isDashboardLoading(false);
        await RemoteServices().box.put('shift', response.dailyAttendance.shift);
        await RemoteServices()
            .box
            .put('clientId', response.dailyAttendance.clientId);
        if (response.success) {
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
      isDashboardLoading(false);
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
