import 'dart:convert';

import 'package:fame/controllers/otp_login_controller.dart';

import '../views/dashboard_page.dart';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;
  RemoteServices rs = new RemoteServices();

  @override
  void onInit() {
    super.onInit();
    clearBox();
  }

  void loginUser(username, empid, password, lite) async {
    try {
      await pr.show();
      RemoteServices().box.put('lite', lite);
      var loginResponse = await rs.login(username, empid, password);
      if (loginResponse != null) {
        print('loginResponse valid: ${loginResponse.valid}');
        if (loginResponse.valid) {
          // Get.snackbar(
          //   null,
          //   'Employee found',
          //   colorText: Colors.white,
          //   backgroundColor: AppUtils().greenColor,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
          if (loginResponse.appFeature.validateOtp!=null &&
              loginResponse.appFeature.validateOtp &&
          loginResponse.loginDetails.mobileNumber !=null &&
              loginResponse.loginDetails.mobileNumber.length==10){
            final OtpLoginController olC = Get.put(OtpLoginController());
            await olC.verifyPhone('+91'+loginResponse.loginDetails.mobileNumber);
          }else {
            await pr.hide();
            storeDetail(loginResponse);
            await Get.offAll(DashboardPage());
          }
        } else {
          await pr.hide();
          Get.snackbar(
            null,
            'Username and password are incorrect',
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

  void storeDetail(loginResponse) {
    RemoteServices().box.put('id', loginResponse.loginDetails.id);
    RemoteServices().box.put('empid', loginResponse.loginDetails.empId);
    RemoteServices().box.put('email', loginResponse.loginDetails.emailId);
    RemoteServices().box.put('role', loginResponse.loginDetails.role);
    RemoteServices().box.put('companyid', loginResponse.loginDetails.companyId);
    RemoteServices().box.put('companyname', loginResponse.companyDetails.companyName);
    RemoteServices().box.put('userName', loginResponse.loginDetails.userName);
    RemoteServices().box.put('appFeature', jsonEncode(loginResponse.appFeature));
  }

  void clearBox() {
    RemoteServices().box.deleteAll([
      'id',
      'empid',
      'email',
      'role',
      'companyid',
      'companyname',
      'userName',
      'appFeature',
      'shift',
      'clientId',
      'empName',
    ]);
  }
}
