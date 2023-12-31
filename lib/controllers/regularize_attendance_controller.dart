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
  List notationList=[].obs;
  bool isDisposed = false;



  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

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

  void updateRegAtt(checkIn,checkOut,alias,status,adminRemarks,regAttId) async {
    try {
      await pr.show();
      var addRegAttRes = await RemoteServices().updateRegAtt(checkIn,checkOut,alias,status,adminRemarks,regAttId);
      if (addRegAttRes != null) {
        await pr.hide();
        if (addRegAttRes['success']) {
          regAttList.clear();
          Get.snackbar(
            null,
            'Status Updated successfully',
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
          Future.delayed(Duration(milliseconds:2500), ()  {
            // Call the API function here
           getRegularizeAtt();
          });
          Future.delayed(Duration(milliseconds:2800), ()  {
           Get.back();
          });
        } else {
          Get.snackbar(
            null,
            'Status failed',
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

  void getAllRegNotations() async {
    if (isDisposed) {
      return;
    }
    try {
      isLoading(true);
      await pr.show();
      var notationTypeRes = await RemoteServices().getAllRegNotations();
      if (notationTypeRes != null) {
        await pr.hide();
        isLoading(false);
        print('notationTypeRes valid: $notationTypeRes');
        if (notationTypeRes['success']) {
          for (var i = 0; i < notationTypeRes['notationsList'].length; i++) {
            notationList.add(notationTypeRes['notationsList'][i]);
          }
          print('notationsList: $notationList');
        } else {
          Get.snackbar(
            null,
            'Alias type not found',
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


  void addRegularizeAtt(alias, checkIn, checkOut,attId,reason) async {
    try {
      await pr.show();
      var addRegAttRes = await RemoteServices().addRegularizeAtt(alias,checkIn,checkOut,attId,reason);
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
