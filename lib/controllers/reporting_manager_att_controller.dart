import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RepoManagerAttController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List repoAttViewList = [].obs;
  final List empDetailsList = [].obs;

  void getRepoManagerEmpAtt(date) async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getRepoManagerEmpAtt(date);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['dailyAttViewList'] != null) {
            for (var i = 0; i < res['dailyAttViewList'].length; i++) {
              repoAttViewList.add(res['dailyAttViewList'][i]);
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

  void getRepoManagerEmpDt() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getRepoManagerEmpDt();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          print("repoRes:$res");
          if (res['empdetails'] != null) {
            for (var i = 0; i < res['empdetails'].length; i++) {
              empDetailsList.add(res['empdetails'][i]);
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
}
