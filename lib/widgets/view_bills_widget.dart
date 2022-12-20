import 'package:custom_check_box/custom_check_box.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/utils/utils.dart';
import 'package:fame/views/view_bills_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class BillsListWidget extends StatefulWidget {
  final billsList;
  ExpenseController expC;
  BillsListWidget(this.billsList, this.expC);
  @override
  _BillsWidgetState createState() => _BillsWidgetState(this.billsList,this.expC);
}

class _BillsWidgetState extends State<BillsListWidget> {
  var billsList;
  ExpenseController expC;
  _BillsWidgetState(this.billsList,this.expC);
  bool _isChecked = false;

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
    return Column(
        children: [
          GestureDetector(
          onTap: () {
            Get.to(ViewBillsDetailList(this.billsList));
          },
          child: Card(
            margin:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
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
                            billsList['expenseBillId'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            billsList['empId'],
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          )
                        ]),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Text(
                            billsList['remarks'],
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
                                color: billsList['status'] == 1
                                    ? Colors.yellow[100]
                                    : Colors.red[100],
                                border: Border.all(
                                  color: billsList['status'] == 1
                                      ? Colors.yellow[100]
                                      : Colors.red[100],
                                ), // Set border width
                                borderRadius: BorderRadius.all(Radius.circular(
                                    2.0)), // Set rounded corner radius
                              ),
                              child: Text(
                                getStatus(billsList['status']),
                                style: TextStyle(
                                    color: billsList['status'] == 1
                                        ? Colors.yellow
                                        : Colors.red,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 30.0),
                        Column(children: [
                          IntrinsicWidth(
                            child: Column(
                              children: [
                                Container(
                                  width:100.0,
                                  child: Text(
                                    billsList['amount'].toString(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                widgetDate(billsList['createdOn']),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Spacer(),
                              CustomCheckBox(
                                shouldShowBorder: true,
                                borderColor: AppUtils().blueColor,
                                checkedFillColor: AppUtils().blueColor,
                                borderRadius: 5,
                                borderWidth: 3,
                                checkBoxSize: 22,
                                value: _isChecked,
                                onChanged: (bool value) {
                                  _isChecked = value;
                                  setState(() {
                                    var bill = billsList['expenseBillId'];
                                    if(value) {
                                      expC.selectedBills.add(bill);
                                    }else{
                                      expC.selectedBills.remove(bill);
                                    }
                                  });

                                },
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
          ),
        ),
        ]
    );
  }
}
