import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import '../connection/remote_services.dart';
import 'package:get/get.dart';

class DBCalController extends GetxController {
  // var isCalLoading = true.obs;
  var isEventLoading = true.obs;
  var calRes;
  var changedDate;
  Map<DateTime, List> events = {};

  @override
  void onInit() {
    super.onInit();
    // getCalendar();
  }

  void init() {
    print('init custom getCalendar');
    getCalendar();
  }

  void getCalendar({month, chDt}) async {
    events = {};
    var date = DateTime.now().toString();
    if (month == null || month == '') {
      var dateParse = DateTime.parse(date);
      changedDate = '${dateParse.year}-${dateParse.month}-${dateParse.day}';
      var formattedDate =
          '${dateParse.month}${dateParse.year.toString().substring(2)}';
      month = formattedDate;
    }
    if (chDt != null) {
      changedDate = chDt;
    }
    // print('month - $month');
    try {
      isEventLoading(true);
      // print('calRes:');
      calRes = await RemoteServices().getEmpCalendar(month);
      if (calRes != null) {
        isEventLoading(false);
        // isCalLoading(false);
        if (calRes.success) {
          // print(calRes.attendanceList);
          for (var i = 0; i < calRes.attendanceList.length; i++) {
            // print(calRes.attendanceList[i].attendanceAlias);
            // print(calRes.attendanceList[i].checkInDateTime);
            // var chDt = DateTime.parse(
            //   calRes.attendanceList[i].checkInDateTime,
            // );
            // var eventDate = DateTime.parse(
            //   formatDate(executeon, [yyyy, mm, dd]),
            // );
            // var eventDt = DateFormat('yyyy, mm, dd').format(
            //   calRes.attendanceList[i].checkInDateTime,
            // );
            var eventDt = DateTime.parse(
              formatDate(
                calRes.attendanceList[i].checkInDateTime,
                [yyyy, mm, dd],
              ),
            );
            var event = calRes.attendanceList[i].attendanceAlias;

            if (event != null && event != '') {
              // print('Key');
              // print(eventDt);
              events[eventDt] = [event];
            }
          }
        } else {
          Get.snackbar(
            'Error',
            'Something went wrong! Please try again later',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      isEventLoading(false);
      // isCalLoading(false);
      Get.snackbar(
        'Error',
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
      );
    }
  }
}
