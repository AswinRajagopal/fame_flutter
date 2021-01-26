import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import 'package:get/get.dart';

class DBCalController extends GetxController {
  // var isCalLoading = true.obs;
  var isEventLoading = true.obs;
  var calRes;
  var changedDate;
  Map<DateTime, List> events = {};
  var calendarType = 'myCal';

  @override
  void onInit() {
    super.onInit();
    // getCalendar();
  }

  void init() {
    print('init custom getCalendar');
    getCalendar();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String convertTimeWithoutParse(time) {
    return DateFormat('h:mm').format(DateTime.parse(time)).toString() + DateFormat('a').format(DateTime.parse(time)).toString().toLowerCase();
  }

  void getCalendar({month, chDt}) async {
    print('calendarType: $calendarType');
    events = {};
    var dateParse;
    var date = DateTime.now().toString();
    if (month == null || month == '') {
      dateParse = DateTime.parse(date);
      print('Month: ${dateParse.month}');
      changedDate = '${dateParse.year}-${dateParse.month < 10 ? '0' + dateParse.month.toString() : dateParse.month}-${dateParse.day < 10 ? '0' + dateParse.day.toString() : dateParse.day}';
      var formattedDate = '${dateParse.month}${dateParse.year.toString().substring(2)}';
      month = formattedDate;
    }
    if (chDt != null) {
      changedDate = chDt;
    }
    // print('month - $month');
    try {
      isEventLoading(true);
      // print('calRes:');
      calRes = await RemoteServices().getEmpCalendarNew(month);
      if (calRes != null) {
        isEventLoading(false);
        // isCalLoading(false);
        if (calRes['success']) {
          // print(calRes.attendanceList);
          if (calendarType == 'myCal') {
            for (var i = 0; i < calRes['attendanceList'].length; i++) {
              var eventDt = DateTime.parse(
                formatDate(
                  DateTime.parse(calRes['attendanceList'][i]['checkInDateTime']),
                  [yyyy, mm, dd],
                ),
              );

              var event;
              event = calRes['attendanceList'][i]['attendanceAlias'];
              if (calRes['attendanceList'][i]['checkInDateTime'] != null && calRes['attendanceList'][i]['checkOutDateTime'] != null && calRes['attendanceList'][i]['attendanceAlias'] != null && calRes['attendanceList'][i]['checkInLatitude'] != '0E-8') {
                var chkIn = convertTimeWithoutParse(calRes['attendanceList'][i]['checkInDateTime']);
                var chkOut = convertTimeWithoutParse(calRes['attendanceList'][i]['checkOutDateTime']);
                event = calRes['attendanceList'][i]['attendanceAlias'] + '*' + chkIn + ',' + chkOut;
              }

              if (event != null && event != '') {
                // print('Key');
                // print(eventDt);
                events[eventDt] = [event];
              }
            }
          } else if (calendarType == 'myRos') {
            if (calRes['empRosterList'] != null && calRes['empRosterList'].length > 0) {
              var empRoster = calRes['empRosterList'];
              var rosterLength = calRes['empRosterList'].length;
              var roster = [];
              var clID1 = '';
              roster.add(empRoster[0]);
              // for (var i = 0; i < roster.first.length; i++) {
              var clID0 = roster[0]['name'].toString().trimRight() + ' (' + roster[0]['clientId'] + ')';
              if (rosterLength > 1) {
                clID1 = empRoster[1]['name'].toString().trimRight() + ' (' + empRoster[1]['clientId'] + ')';
              }
              roster[0].remove('modified_On');
              roster[0].remove('modified_By');
              roster[0].remove('clientId');
              roster[0].remove('name');
              roster[0].remove('empId');
              roster[0].remove('created_On');
              roster[0].remove('intId');
              roster[0].remove('created_By');
              roster[0].remove('month');
              roster[0].remove('design');
              // print(roster[0].length);
              for (var i = 1; i <= 31; i++) {
                // print('day$i');
                // print(empRoster[0]['day$i']);
                // print(empRoster[1]['day$i']);
                // print(dateParse);
                // print(changedDate);
                var day = i < 10 ? '0' + i.toString() : i.toString();
                var createDate = '${changedDate.split('-')[0]}-${changedDate.split('-')[1]}-$day 00:00:00';
                var eventDt = DateTime.parse(
                  formatDate(
                    DateTime.parse(createDate),
                    [yyyy, mm, dd],
                  ),
                );
                // print('eventDt: $eventDt');
                var event;
                if (rosterLength > 1) {
                  if (empRoster[0]['day$i'] == null) {
                    event = empRoster[1]['day$i'] != null ? empRoster[1]['day$i'] + ',' + clID1 : null;
                  } else if (empRoster[1]['day$i'] == null) {
                    event = empRoster[0]['day$i'] != null ? empRoster[0]['day$i'] + ',' + clID0 : null;
                  } else {
                    event = empRoster[0]['day$i'] + ',' + empRoster[1]['day$i'] + ',' + clID0 + '#' + clID1;
                  }
                } else {
                  event = empRoster[0]['day$i'] != null ? empRoster[0]['day$i'] + ',' + clID0 : null;
                }

                if (event != null && event != '') {
                  // print('Key');
                  // print(eventDt);
                  events[eventDt] = [event];
                }
              }
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
      isEventLoading(false);
      // isCalLoading(false);
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
