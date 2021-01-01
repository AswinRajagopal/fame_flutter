import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart';

import '../controllers/transfer_controller.dart';
import 'package:flutter/material.dart';

class TransferListWidget extends StatelessWidget {
  final transfer;
  final int index;
  final int length;
  final TransferController tC;
  TransferListWidget(this.transfer, this.index, this.length, this.tC);

  final double firstWidth = 48.0;
  final double secondWidth = 7.0;
  final double rowAfterSize = 3.0;
  final double titleSize = 16.0;
  final double textSize = 16.0;

  String convertDate(date) {
    return DateFormat('dd').format(date).toString() + '-' + DateFormat('MM').format(date).toString() + '-' + DateFormat.y().format(date).toString();
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
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  width: 73.0,
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
                  transfer.empId,
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
                  width: 83.0,
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
                  transfer.empName,
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
                  'Current Unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 35.0,
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
                    transfer.fromUnitName,
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
                  'Required Unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 24.0,
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
                  transfer.toUnitName,
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
                  'Required on',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 36.0,
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
                  convertDate(transfer.fromPeriod),
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
                  'Requested By',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 22.0,
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
                    transfer.createdByName,
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
                  'Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(
                  width: 94.0,
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
                  convertDate(transfer.createdOn),
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
            Column(
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
                          tC.aprRejTransfer(transfer.empId, transfer.toUnit, transfer.orderId, '0');
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
                          tC.aprRejTransfer(transfer.empId, transfer.toUnit, transfer.orderId, '1');
                        },
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
