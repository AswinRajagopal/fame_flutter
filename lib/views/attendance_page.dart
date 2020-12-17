import 'dart:convert';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/attendance_controller.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import '../widgets/custom_app_bar.dart';

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

  @override
  void initState() {
    date.text = DateFormat('yyyy-M-d').format(DateTime.now()).toString();
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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    aC.pr.style(
      backgroundColor: Colors.black,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> getDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(
        date.text.toString(),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      print('Date selected ${date.text.toString()}');
      setState(() {
        date.text = DateFormat('yyyy-M-d').format(picked).toString();
      });
    }
  }

  Future<bool> backButtonPressed() {
    return Get.offAll(DashboardPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CustomAppBar('Attendance'),
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
                          fontWeight: FontWeight.bold,
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      isExpanded: true,
                      // value: aC.clientList.first.client.id.toString(),
                      items: aC.clientList.map((item) {
                        // print('item: ${item.client.id}');
                        var sC = item.client.name +
                            ' - ' +
                            item.client.id.toString();
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
                        print('value: $manpower');
                        // setState(() {
                        //   leaveType = value.toString();
                        // });
                        // Get.bottomSheet(
                        //   Container(
                        //     height: MediaQuery.of(context).size.height / 2.3,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.only(
                        //         topLeft: const Radius.circular(25.0),
                        //         topRight: const Radius.circular(25.0),
                        //       ),
                        //     ),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         Image.asset(
                        //           'assets/images/success.png',
                        //           scale: 2.0,
                        //           color: Colors.green,
                        //         ),
                        //         SizedBox(
                        //           height: 15.0,
                        //         ),
                        //         Text(
                        //           'Thank you for Login at',
                        //           style: TextStyle(
                        //             fontSize: 18.0,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 10.0,
                        //         ),
                        //         Text(
                        //           DateFormat()
                        //               .add_jm()
                        //               .format(DateTime.now())
                        //               .toString(),
                        //           style: TextStyle(
                        //             fontSize: 20.0,
                        //             color: Colors.blue,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 40.0,
                        //         ),
                        //         Container(
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 22.0,
                        //             vertical: 12.0,
                        //           ),
                        //           decoration: BoxDecoration(
                        //             color: Colors.green,
                        //             borderRadius: BorderRadius.all(
                        //               Radius.circular(
                        //                 30.0,
                        //               ),
                        //             ),
                        //           ),
                        //           child: Text(
                        //             'Thank You !',
                        //             style: TextStyle(
                        //               fontSize: 20.0,
                        //               color: Colors.white,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        //   isDismissible: false,
                        // );
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
                            fontWeight: FontWeight.bold,
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
                            value: 'checked in',
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
                            value: 'not checked',
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
                        height: 330.0,
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
                            StaggeredGridView.countBuilder(
                              staggeredTileBuilder: (int index) =>
                                  StaggeredTile.fit(1),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Radio(
                                      value: 'time',
                                      groupValue: stVal,
                                      onChanged: (sVal) {
                                        setState(() {
                                          stVal = sVal;
                                        });
                                      },
                                    ),
                                    Text(
                                      '06:00am - 02:00pm',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
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
                                  onPressed: () {},
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
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                      color: Colors.blue,
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
