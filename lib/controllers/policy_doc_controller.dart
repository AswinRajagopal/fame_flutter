import 'dart:async';
import 'dart:io';

import 'package:fame/views/policy_doc_list.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PolicyDocController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List docList = [].obs;
  final List clientList = [].obs;

  void getPolicies() async {
    docList.clear();
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getPolicyDocs();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['documentList'] != null) {
            for (var i = 0; i < res['documentList'].length; i++) {
              docList.add(res['documentList'][i]);
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


  Future uploadDoc(File imageFile, String label) async {
    try {
      await pr.show();
      var uploadNewDoc = await RemoteServices().uploadPolicyDoc(imageFile, label);
      if (uploadNewDoc != null) {
        if (uploadNewDoc['success']) {
          await pr.hide();
          Get.snackbar(
            null,
            'Document added successfully',
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            backgroundColor: AppUtils().greenColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            borderRadius: 5.0,
          );
          Timer(Duration(seconds: 2), () {
            Get.off(PolicyDocs());
          });
        } else {
          showError();
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
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
      return false;
    }
  }
  void showError() async {
    await pr.hide();
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
