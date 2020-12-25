import 'timeline_report.dart';

import 'daily_employee_report.dart';

import 'transfer_list.dart';

import '../connection/remote_services.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var roleId = RemoteServices().box.get('role');
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
                if (roleId != '2') {
                  Get.snackbar(
                    'Error',
                    'Only FO can access this',
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 10.0,
                    ),
                  );
                } else {
                  Get.to(TransferList());
                }
              },
              child: ListContainer(
                'assets/images/icon_transfer.png',
                'Transfer',
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListContainer(
                'assets/images/shortage_report.png',
                'Shortage Report',
              ),
            ),
            GestureDetector(
              onTap: () {},
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
              onTap: () {},
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
              onTap: () {},
              child: ListContainer(
                'assets/images/current_location.png',
                'Current Location',
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListContainer(
                'assets/images/my_visit_plan.png',
                'My Visit Plan',
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
  ListContainer(this.image, this.title);

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
                    height: 60.0,
                    width: 60.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: 250.0,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
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
            indent: 65.0,
            endIndent: 10.0,
          ),
        ],
      ),
    );
  }
}
