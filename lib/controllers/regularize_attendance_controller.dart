import 'dart:async';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../views/dashboard_page.dart';


class RegularizeAttController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  List regAttList = [].obs;

  void getRegularizeAtt() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getRegularizeAtt();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['regularizeAttList'] != null) {
            for (var i = 0; i < res['regularizeAttList'].length; i++) {
              regAttList.add(res['regularizeAttList'][i]);
            }
          }
        } else {
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

  void updateRegAtt(status,regAttId) async {
    try {
      await pr.show();
      var addRegAttRes = await RemoteServices().updateRegAtt(status,regAttId);
      if (addRegAttRes != null) {
        await pr.hide();
        if (addRegAttRes['success']) {
          Get.snackbar(
            null,
            'Approved successfully',
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
          Timer(Duration(seconds: 2), Get.back);
          Future.delayed(Duration(seconds:3), ()  {
            // Call the API function here
            regAttList.clear();
          });
          Future.delayed(Duration(seconds:4), ()  {
            // Call the API function here
           getRegularizeAtt();
          });
        } else {
          Get.snackbar(
            null,
            'Approval failed',
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

  void addRegularizeAtt(alias, checkIn, checkOut,attId) async {
    try {
      await pr.show();
      var addRegAttRes = await RemoteServices().addRegularizeAtt(alias,checkIn,checkOut,attId);
      if (addRegAttRes != null) {
        await pr.hide();
        print('addRegAttRes valid: ${addRegAttRes['success']}');
        if (addRegAttRes['success']) {
          Get.snackbar(
            null,
            'Sent For Approval successfully',
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
            Get.offAll(DashboardPage());
          });
        } else {
          Get.snackbar(
            null,
            'Approval send failed',
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
