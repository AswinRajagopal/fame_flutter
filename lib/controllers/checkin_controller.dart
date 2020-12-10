import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CheckinController extends GetxController {
  ProgressDialog pr;
  var checkinResponse;
  var todayString =
      (DateFormat().add_jm().format(DateTime.now()).toString()).obs;

  @override
  void onInit() {
    updateTime();
    super.onInit();
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value =
          DateFormat().add_jm().format(DateTime.now()).toString();
    });
  }

  // ignore: missing_return
  Future<bool> uploadImage(File imageFile) async {
    try {
      await pr.show();
      checkinResponse = await RemoteServices().checkinProcess(imageFile);
      if (checkinResponse != null) {
        await pr.hide();
        print('checkinResponse valid: ${checkinResponse.success}');
        if (checkinResponse.success) {
          var resDecode = jsonDecode(checkinResponse.response);
          if (!resDecode['face_found']) {
            Get.snackbar(
              'Error',
              'Face not detected. Please take a picture again',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else if (resDecode['n_faces'] > 1) {
            Get.snackbar(
              'Error',
              'More then one face detected.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else {
            return true;
          }
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
          return false;
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
      return false;
    } finally {
      await pr.hide();
      // return checkinResponse.success;
    }
  }
}
