import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvanceListWidget extends StatelessWidget {
  final advance;

  AdvanceListWidget(this.advance);

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString() +
        '\n @ ' +
        DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
        '' +
        DateFormat('a').format(DateTime.parse(date)).toString().toLowerCase();
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

  String numberFormatter(amountform) {
    var amount = int.parse(amountform.toStringAsFixed(0));
    var formatter = NumberFormat('#,##,000');
    return formatter.format(amount).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      advance['empName'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      advance['empId'].toString(),
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    )
                  ]),
                  SizedBox(
                    width: 30.0,
                  ),
                  Expanded(
                    child: Text(
                      advance['expenseType'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70.0,
                        height: 30.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          border: Border.all(
                            color: Colors.green[100], // Set border color
                          ), // Set border width
                          borderRadius: BorderRadius.all(Radius.circular(
                              2.0)), // Set rounded corner radius
                        ),
                        child: Text(
                          advance['purpose'].toString(),
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Column(children: [
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: 120,
                            child: Text(
                              numberFormatter(advance['amount']).toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
              SizedBox(
                width: 10.0,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          advance['createdOn'] != null
                              ? widgetDate(advance['createdOn']).toString()
                              : "-",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
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
      ),
    );
  }
}
