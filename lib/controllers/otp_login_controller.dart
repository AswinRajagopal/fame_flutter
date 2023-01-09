import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import '../views/otp_screen.dart';

class OtpLoginController extends GetxController {
  var isLoading = true.obs;
  ProgressDialog pr;

  void validateMobile(mobile) async {
    try {
      await pr.show();
      var res = await RemoteServices().validateMobile(mobile);
      if (res != null) {
        await pr.hide();
        print('resetPassword valid: ${res['success']}');
        if (res['success']) {
          await pr.hide();
          // await RemoteServices().box.put('UserName', res['Details']['UserName']);
          // await RemoteServices().box.put('Emp_Id', res['Details']['Emp_Id']);
          await verifyPhone('$mobile');
        } else {
          Get.snackbar(
            null,
            'Mobile number not associated with any account',
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
      // return false;
    }
  }

  // void validateMobile(mobile) async {
  //   try {
  //     await pr.show();
  //     var res = await RemoteServices().validateMobile(mobile);
  //     print('mobile: $res');
  //     if (res['success'] == true) {
  //       await pr.hide();
  //       // await RemoteServices().box.put('UserName', res['Details']['UserName']);
  //       // await RemoteServices().box.put('Emp_Id', res['Details']['Emp_Id']);
  //       await verifyPhone('+91$mobile');
  //     } else {
  //       await pr.hide();
  //       Get.snackbar(
  //         null,
  //         'Mobile number not associated with any account',
  //         colorText: AppUtils.snackbarTextColor,
  //         duration: Duration(seconds: 2),
  //         backgroundColor: AppUtils.snackbarbackgroundColor,
  //         snackPosition: SnackPosition.BOTTOM,
  //         margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
  //         padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
  //         borderRadius: 5.0,
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //     await pr.hide();
  //     if (e.toString() == 'DioError [DioErrorType.RESPONSE]: Http status error [500]') {
  //       Get.snackbar(
  //         AppUtils.snackbarTitle,
  //         'Internal Server Error',
  //         colorText: AppUtils.snackbarTextColor,
  //         backgroundColor: AppUtils.snackbarbackgroundColor,
  //         snackPosition: SnackPosition.BOTTOM,
  //         margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
  //         padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
  //         borderRadius: 5.0,
  //       );
  //     }
  //   }
  // }

  Future<void> verifyPhone(phoneNo, {noredirect}) async {
    print('phoneNo: $phoneNo');
    await pr.show();
    // await Firebase.initializeApp();
    var firebaseAuth = await FirebaseAuth.instance;
    // await firebaseAuth.setSettings(
    //   appVerificationDisabledForTesting: true,
    // );
    final PhoneCodeSent smsOTPSent =
        (String verId, [int forceCodeResend]) async {
      await pr.hide();
      // verificationId = verId;
      print('verId: $verId');
      if (noredirect != null) {
        Get.snackbar(
          null,
          'OTP resend successfully.',
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          backgroundColor: AppUtils.snackbarbackgroundColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
      } else {
        await Get.to(OTPScreen(verId, phoneNo));
      }
    };
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        // PHONE NUMBER TO SEND OTP
        codeAutoRetrievalTimeout: (String verId) async {
          //Starts the phone number verification process for the given phone number.
          //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
          // verificationId = verId;
          await pr.hide();
          // if (noredirect != null) {
          //   Get.snackbar(
          //     null,
          //     'OTP resend successfully.',
          //     colorText: Colors.white,
          //     duration: Duration(seconds: 2),
          //     backgroundColor: AppUtils.snackbarbackgroundColorSuccess,
          //     snackPosition: SnackPosition.BOTTOM,
          //     margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          //     padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          //     borderRadius: 5.0,
          //   );
          // } else {
          //   await Get.to(
          //     OTPScreen(
          //       verId,
          //       phoneNo,
          //     ),
          //   );
          // }
        },
        codeSent: smsOTPSent,
        // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential phoneAuthCredential) async {
          await pr.hide();
          if (AuthCredential != null) {
            await RemoteServices().loginUsingPhoneNo(phoneNo);
          }
          print(phoneAuthCredential);
        },
        verificationFailed: (exceptio) async {
          await pr.hide();
          print('${exceptio.message}');
          Get.snackbar(
            AppUtils.snackbarTitle,
            exceptio.message,
            colorText: AppUtils.snackbarTextColor,
            backgroundColor: AppUtils.snackbarbackgroundColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            borderRadius: 5.0,
          );
        },
      );
    } catch (e) {
      await pr.hide();
      handleError(e);
    }
  }

  void handleError(error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        Get.snackbar(
          AppUtils.snackbarTitle,
          'You have entered wrong OTP.',
          colorText: AppUtils.snackbarTextColor,
          backgroundColor: AppUtils.snackbarbackgroundColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
        break;
      case 'ERROR_SESSION_EXPIRED':
        Get.snackbar(
          AppUtils.snackbarTitle,
          'Session of OTP is expired. Please try again.',
          colorText: AppUtils.snackbarTextColor,
          backgroundColor: AppUtils.snackbarbackgroundColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
        break;
      default:
        Get.snackbar(
          AppUtils.snackbarTitle,
          error.message,
          colorText: AppUtils.snackbarTextColor,
          backgroundColor: AppUtils.snackbarbackgroundColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
        break;
    }
  }

  void validateOTP(verificationId, otp) async {
    try {
      await pr.show();
      var firebaseAuth = await FirebaseAuth.instance;
      var credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      var user = await firebaseAuth.signInWithCredential(credential);
      var currentUser = await firebaseAuth.currentUser.phoneNumber;
      print('user: $user');
      if (user != null) {
        if (currentUser != null) {
          await pr.hide();
          await RemoteServices().loginUsingPhoneNo(currentUser);
        } else {
          await pr.hide();
          Get.snackbar(
            AppUtils.snackbarTitle,
            'You have entered wrong OTP',
            colorText: AppUtils.snackbarTextColor,
            backgroundColor: AppUtils.snackbarbackgroundColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            borderRadius: 5.0,
          );
        }
      }
    } catch (e) {
      await pr.hide();
      handleError(e);
    }
  }
}
