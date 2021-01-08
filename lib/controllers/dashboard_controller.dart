import 'dart:async';

import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isDashboardLoading = true.obs;
  var response;
  var todayString = (DateFormat.E().format(DateTime.now()).toString() + ' ' + DateFormat.d().format(DateTime.now()).toString() + ' ' + DateFormat.MMM().format(DateTime.now()).toString() + ', ' + DateFormat('h:mm').format(DateTime.now()).toString() + '' + DateFormat('a').format(DateTime.now()).toString().toLowerCase()).obs;
  var greetings = '...'.obs;
  bool isDisposed = false;

  @override
  void onInit() {
    print('dbc onInit');
    // getDashboardDetails();
    // updateTime();
    super.onInit();
  }

  void init({context}) {
    // if (isDisposed) return;
    print('init custom');
    getDashboardDetails(context: context);
    updateTime();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value = DateFormat.E().format(DateTime.now()).toString() + ' ' + DateFormat.d().format(DateTime.now()).toString() + ' ' + DateFormat.MMM().format(DateTime.now()).toString() + ', ' + DateFormat('h:mm').format(DateTime.now()).toString() + '' + DateFormat('a').format(DateTime.now()).toString().toLowerCase();

      var hour = DateTime.now().hour;
      if (hour < 12) {
        greetings.value = 'Morning';
      } else if (hour < 17) {
        greetings.value = 'Afternoon';
      } else {
        greetings.value = 'Evening';
      }
    });
  }

  void getDashboardDetails({context}) async {
    try {
      isDashboardLoading(true);
      response = await RemoteServices().getDbDetails();
      // print('response: $response');
      if (response != null) {
        if (response['success']) {
          if (response['dailyAttendance'] != null) {
            await RemoteServices().box.put('shift', response['dailyAttendance']['shift']);
            await RemoteServices().box.put('clientId', response['dailyAttendance']['clientId']);
          } else {
            await RemoteServices().box.put('shift', response['empdetails']['shift']);
            await RemoteServices().box.put('clientId', response['clientData']['id']);
          }
          await RemoteServices().box.put('empName', response['empdetails']['name']);
          await RemoteServices().box.put('faceApi', response['clientData']['faceApi']);
          if (response['empdetails']['empStatus'] != 1 && response['companyActive'] != true) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Text('Error'),
                  content: Text(
                    'Your account is blocked. Please contact your Company Admin',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        RemoteServices().logout();
                      },
                      child: Text('OKAY'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            isDashboardLoading(false);
          }
        } else {
          isDashboardLoading(false);
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
    } catch (e) {
      print(e);
      isDashboardLoading(false);
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
