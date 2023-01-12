import 'dart:async';

import 'package:fame/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';

class ExpenseController extends GetxController {
  var isLoading = true.obs;
  var res;
  var expDet;
  var selectedBills = [].obs;
  ProgressDialog pr;
  List exp = [].obs;
  List purpose = [].obs;
  List empExpList = [].obs;
  List rejectedList = [].obs;
  List attachment = [].obs;
  List billAttachment = [].obs;
  List expenseBillsList = [].obs;
  List empExpAdvanceList = [].obs;
  var balance;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100));
  }

  void newExpenses(
      amount, expenseTypeId, remarks, imageFile, imageFile2, imageFile3) async {
    try {
      await pr.show();
      var ExpenseRes = await RemoteServices().newExpenses(
          imageFile, amount, expenseTypeId, remarks, imageFile2, imageFile3);
      if (ExpenseRes != null) {
        await pr.hide();
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

  void getNewEmpAdv(amount) async {
    try {
      await pr.show();
      var newEmpAdv = await RemoteServices().getNewEmpAdv(amount);
      if (newEmpAdv != null) {
        await pr.hide();
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
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getExpAdv();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['empExpAdvanceList'] != null) {
            for (var i = 0; i < res['empExpAdvanceList'].length; i++) {
              empExpAdvanceList.add(res['empExpAdvanceList'][i]);
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

  void getExpAdvAdmin(empId) async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getExpAdvAdmin(empId);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['empExpAdvanceList'] != null) {
            for (var i = 0; i < res['empExpAdvanceList'].length; i++) {
              empExpAdvanceList.add(res['empExpAdvanceList'][i]);
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

  void getExpenses() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getExpenses();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
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

  void aprRejExpense(adminRemarks,amount,empId, empExpenseId, status) async {
    try {
      await pr.show();
      var appRejRes =
          await RemoteServices().aprRejExpense(adminRemarks,amount,empId, empExpenseId, status);
      if (appRejRes != null) {
        await pr.hide();
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
          Timer(Duration(seconds: 2), Get.back);
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

  void getEmpExpenses() async {
    try {
      empExpList = [];
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getEmpExpenses();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          expDet = res;
          if (res['expenseList'] != null) {
            for (var i = 0; i < res['expenseList'].length; i++) {
              empExpList.add(res['expenseList'][i]);
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

  void getEmpExpensesAdmin(empId) async {
    try {
      empExpList = [];
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getEmpExpensesAdmin(empId);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          expDet = res;
          if (res['expenseList'] != null) {
            for (var i = 0; i < res['expenseList'].length; i++) {
              empExpList.add(res['expenseList'][i]);
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

  void getEmpExpense(status) async {
    try {
      rejectedList = [];
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getEmpExpense(status);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          expDet = res;
          if (res['rejectedOrApprvList'] != null) {
            for (var i = 0; i < res['rejectedOrApprvList'].length; i++) {
              rejectedList.add(res['rejectedOrApprvList'][i]);
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

  void getEmpExpenseAdmin(empId, status) async {
    try {
      rejectedList = [];
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getEmpExpenseAdmin(empId, status);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          expDet = res;
          if (res['rejectedOrApprvList'] != null) {
            for (var i = 0; i < res['rejectedOrApprvList'].length; i++) {
              rejectedList.add(res['rejectedOrApprvList'][i]);
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

  void getExpAttachments(expenseEmpId) async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getExpAttachments(expenseEmpId);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['expAttachments'] != null) {
            for (var i = 0; i < res['expAttachments'].length; i++) {
              attachment.add(res['expAttachments'][i]);
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

  void getBillAttachments(expenseBillId) async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getBillAttachments(expenseBillId);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['expenseBillUrl'] != null) {
            for (var i = 0; i < res['expenseBillUrl'].length; i++) {
              billAttachment.add(res['expenseBillUrl'][i]);
            }
            // print("billAttach:$billAttachment");
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

  void newExpBills(
      amount, expenseTypeId, remarks, imageFile, imageFile2, imageFile3) async {
    try {
      await pr.show();
      var expenseBillRes = await RemoteServices().newExpBills(imageFile,
           amount, expenseTypeId, remarks,imageFile2, imageFile3);
      if (expenseBillRes != null) {
        await pr.hide();
        if (expenseBillRes['success']) {
          Get.snackbar(
            null,
            'Bills sent successfully',
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
            'Bills send failed',
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

  void editExpBills(amount, expenseTypeId, expenseBillId, remarks, imageFile,
      imageFile2, imageFile3) async {
    try {
      await pr.show();
      var editBillRes = await RemoteServices().editExpBills(
          amount,
          expenseTypeId,
          expenseBillId,
          remarks,
          imageFile,
          imageFile2,
          imageFile3);
      if (editBillRes != null) {
        await pr.hide();
        if (editBillRes['success']) {
          Get.snackbar(
            null,
            'Bills updated successfully',
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
            'Bills update failed',
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

  void getBillsByStatus() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getBillsByStatus();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['expenseBills'] != null) {
            for (var i = 0; i < res['expenseBills'].length; i++) {
              expenseBillsList.add(res['expenseBills'][i]);
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

  void getBillsToExpense() async {
    try {
      await pr.show();
      String bills = selectedBills.join(',');
      var billsToExpRes = await RemoteServices().getBillsToExpense(bills);
      if (billsToExpRes != null) {
        await pr.hide();
        if (billsToExpRes['success']) {
          Get.snackbar(
            null,
            'Bills sent successfully',
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
            'Bills send failed',
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

  void getExpAdvBalance(empId)async{
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getExpAdvBalance(empId);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['empBalance'] != null) {
              balance = res['empBalance'];
              balance!=null?balance:"N/A";
          }
        } else {}
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
