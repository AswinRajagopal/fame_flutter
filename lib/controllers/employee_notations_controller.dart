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
  final List designationSort = [].obs;
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

  void getNotationsBySearch(date, clientId, time, empName) async {
    searchList.clear();
    try {
      resSearch = await RemoteServices().getNotationsBySearch(date, clientId, empName);
      if (resSearch != null) {
        // print('res valid: $res');
        if (resSearch['success']) {
          // print('clientList: $clientList');
          // print(resSearch.empDailyAttView);
          // print('here: ${resSearch.attendanceNotations}');
          print('time: $time');
          var timeSplit = time.toString().split(' - ');
          var ampm1 = timeSplit[0].toString().contains('pm') ? 'PM' : 'AM';
          var ampm2 = timeSplit[1].toString().contains('pm') ? 'PM' : 'AM';
          var timeSplitRep1 = timeSplit[0].replaceAll('am', '').replaceAll('pm', '').split(':');
          var timeSplitRep2 = timeSplit[1].replaceAll('am', '').replaceAll('pm', '').split(':');
          var hour1 = int.parse(timeSplitRep1[0]) < 10 ? '${timeSplitRep1[0]}' : timeSplitRep1[0];
          var hour2 = int.parse(timeSplitRep2[0]) < 10 ? '${timeSplitRep2[0]}' : timeSplitRep2[0];
          var min1 = (timeSplitRep1[1].length < 2 && int.parse(timeSplitRep1[1]) < 10) ? '${timeSplitRep1[1]}' : timeSplitRep1[1];
          var min2 = (timeSplitRep2[1].length < 2 && int.parse(timeSplitRep2[1]) < 10) ? '${timeSplitRep2[1]}' : timeSplitRep2[1];
          var passHour1 = ampm1 == 'PM' && int.parse(hour1) != 12 ? (int.parse(hour1) + 12) : hour1;
          var passHour2 = ampm2 == 'PM' && int.parse(hour2) != 12 ? (int.parse(hour2) + 12) : hour2;
          var formatDate1 = date + ' ' + passHour1.toString() + ':' + min1 + ':00';
          var formatDate2 = date + ' ' + passHour2.toString() + ':' + min2 + ':00';
          var shiftStart = DateTime.parse(formatDate1);
          var shiftEnd = DateTime.parse(formatDate2);

          print('shiftStart: $shiftStart');
          print('shiftEnd: $shiftEnd');

          for (var j = 0; j < resSearch['empSuggest'].length; j++) {
            var emp = resSearch['empSuggest'][j];
            emp['showTime'] = '';
            emp['showType'] = 'att';
            emp['showButton'] = true;
            // if(checkoutTime <= currentShiftStart || checkinTime >= currentShiftEnd)
            // checks out before shift starting or checks in after shift
            // print('checkInDateTime: ${emp['checkInDateTime']}');
            // print('checkOutDateTime: ${emp['checkOutDateTime']}');
            // print('cond 1: ${DateTime.parse(emp['checkOutDateTime']).isBefore(shiftStart)}');
            // print('cond 2: ${DateTime.parse(emp['checkInDateTime']).isAfter(shiftEnd)}');
            if (emp['attendanceAlias'] != null) {
              var strToTime = emp['checkInDateTime'];
              if (emp['checkOutDateTime'] != null) {
                if (DateTime.parse(emp['checkOutDateTime']).isBefore(shiftStart) || DateTime.parse(emp['checkInDateTime']).isAfter(shiftEnd)) {
                  strToTime = timeConvert(strToTime.toString()) + ' to ' + timeConvert(emp['checkOutDateTime'].toString());

                  emp['showTime'] = strToTime;
                  emp['showType'] = 'att';
                  emp['showButton'] = true;
                } else {
                  strToTime = timeConvert(strToTime.toString()) + ' to ' + timeConvert(emp['checkOutDateTime'].toString());

                  emp['showTime'] = strToTime;
                  // showType = 'apprej';
                  // emp['showType'] = 'apprej';
                  emp['showType'] = 'hideapprej';
                  emp['showButton'] = false;
                }
              } else {
                strToTime = timeConvert(strToTime.toString());
                emp['showTime'] = strToTime;
                // showType = 'remark';
                emp['showType'] = 'remark';
                emp['showButton'] = true;
              }
            }
            print('emp: $emp');
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
          designationSort.addAll(res['designationsList']);
          print('designationSort: $designationSort');
          // designationSort.sort((a, b) => int.parse(a['designId']).compareTo(int.parse(b['designId'])));
          // print('designationSort: $designationSort');
          // for (var i = 0; i < designationSort.length; i++) {
          //   designation.insert(
          //     int.parse(designationSort[i]['designId']),
          //     designationSort[i]['design'],
          //   );
          // }
          // print('designation: $designation');
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
