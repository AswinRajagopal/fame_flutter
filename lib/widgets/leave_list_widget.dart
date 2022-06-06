import 'package:confirm_dialog/confirm_dialog.dart';
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
  final double sBox = 120.0;
  final double sBoxSpace = 10.0;

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString();
  }

  int dateDifference(date1, date2) {
    var fromDate = DateTime.parse(date1);
    var toDate = DateTime.parse(date2);

    return toDate.difference(fromDate).inDays;
  }

  String getStatus(status) {
    if (status == 0) {
      return 'Pending';
    } else if (status == 1) {
      return 'Approved';
    } else if (status == 2) {
      return 'Rejected';
    } else if (status == 3) {
      return 'Cancelled';
    } else {
      return 'Cancel Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(RemoteServices().box.get('empid'));
    // print(leave['empId']);
    print(RemoteServices().box.get('empid') != leave['empId']);
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
                SizedBox(
                  width: sBox,
                  child: Text(
                    'Name & Emp ID',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: sBoxSpace,
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
                  leave['empName'].toString() +
                      ' (' +
                      leave['empId'].toString() +
                      ')',
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
                SizedBox(
                  width: sBox,
                  child: Text(
                    'Date',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: sBoxSpace,
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
                    convertDate(leave['fromDate']) +
                        ' - ' +
                        convertDate(leave['toDate']),
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: dateDifference(leave['fromDate'], leave['toDate']) > 0,
              child: SizedBox(
                height: rowAfterSize,
              ),
            ),
            Visibility(
              visible: dateDifference(leave['fromDate'], leave['toDate']) > 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: sBox,
                    child: Text(
                      'Duration',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sBoxSpace,
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
                    dateDifference(leave['fromDate'], leave['toDate'])
                            .toString() +
                        " days",
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: rowAfterSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: sBox,
                  child: Text(
                    'Leave Type',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: sBoxSpace,
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
                SizedBox(
                  width: sBox,
                  child: Text(
                    'Reason',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: sBoxSpace,
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
                    leave['remarks'],
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
                SizedBox(
                  width: sBox,
                  child: Text(
                    'Requested On',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: sBoxSpace,
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
                  convertDate(leave['appliedOn']),
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
                SizedBox(
                  width: sBox,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: sBoxSpace,
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
                  leave['status'].length > 1
                      ? leave['status']
                      : getStatus(
                          int.parse(leave['status']),
                        ),
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            RemoteServices().box.get('empid') == leave['empId'] &&
                    int.parse(leave['status']) < 2
                ? DateTime.now().isAfter(DateTime.parse(leave['fromDate']))
                    ? Container()
                    : Column(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RaisedButton(
                                  onPressed: () async {
                                    if (await confirm(
                                      context,
                                      title: Text('Confirm!'),
                                      content: Text(
                                          'Are you sure, you want to cancel the leave?'),
                                      textOK: Text('Yes'),
                                      textCancel: Text('No'),
                                    )) {
                                      lC.aprRejLeave(index,
                                          leave['empLeaveHistoryId'], '3');
                                    }
                                  },
                                  child: Text(
                                    'Cancel',
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
                : Container(),
            (leave['status'] == '0' ||
                        leave['status'] == 'Pending' ||
                        leave['status'] == '4' ||
                        leave['status'] == 'Cancel Pending') &&
                    (RemoteServices().box.get('empid') != leave['empId'])
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
                                lC.aprRejLeave(
                                    index, leave['empLeaveHistoryId'], '2');
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
                                lC.aprRejLeave(
                                    index, leave['empLeaveHistoryId'], '1');
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
