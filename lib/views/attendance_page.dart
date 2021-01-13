import 'dart:convert';

import '../connection/remote_services.dart';

import 'employee_notation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/attendance_controller.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';

import 'dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceController aC = Get.put(AttendanceController());
  TextEditingController date = TextEditingController();
  var stVal = 'all';
  var clientId;
  var passDate;

  @override
  void initState() {
    date.text = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    passDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    aC.pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Processing please wait...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    aC.pr.style(
      backgroundColor: Colors.white,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> getDate(BuildContext context) async {
    int attendanceDaysPermitted = jsonDecode(RemoteServices().box.get('appFeature'))['attendanceDaysPermitted'];
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(
        passDate.toString(),
      ),
      firstDate: DateTime.now().add(Duration(days: -(attendanceDaysPermitted - 1))),
      // lastDate: DateTime.now().add(Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${date.text.toString()}');
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        passDate = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<bool> backButtonPressed() {
    return Get.offAll(DashboardPage());
  }

  @override
  Widget build(BuildContext context) {
    // print('appFeature');
    // print(RemoteServices().box.get('appFeature'));
    // print(jsonDecode(RemoteServices().box.get('appFeature'))['attendanceDaysPermitted']);

    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Attendance',
        ),
        leading: IconButton(
          onPressed: backButtonPressed,
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: backButtonPressed,
        child: SafeArea(
          child: Obx(() {
            if (aC.isLoading.value) {
              return Column();
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      controller: date,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Select Date',
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 25.0,
                        ),
                      ),
                      readOnly: true,
                      keyboardType: null,
                      onTap: () {
                        getDate(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: DropdownButtonFormField<String>(
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Select client',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      isExpanded: true,
                      // value: aC.clientList.first.client.id.toString(),
                      items: aC.clientList.map((item) {
                        // print('item: ${item.client.id}');
                        var sC = item.client.name + ' - ' + item.client.id.toString();
                        return DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              sC.toString(),
                            ),
                          ),
                          value: json.encode(item.clientManpowerList),
                        );
                      }).toList(),
                      onChanged: (value) {
                        var manpower = json.decode(value);
                        // print('value: $manpower');
                        clientId = manpower.first['clientId'];
                        aC.timings.clear();
                        aC.shiftTime = '';
                        for (var j = 0; j < manpower.length; j++) {
                          // print('manpower: ${manpower[j]}');
                          manpower[j]['shiftStartTime'] = manpower[j]['shiftStartTime'].split(':').first.length == 1 ? '0' + manpower[j]['shiftStartTime'] : manpower[j]['shiftStartTime'];
                          manpower[j]['shiftEndTime'] = manpower[j]['shiftEndTime'].split(':').first.length == 1 ? '0' + manpower[j]['shiftEndTime'] : manpower[j]['shiftEndTime'];
                          var sSTime = DateFormat('hh:mm')
                                  .format(
                                    DateTime.parse(
                                      '2020-12-20 ' + manpower[j]['shiftStartTime'],
                                    ),
                                  )
                                  .toString() +
                              DateFormat('a')
                                  .format(
                                    DateTime.parse(
                                      '2020-12-20 ' + manpower[j]['shiftStartTime'],
                                    ),
                                  )
                                  .toString()
                                  .toLowerCase();
                          var sETime = DateFormat('hh:mm')
                                  .format(
                                    DateTime.parse(
                                      '2020-12-20 ' + manpower[j]['shiftEndTime'],
                                    ),
                                  )
                                  .toString() +
                              DateFormat('a')
                                  .format(
                                    DateTime.parse(
                                      '2020-12-20 ' + manpower[j]['shiftEndTime'],
                                    ),
                                  )
                                  .toString()
                                  .toLowerCase();
                          var addTiming = {
                            'shift': manpower[j]['shift'],
                            'shiftStartTime': sSTime,
                            'shiftEndTime': sETime,
                          };
                          print(aC.timings.contains(addTiming));
                          if (!aC.timings.contains(addTiming)) {
                            aC.timings.add(addTiming);
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Status :',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 'checked',
                            groupValue: stVal,
                            onChanged: (sVal) {
                              setState(() {
                                stVal = sVal;
                              });
                            },
                          ),
                          Text(
                            'Checked in',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'not_checked',
                            groupValue: stVal,
                            onChanged: (sVal) {
                              setState(() {
                                stVal = sVal;
                              });
                            },
                          ),
                          Text(
                            'Not checked',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'all',
                            groupValue: stVal,
                            onChanged: (sVal) {
                              setState(() {
                                stVal = sVal;
                              });
                            },
                          ),
                          Text(
                            'All',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 370.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 25.0,
                              spreadRadius: 5.0,
                              offset: Offset(
                                15.0,
                                15.0,
                              ),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Select shift timings :',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Obx(() {
                              if (aC.timings.isNullOrBlank) {
                                return Container(
                                  height: 180.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Please select client',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container(
                                height: 180.0,
                                child: Center(
                                  child: StaggeredGridView.countBuilder(
                                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    itemCount: aC.timings.length,
                                    itemBuilder: (context, index) {
                                      // print(aC.timings);
                                      var timing = aC.timings[index];
                                      var shiftTime = timing['shiftStartTime'] + ' - ' + timing['shiftEndTime'];
                                      return Row(
                                        children: [
                                          Radio(
                                            value: timing['shift'] + '#' + shiftTime,
                                            groupValue: aC.shiftTime,
                                            onChanged: (sVal) {
                                              setState(() {
                                                aC.shiftTime = sVal;
                                              });
                                            },
                                          ),
                                          Text(
                                            shiftTime,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            }),
                            SizedBox(
                              height: 40.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    print('Cancel');
                                    // Get.back();
                                    Get.offAll(DashboardPage());
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    print('proceed');
                                    print('date: $passDate');
                                    print('client: $clientId');
                                    print('status: $stVal');
                                    print('shift: ${aC.shiftTime}');
                                    if (clientId == null || aC.shiftTime == null || aC.shiftTime == '') {
                                      Get.snackbar(
                                        'Error',
                                        'Please select client and shift timing',
                                        colorText: Colors.white,
                                        backgroundColor: Colors.black87,
                                        snackPosition: SnackPosition.BOTTOM,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 10.0,
                                        ),
                                      );
                                    } else {
                                      print('date: $passDate');
                                      print('client: $clientId');
                                      print('status: $stVal');
                                      print('shift: ${aC.shiftTime.split('#').first}');
                                      print('time: ${aC.shiftTime.split('#').last}');
                                      Get.offAll(
                                        EmployeeNotation(
                                          passDate,
                                          clientId,
                                          stVal,
                                          aC.shiftTime.split('#').first,
                                          aC.shiftTime.split('#').last,
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 30.0,
                                    ),
                                    child: Text(
                                      'Proceed',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
