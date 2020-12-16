import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveListWidget extends StatelessWidget {
  final leave;
  final int index;
  final int length;
  LeaveListWidget(this.leave, this.index, this.length);

  final double firstWidth = 48.0;
  final double secondWidth = 7.0;
  final double rowAfterSize = 3.0;
  final double titleSize = 16.0;
  final double textSize = 16.0;

  String convertDate(date) {
    return DateFormat.d().format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.M().format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString();
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
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  width: 68.0,
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
                    fontWeight: FontWeight.bold,
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
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 45.0,
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
                    fontWeight: FontWeight.bold,
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
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 20.0,
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
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 66.0,
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
                    maxLines: 2,
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
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 40.0,
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
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 75.0,
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
                  leave['status'] == '0' ? 'Pending' : 'Approved',
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: leave['status'] == '0' ? 15.0 : 5.0,
            ),
            leave['status'] == '0'
                ? DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 1.0,
                    dashLength: 4.0,
                    dashColor: Colors.grey,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  )
                : Container(),
            leave['status'] == '0'
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          onPressed: () {},
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
                          onPressed: () {},
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
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
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
