import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmprplanController extends GetxController {
  var isEmpLoading = true.obs;
  var empRes;
  bool isDisposed = false;
  ProgressDialog pr;

  @override
  void onInit() {
    // getEmprPlan();
    super.onInit();
  }

  void init({fromWhere}) {
    // if (isDisposed) return;
    print('init custom');
    getEmprPlan(fromWhere: fromWhere);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   isDisposed = true;
  // }

  void getEmprPlan({fromWhere}) async {
    print('getEmprPlan');
    // print('pr: $pr');
    // print('fromWhere: $fromWhere');
    try {
      isEmpLoading(true);
      if (pr != null && fromWhere == null) {
        await pr.show();
      }
      empRes = await RemoteServices().getEmprPlan();
      if (empRes != null) {
        isEmpLoading(false);
        if (pr != null && fromWhere == null) {
          await pr.hide();
        }
        if (empRes.success) {
        } else {
          // Get.snackbar(
          //   null,
          //   'Something went wrong! Please try again later',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
        }
      }
    } catch (e) {
      print(e);
      isEmpLoading(false);
      if (pr != null && fromWhere == null) {
        await pr.hide();
      }
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
    } finally {
      // isLoading(false);
      // await pr.hide();
    }
  }

  void aprRejRoutePlan(index, id, status) async {
    try {
      await pr.show();
      var appRejRes = await RemoteServices().aprRejRoutePlan(id, status);
      if (appRejRes != null) {
        await pr.hide();
        // print('res valid: $res');
        if (appRejRes['success']) {
          print('here');
          empRes.routePlanList.clear();
          getEmprPlan();
        } else {
          Get.snackbar(
            null,
            'Route Plan not updated',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
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
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    }
  }
}
