import 'package:dotted_line/dotted_line.dart';
import '../controllers/leave_controller.dart';
import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveListWidget extends StatelessWidget {
  final leave;
  final int index;
  final int length;
  final LeaveController lC;
  LeaveListWidget(this.leave, this.index, this.length, this.lC);

  final double firstWidth = 48.0;
  final double secondWidth = 7.0;
  final double rowAfterSize = 8.0;
  final double titleSize = 16.0;
  final double textSize = 16.0;

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() + '-' + DateFormat('MM').format(DateTime.parse(date)).toString() + '-' + DateFormat.y().format(DateTime.parse(date)).toString();
  }

  String getStatus(status) {
    if (status == 0) {
      return 'Pending';
    } else if (status == 1) {
      return 'Approved';
    } else {
      return 'Rejected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25.0,
          horizontal: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Emp ID',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  width: 71.0,
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  width: secondWidth,
                ),
                Text(
                  leave['empId'].toString(),
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(
              height: rowAfterSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 81.0,
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  width: secondWidth,
                ),
                Text(
                  leave['empName'].toString(),
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(
              height: rowAfterSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'From Date',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 44.0,
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  width: secondWidth,
                ),
                Flexible(
                  child: Text(
                    convertDate(leave['fromDateTime']),
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: rowAfterSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'To Date',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 65.0,
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  width: secondWidth,
                ),
                Text(
                  convertDate(leave['toDateTime']),
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: rowAfterSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Requested on',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 19.0,
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  width: secondWidth,
                ),
                Text(
                  convertDate(leave['createdDateTime']),
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: rowAfterSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Reason',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 70.0,
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  width: secondWidth,
                ),
                Flexible(
                  child: Text(
                    leave['reason'].toString(),
                    // maxLines: 5,
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: rowAfterSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Leave Type',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 37.0,
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  width: secondWidth,
                ),
                Text(
                  leave['leaveTypeName'].toString(),
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: rowAfterSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 78.0,
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  width: secondWidth,
                ),
                Text(
                  getStatus(
                    int.parse(leave['status']),
                  ),
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            leave['status'] == '0' && (RemoteServices().box.get('role') == '2' || RemoteServices().box.get('role') == '3')
                ? Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: Colors.grey,
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
                              onPressed: () {
                                lC.aprRejLeave(index, leave['id'], '2');
                              },
                              child: Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              color: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                lC.aprRejLeave(index, leave['id'], '1');
                              },
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
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
                      ),
                    ],
                  )
                : SizedBox(
                    height: 5.0,
                  ),
          ],
        ),
      ),
    );
  }
}
