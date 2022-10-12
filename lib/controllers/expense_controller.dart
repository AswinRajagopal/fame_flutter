import 'dart:async';

import 'package:fame/utils/utils.dart';
import 'package:flutter/material.dart';
import '../connection/remote_services.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExpenseController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  List exp = [].obs;
  List purpose=[].obs;
  List empExpList=[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100));
  }

  void newExpenses(amount,expenseTypeId,remarks, imageFile, imageFile2, imageFile3) async {
    try {
      await pr.show();
      var ExpenseRes = await RemoteServices().newExpenses(imageFile, amount,
          expenseTypeId,remarks, imageFile2, imageFile3);
      if (ExpenseRes != null) {
        await pr.hide();
        print('ExpenseRes valid: ${ExpenseRes['success']}');
        if (ExpenseRes['success']) {
          Get.snackbar(
            null,
            'Expenses sent successfully',
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
        } else {
          Get.snackbar(
            null,
            'Expenses send failed',
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

  void getExpenses() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getExpenses();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          print(res['expenseType'] );
          if (res['expenseType'] != null) {
            for (var i = 0; i < res['expenseType'].length; i++) {
              exp.add(res['expenseType'][i]);
              purpose.add(res['expenseType'][i]);
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


  void getEmpExpenses() async{
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getEmpExpenses();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          print('expensesTypeRes valid: $res');
          if (res['expenseList'] != null) {
            for (var i = 0; i < res['expenseList'].length; i++) {
              empExpList.add(res['expenseList'][i]);
            }
            print("empexplist:$empExpList");
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

  void aprRejExpense(status) async {
    try {
      await pr.show();
      var appRejRes = await RemoteServices().aprRejExpense(status);
      if (appRejRes != null) {
        await pr.hide();
        print('appRejRes: $appRejRes');
        if (appRejRes['success']) {
          Get.snackbar(
            null,
            'Expense request updated',
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
          // getEmpExpenses();
        } else {
          Get.snackbar(
            null,
            'Expense request not updated',
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

   void getNewEmpAdv(amount) async {
     try {
       await pr.show();
       var newEmpAdv = await RemoteServices().getNewEmpAdv(amount);
       if (newEmpAdv != null) {
         await pr.hide();
         print('newEmpAdv: $newEmpAdv');
         if (newEmpAdv['success']) {
           Get.snackbar(
             null,
             'Advance Added Successfully',
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
         } else {
           Get.snackbar(
             null,
             'Advance request not updated',
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

   void getExpAdv() async {
     try {
       await pr.show();
       var ExpAdv = await RemoteServices().getExpAdv();
       if (ExpAdv != null) {
         await pr.hide();
         print('newExpAdv: $ExpAdv');
         if (ExpAdv['success']) {
           Get.snackbar(
             null,
             'Advance Updated Successfully',
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
           );
           Timer(Duration(seconds: 2), Get.back);
         } else {
           Get.snackbar(
             null,
             'Advance request not updated',
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
