import 'package:dotted_line/dotted_line.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/reporting_manager_att_controller.dart';
import 'package:fame/utils/utils.dart';
import 'package:fame/views/expenses_list_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class ReportingManagerAttWidget extends StatelessWidget {
  final report;
  final int length;
  final int index;
  final RepoManagerAttController rmaC;

  ReportingManagerAttWidget(
    this.report,
    this.index,
    this.length,
    this.rmaC,
  );

  final TextEditingController expense = TextEditingController();

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString() +
        '@ ' +
        DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
        '' +
        DateFormat('a').format(DateTime.parse(date)).toString().toUpperCase();
  }

  String convertDateTime(date) {
    return DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
        '' +
        DateFormat('a').format(DateTime.parse(date)).toString().toUpperCase();
  }

  String widgetDate(date) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(ExpensesDetailList(
        //   this.rejectedExp,
        //   this.index,
        //   this.length,
        //   this.expC,
        // ));
      },
      child: Card(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      Text(
                        report['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        report['empId'],
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      )
                    ]),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: 1.5,
                      height: 50.0,
                      color: AppUtils().blueColor,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      children: [
                        Text(
                          'Checkin-time',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          report['attendanceAlias'] == 'A'
                              ? 'A - Absent'
                              : convertDateTime(report['checkInDateTime']),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: AppUtils().blueColor,
                          ),
                        ),
                        Text(
                          'Checkout-time',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          report['attendanceAlias'] == 'A'
                              ? 'A - Absent'
                              : convertDateTime(report['checkOutDateTime']),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: AppUtils().blueColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Column(children: [
                      Row(children: [
                        Text(
                          'Client Name ',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 80.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: Colors.teal[100],

                            border: Border.all(
                                color: Colors.teal[100]), // Set border width
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: FittedBox(
                            child: Text(
                              report['siteName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                          children: [
                        Text(
                          'Shift ',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 50.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            // color: AppUtils().blueColor,
                            border: Border.all(
                                color:
                                    AppUtils().blueColor), // Set border width
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                          child: Text(
                            report['shift'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: AppUtils().blueColor,
                            ),
                          ),
                        ),
                      ]),
                    ]),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
