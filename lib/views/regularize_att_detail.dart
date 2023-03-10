import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/controllers/regularize_attendance_controller.dart';
import 'package:fame/utils/utils.dart';
import 'package:fame/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegularizeAttDetailList extends StatefulWidget {
  var regAtt;
  RegularizeAttDetailList(
    this.regAtt,
  );

  @override
  _RegularizeAttDetailListState createState() =>
      _RegularizeAttDetailListState(this.regAtt);
}

class _RegularizeAttDetailListState extends State<RegularizeAttDetailList> {
  final RegularizeAttController raC = Get.put(RegularizeAttController());

  var regAtt;
  _RegularizeAttDetailListState(
    this.regAtt,
  );

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString() +
        ' @ ' +
        DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
        '' +
        DateFormat('a').format(DateTime.parse(date)).toString().toLowerCase();
  }

  String convertDateTime(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString();
  }

  Widget titleParams(title, value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'PoppinsRegular'),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
            child: Container(
          alignment: Alignment.topLeft,
          child: Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'PoppinsRegular')),
        )),
      ],
    );
  }

  String getStatus(status) {
    if (status == '0') {
      return 'Pending';
    } else if (status == '1') {
      return 'Approved';
    } else {
      return 'Rejected';
    }
  }

  @override
  void initState() {
    raC.pr = ProgressDialog(
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
    raC.pr.style(
      backgroundColor: Colors.white,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var roleId = RemoteServices().box.get('role');
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Regularize Attendance Details',
        ),
      ),
      body: SafeArea(
        bottom: false,
        maintainBottomViewPadding: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Obx(() {
            if (raC.isLoading.value) {
              return LoadingWidget(
                containerColor: Colors.white,
                containerHeight: MediaQuery.of(context).size.height - 55.0,
                loaderColor: AppUtils().lightBlueColor,
                loaderSize: 30.0,
              );
            } else if (raC.regAttList == null) {
              return Container(
                height: MediaQuery.of(context).size.height - 150.0,
                child: Center(
                  child: Text(
                    'Regularize attendance detail not available',
                    style: TextStyle(
                      color: AppUtils().darkBlueColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              );
            }
            return ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 25.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          titleParams('Employee Name',
                              regAtt['empName'].toString() ?? 'NA'),
                          SizedBox(
                            height: 15.0,
                          ),
                          titleParams('Employee Id',
                              regAtt['empId'].toString() ?? 'NA'),
                          SizedBox(height: 15.0),
                          titleParams('Attendance alias',
                              regAtt['attendanceAlias'] ?? 'NA'),
                          SizedBox(
                            height: 15.0,
                          ),
                          titleParams('Revised alias',
                              regAtt['revisedAttendanceAlias'] ?? 'NA'),
                          SizedBox(
                            height: 15.0,
                          ),
                          titleParams(
                              'Status', getStatus(regAtt['status']) ?? 'NA'),
                          SizedBox(height: 15.0),
                          titleParams(
                              'Created by', regAtt['createdBy'] ?? 'NA'),
                          SizedBox(
                            height: 15.0,
                          ),
                          titleParams('Check-in time',
                              convertDate(regAtt['checkInDateTime'] ?? 'NA')),
                          SizedBox(
                            height: 15.0,
                          ),
                          titleParams('Check-out time',
                              convertDate(regAtt['checkOutDateTime'] ?? 'NA')),
                          SizedBox(
                            height: 15.0,
                          ),
                          titleParams(
                              'Revised Check-in time',
                              convertDate(
                                  regAtt['revisedCheckInDateTime'] ?? 'NA')),
                          SizedBox(
                            height: 15.0,
                          ),
                          titleParams(
                              'Revised Check-out time',
                              convertDate(
                                  regAtt['revisedCheckOutDateTime'] ?? 'NA')),
                          SizedBox(height: 15.0),
                          titleParams('Created On',
                              convertDateTime(regAtt['createdOn']) ?? 'NA'),
                          SizedBox(height: 15.0),
                          Column(
                            children: [
                              DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: Colors.black,
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      onPressed: () async {
                                        raC.updateRegAtt(
                                            '2', regAtt['regAttId'].toString());
                                      },
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      color: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    RaisedButton(
                                      onPressed: () async {
                                        raC.updateRegAtt(
                                            '1', regAtt['regAttId'].toString());
                                      },
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      color: AppUtils().blueColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                          color: AppUtils().blueColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
