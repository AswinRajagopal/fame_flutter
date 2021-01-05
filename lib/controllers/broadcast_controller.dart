import 'dart:async';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class BroadcastController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List broadcastList = [].obs;
  final List clientList = [].obs;

  void getBroadcast() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getBroadcast();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['broadcastLust'] != null) {
            for (var i = 0; i < res['broadcastLust'].length; i++) {
              broadcastList.add(res['broadcastLust'][i]);
            }
          }
        } else {
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

  void getClient() async {
    clientList.clear();
    try {
      isLoading(true);
      await pr.show();
      var clientRes = await RemoteServices().getClients();
      if (clientRes != null) {
        await pr.hide();
        isLoading(false);
        // print('clientRes valid: $clientRes');
        if (clientRes['success']) {
          for (var i = 0; i < clientRes['clientsList'].length; i++) {
            clientList.add(clientRes['clientsList'][i]);
          }
          // print('clientsList: $clientList');
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

  void newBroadcast(empId, broadcast) async {
    try {
      await pr.show();
      var broadcastRes = await RemoteServices().newBroadcast(empId, broadcast);
      if (broadcastRes != null) {
        await pr.hide();
        print('broadcastRes valid: ${broadcastRes['success']}');
        if (broadcastRes['success']) {
          Get.snackbar(
            'Success',
            'Broadcast sent successfully',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(
              seconds: 2,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          Timer(Duration(seconds: 2), Get.back);
        } else {
          Get.snackbar(
            'Error',
            'Broadcast send failed',
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
