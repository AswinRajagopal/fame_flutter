import 'package:intl/intl.dart';

import '../utils/utils.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EmployeeNotationsController extends GetxController {
  var isLoading = true.obs;
  var res;
  var resSearch;
  ProgressDialog pr;
  final List designation = [].obs;
  final List aprrej = [
    {
      'value': 'Approve',
      'label': 'Approve',
    },
    {
      'value': 'Reject',
      'label': 'Reject',
    },
    {
      'value': 'Modify',
      'label': 'Modify',
    },
  ];
  final List notations = [].obs;
  // final List timings = [].obs;
  // var shiftTime;
  var p = 0.obs;
  var wo = 0.obs;
  var l = 0.obs;
  var a = 0.obs;
  final List searchList = [].obs;
  var oB = AppUtils.NAME;
  var showType = 'att'; //apprej

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String timeConvert(time) {
    print(DateFormat.jm().format(DateTime.parse(time)).toString());
    return DateFormat.jm().format(DateTime.parse(time)).toString();
  }

  void getNotationsBySearch(date, clientId, empName) async {
    searchList.clear();
    try {
      resSearch = await RemoteServices().getNotationsBySearch(date, clientId, empName);
      if (resSearch != null) {
        // print('res valid: $res');
        if (resSearch['success']) {
          // print('clientList: $clientList');
          // print(resSearch.empDailyAttView);
          // print('here: ${resSearch.attendanceNotations}');
          for (var j = 0; j < resSearch['empSuggest'].length; j++) {
            var emp = resSearch['empSuggest'][j];
            emp['showTime'] = '';
            emp['showType'] = 'att';
            if (emp['checkInLatitude'] != null && emp['checkInLatitude'] != '0E-8') {
              var strToTime = emp['checkInDateTime'];
              if (emp['checkOutDateTime'] != null) {
                strToTime = timeConvert(strToTime.toString()) + ' to ' + timeConvert(emp['checkOutDateTime'].toString());

                emp['showTime'] = strToTime;
                // showType = 'apprej';
                emp['showType'] = 'apprej';
              } else {
                strToTime = timeConvert(strToTime.toString());
                emp['showTime'] = strToTime;
                // showType = 'remark';
                emp['showType'] = 'remark';
              }
            }
            if (emp['attendanceAlias'] == 'P') {
              p.value++;
            } else if (emp['attendanceAlias'] == 'WO') {
              wo.value++;
            } else if (emp['attendanceAlias'] == 'L') {
              l.value++;
            } else if (emp['attendanceAlias'] == 'A') {
              a.value++;
            }
            searchList.add(emp);
          }
        }
      }
    } catch (e) {
      print(e);
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

  void getNotations(
    date,
    shift,
    clientId,
    orderBy,
    checkFilter,
  ) async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getNotations(
        date,
        shift,
        clientId,
        orderBy,
        checkFilter,
      );
      if (res != null) {
        isLoading(false);
        await pr.hide();
        // print('res valid: $res');
        if (res['success']) {
          // print('clientList: $clientList');
          // print(res.empDailyAttView);
          // print('here: ${res.attendanceNotations}');
          for (var j = 0; j < res['empDailyAttView'].length; j++) {
            var emp = res['empDailyAttView'][j];
            emp['showTime'] = '';
            emp['showType'] = 'att';
            if (emp['checkInLatitude'] != null && emp['checkInLatitude'] != '0E-8') {
              var strToTime = emp['checkInDateTime'];
              if (emp['checkOutDateTime'] != null) {
                strToTime = timeConvert(strToTime.toString()) + ' to ' + timeConvert(emp['checkOutDateTime'].toString());

                emp['showTime'] = strToTime;
                // showType = 'apprej';
                emp['showType'] = 'apprej';
              } else {
                strToTime = timeConvert(strToTime.toString());
                emp['showTime'] = strToTime;
                // showType = 'remark';
                emp['showType'] = 'remark';
              }
            }
            if (emp['attendanceAlias'] == 'P') {
              p.value++;
            } else if (emp['attendanceAlias'] == 'WO') {
              wo.value++;
            } else if (emp['attendanceAlias'] == 'L') {
              l.value++;
            } else if (emp['attendanceAlias'] == 'A') {
              a.value++;
            }
          }
          for (var i = 0; i < res['designationsList'].length; i++) {
            designation.insert(
              int.parse(res['designationsList'][i]['designId']),
              res['designationsList'][i]['design'],
            );
          }
        } else {
          // Get.snackbar(
          //   null,
          //   'Notations not found',
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

  Future<bool> giveAttendance(
    date,
    shift,
    clientId,
    alies,
    empId,
    designation,
    remarks,
    startTime,
    endTime, {
    extraName,
    extraParam,
  }) async {
    try {
      await pr.show();
      var attRes = await RemoteServices().giveAttendance(
        date,
        shift,
        clientId,
        alies,
        empId,
        designation,
        remarks,
        startTime,
        endTime,
        extraName: extraName,
        extraParam: extraParam,
      );
      if (attRes != null) {
        await pr.hide();
        if (attRes['success']) {
          return true;
        } else {
          Get.snackbar(
            null,
            extraName != null && extraName == 'Clear' ? 'Attendance not cleared' : 'Attendance not given',
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
      return false;
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
