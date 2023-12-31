import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import 'package:get/get.dart';


import '../models/srore_code.dart';

class DBCalController extends GetxController {
  // var isCalLoading = true.obs;
  var isEventLoading = true.obs;
  ProgressDialog pr;
  var calRes;
  var changedDate;
  var attId;
  Map<DateTime, List> events = {};
  var calendarType = 'myCal';
  final empRosterList = [].obs;
  final storeList = [].obs;
  var storeCodeList = <StoreName>[].obs;
  var combined;
  var dateList=[].obs;
  // var dayValue;

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
    return DateFormat('h:mm').format(DateTime.parse(time)).toString() +
        DateFormat('a').format(DateTime.parse(time)).toString().toLowerCase();
  }
  var res;
  void getStores()async{
    storeCodeList.clear();
    try {
      // isLoading(true);
      // await pr.show();
      res = await RemoteServices().getStores();
      if (res != null) {
        // isLoading(false);
        await pr.hide();
        if (res['success']) {
          print('storeRes:$res');
          if (res['storeNames'] != null) {
            for (var i = 0; i < res['storeNames'].length; i++) {
              Map<String, dynamic> store = res['storeNames'][i];
              storeCodeList.value.insert(i,StoreName(
                storeCode: store["storeCode"],
                storeName: store["storeName"],
                clientId: store["clientId"],
              ));
              update();
            }
          }
          // print('leaveList: $leaveList');
        } else {
          Get.snackbar(
            null,
            'stores not found',
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
      // isLoading(false);
      // await pr.hide();
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
  void getCalendar({month, chDt}) async {
    print('calendarType: $calendarType');
    events = {};
    var dateParse;
    var date = DateTime.now().toString();
    if (month == null || month == '') {
      dateParse = DateTime.parse(date);
      print('Month: ${dateParse.month}');
      changedDate =
          '${dateParse.year}-${dateParse.month < 10 ? '0' + dateParse.month.toString() : dateParse.month}-${dateParse.day < 10 ? '0' + dateParse.day.toString() : dateParse.day}';
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
      calRes = await RemoteServices().getEmpCalendarNew(month, '');
      if (calRes != null) {
        isEventLoading(false);
        // isCalLoading(false);
        if (calRes['success']) {
          // print(calRes.attendanceList);
          // var chkdate = [];
          if (calendarType == 'myCal') {
            for (var i = 0; i < calRes['attendanceList'].length; i++) {
              var eventDt = DateTime.parse(formatDate(
                  DateTime.parse(
                      calRes['attendanceList'][i]['checkInDateTime']),
                  [yyyy, mm, dd]));
              // if (!chkdate.contains(eventDt)) {
              //   chkdate.add(eventDt);
              // } else {
              //   //
              // }

              var event;
              event = calRes['attendanceList'][i]['attendanceAlias'];
              if (calRes['attendanceList'][i]['checkInDateTime'] != null &&
                  calRes['attendanceList'][i]['checkOutDateTime'] != null &&
                  calRes['attendanceList'][i]['attendanceAlias'] != null) {
                var chkIn = convertTimeWithoutParse(
                    calRes['attendanceList'][i]['checkInDateTime']);
                var chkOut = convertTimeWithoutParse(
                    calRes['attendanceList'][i]['checkOutDateTime']);
                var attId = calRes['attendanceList'][i]['id'];
                event = calRes['attendanceList'][i]['attendanceAlias'] +
                    '*' +
                    chkIn +
                    ',' +
                    chkOut +
                    "," +
                    attId;
              }

              if (event != null && event != '') {
                // print('Key');
                // print(eventDt);
                events[eventDt] = [event];
              }
            }
          } else if (calendarType == 'myRos') {
            if (calRes['empRosterList'] != null &&
                calRes['empRosterList'].length > 0) {
              var empRoster = calRes['empRosterList'];
              var rosterLength = calRes['empRosterList'].length;
              var roster = [];
              var clID1 = '';
              roster.add(empRoster[0]);
              // for (var i = 0; i < roster.first.length; i++) {
              var clID0 = roster[0]['name'].toString().trimRight() +
                  ' (' +
                  roster[0]['clientId'] +
                  ')';
              if (rosterLength > 1) {
                clID1 = empRoster[1]['name'].toString().trimRight() +
                    ' (' +
                    empRoster[1]['clientId'] +
                    ')';
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
                var createDate =
                    '${changedDate.split('-')[0]}-${changedDate.split('-')[1]}-$day 00:00:00';
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
                    event = empRoster[1]['day$i'] != null
                        ? empRoster[1]['day$i'] + ',' + clID1
                        : null;
                  } else if (empRoster[1]['day$i'] == null) {
                    event = empRoster[0]['day$i'] != null
                        ? empRoster[0]['day$i'] + ',' + clID0
                        : null;
                  } else {
                    event = empRoster[0]['day$i'] +
                        ',' +
                        empRoster[1]['day$i'] +
                        ',' +
                        clID0 +
                        '#' +
                        clID1;
                  }
                } else {
                  event = empRoster[0]['day$i'] != null
                      ? empRoster[0]['day$i'] + ',' + clID0
                      : null;
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

  void getRoster(month, empId) async {
    empRosterList.clear();
    dateList.clear();
    storeList.clear();
    print('month-->$month');
    print('month-->$empId');
    try {
      isEventLoading(true);
      await pr.show();
     calRes = await RemoteServices().getEmpCalendarNew(month, empId);
      if (calRes != null) {
        isEventLoading(false);
        await pr.hide();
        if (calRes['success']) {
          print("inside succes employee roster");
          if (calRes['empRosterList'] != null  ) {
            print("inside if employee roster");
            if (calRes['empRosterList'].isEmpty) {
              print("inside ealse employee roster");
              empRosterList.value.add(
                (
                    {
                      "modified_On": null,
                      "day29": null,
                      "day28": null,
                      "day27": null,
                      "day26": null,
                      "design": "",
                      "day14": null,
                      "month": "",
                      "day13": null,
                      "day12": null,
                      "modified_By": null,
                      "day11": null,
                      "day10": null,
                      "day31": null,
                      "day30": null,
                      "clientId": null,
                      "empId": "",
                      "created_On": "2023-06-12 19:38:01.157",
                      "day19": null,
                      "day18": null,
                      "day17": null,
                      "day16": null,
                      "day15": null,
                      "day25": null,
                      "day24": null,
                      "intId": "",
                      "day8": null,
                      "day23": null,
                      "day9": null,
                      "day22": null,
                      "day6": null,
                      "day21": null,
                      "day7": null,
                      "day20": null,
                      "day4": null,
                      "day5": null,
                      "day2": null,
                      "day3": null,
                      "day1": null,
                      "created_By": "",
                      "name": null
                    }
                )

              );


              print("inside ealse employee roster ${empRosterList}");

              empRosterList.forEach((element) {

                for (int i = 1; i <= 31; i++) {
                  String dayValue = "day${i}";
                  print("data ${storeCodeList.value} ${i}");
                  element[dayValue] = '';
                }
              });
            }else{
            for (var i = 0; i < calRes['empRosterList'].length; i++) {
              empRosterList.insert(i, calRes['empRosterList'][i]);

              // if (calRes['storeNames'] != null) {
              //   for(var i = 0; i < calRes['storeNames'].length; i++) {
              //     storeList.add(calRes['storeNames'][i]);
              //     Map<String, dynamic> store = calRes['storeNames'][i];
              //     String storeCode = store["storeCode"];
              //     print('storeCode:-->$storeCode');
              //   // String storeCode = calRes['storeNames'][0]["storeCode"];
              //     for (var empRoster in empRosterList) {
              //       // Loop through each day in the current object
              //       for (int i = 1; i <= 31; i++) {
              //         String dayKey = "day$i";
              //         if (empRoster[dayKey] == null) {
              //           continue;
              //         }
              //         String monthPass = month.substring(0, 2);
              //         print('monthPass:$monthPass');
              //         String year = '20' + month.substring(2);
              //         print('year:-->$year');
              //         int daysInMonth = DateTime(
              //             int.parse(year), int.parse(monthPass) + 1, 0).day;
              //         print('days in month:-->$daysInMonth');
              //         List<String> dates = List.generate(daysInMonth, (index) {
              //           String day = (index + 1).toString().padLeft(2, '0');
              //           return "$day-$monthPass-$year";
              //         });
              //         dateList.clear();
              //         for (String date in dates) {
              //           dateList.add(date);
              //           print(dateList);
              //         }
              //         String dayValue = empRoster[dayKey].split(" ")[2];
              //         print('dayVALUE__>:$dayValue');
              //         if (dayValue != null) {
              //           // Loop through each store in storeNames list
              //           for (var store in storeList) {
              //             var storeCode = store['storeCode'];
              //             if (dayValue == storeCode) {
              //               var storeName = store['storeName'];
              //               // Add the storeName to the dayKey value
              //               empRoster[dayKey] =
              //               '${empRoster[dayKey]} , $storeName';
              //               print('emproster:-->${empRoster[dayKey]}');
              //             }
              //           }
              //         }
              //       }
              //     }
              //   }
              // }
            }
            empRosterList.forEach((element) {
              for (int i = 1; i <= 31; i++) {
                String dayValue = "day${i}";
                print("data ${storeCodeList.value} ${i}");
                String storeNAme = '';
                if (element[dayValue] != null && element[dayValue]
                    .split(' ')
                    .last != null) {
                  storeCodeList.value.forEach((store) {
                    if (store.storeCode.trim() == element[dayValue]
                        .split(' ')
                        .last
                        .toString()
                        .trim()) {
                      storeNAme = store.storeName;
                      element[dayValue] =
                          element[dayValue] + " \$- " + storeNAme;
                      print("store name ${element[dayValue]}");
                    }
                  });
                }
              }
            });
          }
          }



          update();
        } else {
          empRosterList.value.add(
            (
                {
                  "modified_On": null,
                  "day29": null,
                  "day28": null,
                  "day27": null,
                  "day26": null,
                  "design": "",
                  "day14": null,
                  "month": "",
                  "day13": null,
                  "day12": null,
                  "modified_By": null,
                  "day11": null,
                  "day10": null,
                  "day31": null,
                  "day30": null,
                  "clientId": null,
                  "empId": "",
                  "created_On": "2023-06-12 19:38:01.157",
                  "day19": null,
                  "day18": null,
                  "day17": null,
                  "day16": null,
                  "day15": null,
                  "day25": null,
                  "day24": null,
                  "intId": "",
                  "day8": null,
                  "day23": null,
                  "day9": null,
                  "day22": null,
                  "day6": null,
                  "day21": null,
                  "day7": null,
                  "day20": null,
                  "day4": null,
                  "day5": null,
                  "day2": null,
                  "day3": null,
                  "day1": null,
                  "created_By": "",
                  "name": null
                }
            ));
        }
      }
      await pr.hide();
      update();
    } catch (e) {
      print(e);
      isEventLoading(false);
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
