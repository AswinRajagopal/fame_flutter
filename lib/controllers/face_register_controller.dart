import 'dart:convert';
import 'dart:io';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FaceRegisterController extends GetxController {
  ProgressDialog pr;
  var faceRes;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: missing_return
  Future<bool> uploadImage(File imageFile, String endPoint) async {
    try {
      await pr.show();
      faceRes = await RemoteServices().registerFace(imageFile, endPoint);
      if (faceRes != null) {
        await pr.hide();
        print('faceRes valid: ${faceRes.success}');
        if (faceRes.success) {
          var resDecode = jsonDecode(faceRes.response);
          print('resDecode: $resDecode');
          if (!resDecode['msg'].toString().contains('already seen') && !resDecode['msg'].toString().contains('no face') && !resDecode['msg'].toString().contains('failed')) {
            var regImg = await RemoteServices().registerImage(
              resDecode['clientID'],
              resDecode['companyID'],
              resDecode['image0'],
            );
            print(regImg);
            if (regImg != null && regImg['success']) {
              return true;
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
              return false;
            }
          } else {
            Get.snackbar(
              null,
              'Try again',
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
            return false;
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
          return false;
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
      return false;
    }
  }
}
