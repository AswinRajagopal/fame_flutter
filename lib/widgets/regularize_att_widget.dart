import 'package:fame/controllers/regularize_attendance_controller.dart';
import 'package:fame/utils/utils.dart';
import 'package:fame/views/regularize_att_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegAttListWidget extends StatelessWidget {
  final regAtt;
  final RegularizeAttController raC;
  RegAttListWidget(this.regAtt, this.raC);

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(RegularizeAttDetailList(this.regAtt)
        );
      },
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppUtils().greyScaffoldBg,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300],
                offset: Offset(0.8, 1),
                spreadRadius: 4,
                blurRadius: 7),
          ],
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Text(
                regAtt['empName'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                regAtt['empId'],
                style: TextStyle(color: AppUtils().blueColor),
              ),
            ]),
            SizedBox(
              width: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Center(
                child: Container(
                  width: 70.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:regAtt['status']=='1'  ? Colors.teal[100]
                        :regAtt['status']=='0'?Colors.blue[100]: Colors.red[100],
                    border: Border.all(
                      color: regAtt['status']=='1'  ? Colors.teal[100]
                          :regAtt['status']=='0'?Colors.blue[100]: Colors.red[100], // Set border color
                    ), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(2.0)), // Set rounded corner radius
                  ),
                  child: Text(getStatus(regAtt['status']),
                      style: TextStyle(
                          color:regAtt['status']=='1'  ? Colors.teal
                              :regAtt['status']=='0'?Colors.blue: Colors.red,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(children: [
              Text(
                'Created On',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(convertDate(regAtt['updatedOn'])),
            ]),
            SizedBox(
              width: 0,
            ),
          ],
        ),
      ),
    );
  }
}
