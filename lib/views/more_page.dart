import 'visit_plan.dart';

import 'client_wise_attendance.dart';

import 'location_report_detail.dart';

import 'shortage_report.dart';

import 'employee_report.dart';

import 'timeline_report.dart';

import 'daily_employee_report.dart';

import 'transfer_list.dart';

import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var roleId = RemoteServices().box.get('role');
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Reports',
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                Get.to(TransferList());
              },
              child: ListContainer(
                'assets/images/icon_transfer.png',
                'Transfer',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(ShortageReport());
              },
              child: ListContainer(
                'assets/images/shortage_report.png',
                'Shortage Report',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(ClientWiseAttendance());
              },
              child: ListContainer(
                'assets/images/client_wise_att.png',
                'Client Wise Attendance',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(DailyEmployeeReport());
              },
              child: ListContainer(
                'assets/images/day_wise_attendance.png',
                'Day Wise Employee Attendance',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(EmployeeReport());
              },
              child: ListContainer(
                'assets/images/employee_report.png',
                'Employee Report',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(TimelineReport());
              },
              child: ListContainer(
                'assets/images/timeline_report.png',
                'Timeline Report',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(LocationReportDetail());
              },
              child: ListContainer(
                'assets/images/current_location.png',
                'Current Location',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(VisitPlan());
              },
              child: ListContainer(
                'assets/images/my_visit_plan.png',
                'My Visit Report',
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ListContainer extends StatelessWidget {
  final String image;
  final String title;
  final double height;
  final double width;
  ListContainer(this.image, this.title, {this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        10.0,
        12.0,
        10.0,
        0.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    image,
                    height: height ?? 40.0,
                    width: width ?? 40.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: 250.0,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                size: 35.0,
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            indent: 50.0,
            endIndent: 10.0,
          ),
        ],
      ),
    );
  }
}
